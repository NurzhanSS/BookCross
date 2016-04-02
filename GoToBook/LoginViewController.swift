//
//  LoginViewController.swift
//  GoToBook
//
//  Created by Nurzhan Sagyndyk on 01.04.16.
//  Copyright © 2016 Nurzhan Sagyndyk. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var PasswordLoginTextField: UITextField!
    @IBOutlet weak var EmailLoginTextField: UITextField!
    
    let ref = Firebase(url: "https:https://gotobook.firebaseio.com")
    var email: String?
    @IBAction func LoginAction(sender: AnyObject) {
        email = EmailLoginTextField.text
        if PasswordLoginTextField.text != "" && EmailLoginTextField.text != "" {
        ref.authUser(EmailLoginTextField.text, password: PasswordLoginTextField.text,
            withCompletionBlock: { error, authData in
                if error != nil {
                    print("There was an error logging in to this account")
                } else {
                    print("We are now logged in")
                }
            })
        }else {
            loginErrorAlert("Oops", message: "Please enter your email and password")
        }
    }
    
    
    
    
    func loginCaption() -> String{
        return EmailLoginTextField.text!
    }
    func loginErrorAlert(title: String, message: String) {
        
        // Called upon login error to let the user know login didn't work.
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SendDataSegue" {
            if let destination = segue.destinationViewController as? BookAddViewController {
                destination.viaSegue = email!
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
