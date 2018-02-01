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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardObserver()
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
