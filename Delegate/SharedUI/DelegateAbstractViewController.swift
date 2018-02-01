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
    
    fileprivate var currentScreenWidth: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardObserver()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        currentScreenWidth = UIScreen.main.bounds.size.width
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
        ofTheScreen ? animateOfTheScreen(views: views) : animateOnTheScreen(views: views)
    }
    
    fileprivate func animateOfTheScreen(views: [UIView])
    {
        for (index, element) in views.enumerated() {
            UIView.animate(withDuration: 0.6, delay: 0.2, options: .curveEaseInOut, animations: {
                index % 2 == 0 ? (element.frame.origin.x -= self.currentScreenWidth) : (element.frame.origin.x += self.currentScreenWidth)
            })
        }
    }
    
    fileprivate func animateOnTheScreen(views: [UIView])
    {
        for (index, element) in views.enumerated() {
            UIView.animate(withDuration: 0.6, delay: 0.2, options: .curveEaseInOut, animations: {
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
        guard let scrollView = scrollView else { return }
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollView.contentInset = contentInsets
    }
}
