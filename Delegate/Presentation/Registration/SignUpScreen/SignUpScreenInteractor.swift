//
//  SignUpScreenInteractor.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/2/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Firebase
import SwiftyJSON
import PKHUD
import FirebaseAuth
import GoogleSignIn

class SignUpScreenInteractor: NSObject {
    
    var output: SignUpScreenPresenter!
    var input: SignUpScreenRouter!
    
    var applicationManager = ApplicationManager.instance()
    
    fileprivate let disposeBag = DisposeBag()
    
    override init() {
        super.init()
        GIDSignIn.sharedInstance().delegate = self
    }
    
    func configureTextFields()
    {
        output.configureEmailTextField(with: Strings.email, color: Color.textFieldPlaceholder)
        output.configurePasswordTextField(with: Strings.password, color: Color.textFieldPlaceholder)
        output.configureRepeatPasswordTextField(with: Strings.repeatPassword, color: Color.textFieldPlaceholder)
    }
    
    func handleLoginTaps()
    {
        _ = output.loginButtonObservable.bind {
            self.input.routeToLogin()
        }
    }
    
    fileprivate var hasValidEmail: String?
    {
        let email = output.currentEmailInputValue ?? ""
        
        do {
            try applicationManager.validationService.validate(email: email)
            output.addEmailValidationError(message: nil, result: .undefined)
            return email
        } catch {
            output.addEmailValidationError(message: error.localizedDescription, result: .invalid(errorMessage: nil))
        }
        // nil is used to detect that current input is not a valid email
        return nil
    }
    
    fileprivate var hasValidPassword: String?
    {
        let password = output.currentPasswordInputValue ?? ""
        let confirmedPassword = output.currentRepeatPasswordInputValue ?? ""
        
        do {
            
            try applicationManager.validationService.checkPasswords(password, with: confirmedPassword)
            output.addPasswordValidationError(message: nil, result: .undefined)
            output.addRepeatPasswordValidationError(message: nil, result: .undefined)
            return confirmedPassword
            
        } catch let error as PasswordValidationError {
            switch error {
            case .passwordEmpty, .passwordIncorrectFormat:
                output.addPasswordValidationError(message: error.localizedDescription, result: .invalid(errorMessage: nil))
            case .passworConfirmedEmpty, .passwordIdentity:
                output.addRepeatPasswordValidationError(message: error.localizedDescription, result: .invalid(errorMessage: nil))
            }
        } catch {
            // Should never reach to this point
            applicationManager.alertHandler.showUnknownError()
        }
        return nil
    }
    
    func handleSignUpTaps()
    {
        let taps: Observable<Void> = Observable.merge([output.signupButtonObservable, output.endOnExitRepeatPasswordInputEvent])
        taps.takeUntil(self.output.output.rx.deallocated).flatMapFirst { [unowned self] () -> Observable<Void> in
            
            guard let email = self.hasValidEmail, let password = self.hasValidPassword else { return Observable.empty() }
            
            return self.applicationManager.apiService.signup(email: email, password: password)
            
            }.subscribe(onNext: { [weak self] in
                
                self?.applicationManager.userService.createNewUser()
                self?.applicationManager.userService.user?.email = Auth.auth().currentUser?.email
                self?.applicationManager.userService.user?.uid = Auth.auth().currentUser?.uid
                self?.input.routeToPresentation()
            }).disposed(by: disposeBag)
    }
    
    func observeLogInFacebookTap()
    {
        self.output.output.needsAnimation = true
        output.facebookButtonObservable.flatMapLatest { [unowned self] () -> Observable<FacebookCredentials?> in
            
            let facebookService = self.applicationManager.facebookService
            facebookService.logOut()
            
            return facebookService.authWithFacebook(viewController: self.output.output).catchError { (error) in
                HUD.flash(.labeledError(title: ErrorMessage.error, subtitle: ErrorMessage.fbLoginFailed), delay:  AnimationDuration.defaultFade)
                return Observable.empty()
            }
            
            }.subscribe(onNext: { [weak self] (facebookCredentials) in
                self?.output.output.needsAnimation = false
                guard let token = facebookCredentials?.token else {
                    // here we know that FBLogin canceled and safari controller was dissmissed
                    return
                }
                let credentials = FacebookAuthProvider.credential(withAccessToken: token)
                
                Auth.auth().signIn(with: credentials) { [weak self] (user, error) in
                    
                    if let error = error {
                        AlertHandler.showSpecialAlert(with: ErrorMessage.error, message: error.localizedDescription) { [weak self] _ in
                            self?.output.output.needsAnimation = true
                        }
                        return
                    }

                    self?.input.routeToPresentation()
                }
                }, onError: { error in
                    AlertHandler.showSpecialAlert(with: ErrorMessage.error, message: error.localizedDescription) { [weak self] _ in
                        self?.output.output.needsAnimation = true
                    }
            }).disposed(by: disposeBag)
    }
    
