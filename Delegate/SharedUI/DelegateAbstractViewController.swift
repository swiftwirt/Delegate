//
//  DelegateAbstractViewController.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/1/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//
import UIKit
import GoogleSignIn

class DelegateAbstractViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView? // Hook it up!
    
    var needsAnimation = true
    
    fileprivate var currentScreenWidth: CGFloat = UIScreen.main.bounds.size.width
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        needsAnimation = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    func tryGoogleSignIn()
    {
        GIDSignIn.sharedInstance().signIn()
    }
    
    fileprivate func addKeyboardObserver()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(scrollContentUp(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(scrollContentDown(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func switchFrom(one responder: UIResponder, to anotherResponder: UIResponder)
    {
        responder.resignFirstResponder()
        anotherResponder.becomeFirstResponder()
    }
    
    func animate(views: [UIView], ofTheScreen: Bool)
    {
        guard needsAnimation else { return }
        ofTheScreen ? animateOfTheScreen(views: views) : animateOnTheScreen(views: views)
    }
    
    fileprivate func animateOfTheScreen(views: [UIView])
    {
        for (index, element) in views.enumerated() {
            UIView.animate(withDuration: AnimationDuration.defaultSlide, delay: 0.2, options: .curveEaseInOut, animations: {
                index % 2 == 0 ? (element.frame.origin.x -= self.currentScreenWidth) : (element.frame.origin.x += self.currentScreenWidth)
            })
        }
    }
    
    fileprivate func animateOnTheScreen(views: [UIView])
    {
        for (index, element) in views.enumerated() {
            UIView.animate(withDuration: AnimationDuration.defaultSlide, delay: 0.4, options: .curveEaseInOut, animations: {
                index % 2 == 0 ? (element.frame.origin.x += self.currentScreenWidth) : (element.frame.origin.x -= self.currentScreenWidth)
            })
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

@objc extension DelegateAbstractViewController
{
    func scrollContentUp(_ sender: Notification)
    {
        if let keyboardSize = sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect, let scrollView = scrollView {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            scrollView.contentInset = contentInsets
        }
    }
    
    func scrollContentDown(_ sender: Notification)
    {
        if let scrollView = scrollView {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            scrollView.contentInset = contentInsets
        }
    }
}

