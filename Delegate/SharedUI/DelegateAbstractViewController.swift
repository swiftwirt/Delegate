//
//  DelegateAbstractViewController.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/1/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//
import UIKit

class DelegateAbstractViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView?
    
    fileprivate var currentScreenWidth: CGFloat = UIScreen.main.bounds.size.width
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardObserver()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
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
    
    func animate(views: [UIView], ofTheScreen: Bool, completion: (() -> ())? = nil)
    {
        ofTheScreen ? animateOfTheScreen(views: views, completion: completion) : animateOnTheScreen(views: views, completion: completion)
    }
    
    fileprivate func animateOfTheScreen(views: [UIView], completion: (() -> ())?)
    {
        for (index, element) in views.enumerated() {
            UIView.animate(withDuration: AnimationDuration.defaultSlide, delay: 0.2, options: .curveEaseInOut, animations: {
                index % 2 == 0 ? (element.frame.origin.x -= self.currentScreenWidth) : (element.frame.origin.x += self.currentScreenWidth)
            })
        }
        completion?()
    }
    
    fileprivate func animateOnTheScreen(views: [UIView], completion: (() -> ())?)
    {
        for (index, element) in views.enumerated() {
            UIView.animate(withDuration: AnimationDuration.defaultSlide, delay: 0.4, options: .curveEaseInOut, animations: {
                index % 2 == 0 ? (element.frame.origin.x += self.currentScreenWidth) : (element.frame.origin.x -= self.currentScreenWidth)
            })
        }
        completion?()
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
        guard let scrollView = scrollView else { return }
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollView.contentInset = contentInsets
    }
}
