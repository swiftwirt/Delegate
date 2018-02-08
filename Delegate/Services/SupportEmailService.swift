//
//  SupportEmailService.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/8/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class SupportEmailService: NSObject, MFMailComposeViewControllerDelegate {
    
    #if INTERNAL_BUILD
    // Delegate Internal App
    let supportEmails = ["ivashindev@gmail.com", "labuten10@gmail.com"]
    let buildType = "INTERNAL BUILD"
    #else
    // App Store and Test flight builds
    let supportEmails = ["swiftwirt@gmail.com"] // TODO: create support email
    let buildType = ""
    #endif
    
    fileprivate weak var viewController = UIViewController()
    
    func presentEmailController(inViewController: UIViewController)
    {
        viewController = inViewController
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            viewController?.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    fileprivate func configuredMailComposeViewController() -> MFMailComposeViewController
    {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .full
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "EEE yyyy/MM/dd  HH.mm"
        mailComposerVC.setToRecipients(supportEmails)
        mailComposerVC.setSubject("Delegate Problem Report \(dateFormatter.string(from: Date())) \(buildType)")
        mailComposerVC.setMessageBody("Please tell us a bit about the problem:\n\n", isHTML: false)
        dateFormatter.dateFormat = "yyyy.MM.dd_HH.mm"
        mailComposerVC.addAttachmentData(Logger.collectLogFiles() as Data, mimeType: "application/octet-stream", fileName: "\(dateFormatter.string(from: Date())).brpt")
        return mailComposerVC
    }
    
    fileprivate func showSendMailErrorAlert()
    {
        let alertViewController = UIAlertController(title: NSLocalizedString("Could Not Send Email", comment: "Email sending failure alert title"),
                                                    message: NSLocalizedString("Your device could not send e-mail.  Please check e-mail configuration and try again.", comment: "Email sending failure alert message"), preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK button title"),
                                                    style: UIAlertActionStyle.destructive,
                                                    handler:nil))
        viewController?.present(alertViewController, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