    func observeLogInTwitterTap()
    {
        self.output.output.needsAnimation = true
        _ = output.twitterButtonObservable.flatMapLatest { [unowned self] () -> Observable<Void> in
            
            return self.applicationManager.socialsWithFirebaseService.register(with: .twitter).catchError({ (error) -> Observable<(Void)> in
                self.output.output.needsAnimation = false
                AlertHandler.showSpecialAlert(with: ErrorMessage.error, message: error.localizedDescription) { [weak self] _ in
                    self?.output.output.needsAnimation = true
                }
                return Observable.empty()
            })
            }.subscribe(onNext: { [weak self] in
                self?.input.routeToPresentation()
            }).disposed(by: disposeBag)
    }
    
    func observeLogInGoogleTaps()
    {
        _ = output.googleplusButtonObservable.bind {
            self.output.output.tryGoogleSignIn()
        }
    }
    
    func observeLogInLInkedINTaps()
    {
        _ = output.linkedinButtonObservable.bind {
            _ = self.applicationManager.socialsWithFirebaseService.registerLinkedIN().catchError({ (error) -> Observable<JSON?> in
                self.output.output.needsAnimation = false
                guard error.code == ErrorCode.linkedInCanceled else {
                    AlertHandler.showSpecialAlert(with: ErrorMessage.error, message: error.localizedDescription) { [weak self] _ in
                        self?.output.output.needsAnimation = true
                    }
                    return Observable.empty()
                }
                AlertHandler.showSpecialAlert(with: ErrorMessage.error, message: ErrorMessage.linkedInCanceled) { [weak self] _ in
                    self?.output.output.needsAnimation = true
                }
                return Observable.empty()
            }).subscribe(onNext: { (result) in
                
                guard let email = result?[JSONKey.emailAddress].string, let password = result?[JSONKey.id].string else { return }
                
                self.applicationManager.apiService.login(email: email, password: password).catchError { (error) -> Observable<DLGUser> in
                    
                    switch error.code {
                    case Int(ErrorCode.noFirebaseUserRegistered)!:
                        self.applicationManager.apiService.signup(email: email, password: password).catchError { (error) -> Observable<Void> in
                            do {
                                try self.applicationManager.validationService.handle(remoteResponce: error)
                            } catch {
                                AlertHandler.showSpecialAlert(with: ErrorMessage.error, message: error.localizedDescription) { [weak self] _ in
                                    self?.output.output.needsAnimation = true
                                }
                            }
                            
                            return Observable.empty()
                            }.subscribe(onNext: { [weak self] (user) in
                                self?.applicationManager.userService.createNewUser()
                                self?.applicationManager.userService.user?.email = Auth.auth().currentUser?.email
                                self?.applicationManager.userService.user?.uid = Auth.auth().currentUser?.uid
                                self?.input.routeToPresentation()
                            }).disposed(by: self.disposeBag)
                    default:
                        do {
                            try self.applicationManager.validationService.handle(remoteResponce: error)
                        } catch {
                            AlertHandler.showSpecialAlert(with: ErrorMessage.error, message: error.localizedDescription) { [weak self] _ in
                                self?.output.output.needsAnimation = true
                            }
                        }
                    }
                    
                    return Observable.empty()
                    }.subscribe(onNext: { [weak self] (user) in
                        self?.input.routeToPresentation()   
                    }).disposed(by: self.disposeBag)
                
            }).disposed(by: self.disposeBag)
        }
    }
}

extension SignUpScreenInteractor: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        
        if let error = error {
            self.output.output.needsAnimation = false
            AlertHandler.showSpecialAlert(with: ErrorMessage.error, message: error.localizedDescription) { [weak self] _ in
                self?.output.output.needsAnimation = true
            }
            return
        }
        
        guard let authentication = user.authentication else {
            self.output.output.needsAnimation = false
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (user, error) in
            self.output.output.needsAnimation = false
            if let error = error {
                AlertHandler.showSpecialAlert(with: ErrorMessage.error, message: error.localizedDescription) { [weak self] _ in
                    self?.output.output.needsAnimation = true
                }
                return
            }
            self.input.routeToPresentation()
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        if let error = error {
            self.output.output.needsAnimation = false
            AlertHandler.showSpecialAlert(with: ErrorMessage.error, message: error.localizedDescription) { [weak self] _ in
                self?.output.output.needsAnimation = true
            }
            return
        }
    }

}
