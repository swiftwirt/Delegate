//
//  FirebaseService.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/2/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import Firebase
import RxSwift
import Alamofire
import SwiftyJSON

class FirebaseService {
    
    enum EndPoint
    {
        static let baseUrl = "https://delegate-100d7.firebaseio.com/"
        static let users = "users/"
        static let teams = "teams/"
        static let settings = "/settings/"
        static let postfix = ".json"
    }
    
    fileprivate let databaseReference = Database.database().reference()
    fileprivate let storage = Storage.storage()
    fileprivate let database = Database.database()
    
    fileprivate let disposeBag = DisposeBag()
    
    private func request(_ url: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil) -> Observable<Data> {
        return Observable.create({ (observer) -> Disposable in
            
            Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).validate().responseData { (response: DataResponse<Data>) in
                
                switch(response.result) {
                case .success(let data):
                    
                    observer.on(.next(data))
                    observer.on(.completed)
                    
                case .failure(let error):
                    
                    guard let data = response.data, let code = JSON(data: data)[JSONError.errorCode].string, let errorCode = Int(code) else {
                        
                        guard let error = error as? NSError, error.code != ErrorResponseCode.requestCanceled.rawValue else {
                            // Stay silent for case Error Domain=NSURLErrorDomain Code=-999 "cancelled"
                            observer.onCompleted()
                            return
                        }
                        
                        guard let noConnectionError = error as? NSError, noConnectionError.code != ErrorResponseCode.noConnection.rawValue else {
                            // Show internal no connection alert
                            AlertHandler.showNoInternetConnectionBanner()
                            observer.onCompleted()
                            return
                        }
                        
                        guard let slowConnectionError = error as? NSError, slowConnectionError.code != ErrorResponseCode.timeOutRequest.rawValue else {
                            // Show internal slow connection alert
                            AlertHandler.showInternetTroublesBanner()
                            observer.onCompleted()
                            return
                        }
                        
                        guard let SSLConnectionError = error as? NSError, SSLConnectionError.code != ErrorResponseCode.SSLError.rawValue else {
                            // Show internal slow connection alert
                            AlertHandler.showInternetTroublesBanner()
                            observer.onCompleted()
                            return
                        }
                        
                        observer.on(.error(error))
                        return
                    }
                    
                    observer.on(.error(error))
                }
            }
            return Disposables.create()
        })
    }
    
    func login(email: String, password: String) -> Observable<DLGUser>
    {
        return Observable.create({ (observer) -> Disposable in
            
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                
                guard let firebaseUser = user, error == nil else {
                    // TODO: handle expected errors
                    observer.on(.error(error!))
                    return
                }
                
                let user = DLGUser()
                user.email = firebaseUser.email
                user.uid = firebaseUser.uid
                
                observer.onNext(user)
                observer.onCompleted()
            }
            return Disposables.create()
        })
    }
    
    func signup(email: String, password: String) -> Observable<Void>
    {
        return Observable.create({ (observer) -> Disposable in
            
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                
                guard error == nil else {
                    // TODO: handle expected errors
                    observer.on(.error(error!))
                    return
                }
                observer.onNext(())
                observer.onCompleted()
            }
            return Disposables.create()
        })
    }
    
    func updatePassword(_ password: String)
    {
        Auth.auth().currentUser?.updatePassword(to: password, completion: nil)
    }
    
    func updateEmail(_ email: String)
    {
        Auth.auth().currentUser?.updateEmail(to: email, completion: nil)
    }
    
    func resetPassword(for email: String) -> Observable<Void>
    {
        return Observable.create({ (observer) -> Disposable in
            Auth.auth().languageCode = Locale.current.languageCode
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                guard error == nil else {
                    // TODO: handle expected errors
                    observer.on(.error(error!))
                    return
                }
                observer.onCompleted()
            }
            return Disposables.create()
        })
    }
    
    func fetchUser(uid: String) -> Observable<JSON>
    {
        let url = EndPoint.baseUrl + EndPoint.users + uid + EndPoint.postfix
        
        return request(url).mapJSON()
    }
    
    func fetchUserSettings(uid: String) -> Observable<JSON>
    {
        let url = EndPoint.baseUrl + EndPoint.users + uid + EndPoint.settings + EndPoint.postfix
        
        return request(url).mapJSON()
    }
    
    func update(user: DLGUser) -> Observable<Void>
    {
        guard let uid = user.uid else {
            return Observable.empty()
        }
        
        return Observable.create({ (observer) -> Disposable in
            
            let usersReference = self.databaseReference.child(FirebaseKey.users.rawValue).child(uid)
            usersReference.updateChildValues(ParametersConfigurator.userUpdateParameters(user), withCompletionBlock: { (error, reference) in
                guard error == nil else {
                    // TODO: handle expected errors
                    observer.on(.error(error!))
                    return
                }
                
                observer.onCompleted()
            })
            return Disposables.create()
        })
    }
    
    func updateUser(property: FirebaseKey, value: Any?) -> Observable<Void>
    {
        guard let uid = Auth.auth().currentUser?.uid, let value = value else {
            return Observable.empty()
        }
        
        return Observable.create({ (observer) -> Disposable in
            
            let usersReference = self.databaseReference.child(FirebaseKey.users.rawValue).child(uid)
            
            usersReference.updateChildValues([property.rawValue: value], withCompletionBlock: { (error, reference) in
                guard error == nil else {
                    // TODO: handle expected errors
                    observer.on(.error(error!))
                    return
                }
                observer.onCompleted()
            })
            return Disposables.create()
        })
    }
    
    func saveAdded(avatar: UIImage) -> Observable<String>
    {
        return Observable.create({ (observer) -> Disposable in
            
            self.upload(avatar).subscribe(onNext: { (link) in
                guard let userUID = Auth.auth().currentUser?.uid, let link = link else { return }
                let usersReference = self.databaseReference.child(FirebaseKey.users.rawValue).child(userUID)
                usersReference.updateChildValues([FirebaseKey.avatarLink : link])
                observer.onNext(link)
                observer.onCompleted()
            }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        })
        
    }
    
    func updateSettings(settings: Settings?)
    {
        guard let uid = Auth.auth().currentUser?.uid, let settings = settings else { return }
        let usersReference = self.databaseReference.child(FirebaseKey.users.rawValue).child(uid)
        let targetRefrence = usersReference.child(FirebaseKey.settings.rawValue)
        targetRefrence.updateChildValues(ParametersConfigurator.userSettingsUpdateParameters(settings))
    }
    
    fileprivate func upload(_ avatar: UIImage) -> Observable<String?>
    {
        return Observable.create({ (observer) -> Disposable in
            guard let userUID = Auth.auth().currentUser?.uid else { observer.onCompleted(); return Disposables.create() }
            let imageData: Data! = UIImagePNGRepresentation(avatar)!
            
            let users = self.storage.reference().child(FirebaseKey.users.rawValue)
            let currentUser = users.child(userUID)
            
            // Upload file to Firebase Storage
            let metaData = StorageMetadata()
            metaData.contentType = "image/png"
            
            currentUser.putData(imageData, metadata: metaData).observe(.success) { (snapshot) in
                // When the image has successfully uploaded, we get it's download URL
                if let text = snapshot.metadata?.downloadURL()?.absoluteString {
                    observer.onNext(text)
                    observer.onCompleted()
                } else {
                    observer.onNext(nil)
                    observer.onCompleted()
                }
            }
            
            return Disposables.create()
        })
        
    }
    
    func updateTeam(_ team: Team) -> Observable<String>
    {
        let id = team.id ?? NSUUID().uuidString

        return Observable.create({ (observer) -> Disposable in
            
            let usersReference = self.databaseReference.child(EndPoint.teams).child(id)
            usersReference.updateChildValues(ParametersConfigurator.parametersForTeam(team), withCompletionBlock: { (error, reference) in
                guard error == nil else {
                    // TODO: handle expected errors
                    observer.on(.error(error!))
                    return
                }
                observer.onNext(id)
                observer.onCompleted()
            })
            return Disposables.create()
        })
    }
    
    static func logOut()
    {
        try? Auth.auth().signOut()
    }
    
}
