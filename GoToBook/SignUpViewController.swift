//
//  ViewController.swift
//  GoToBook
//
//  Created by Nurzhan Sagyndyk on 01.04.16.
//  Copyright © 2016 Nurzhan Sagyndyk. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    let ref = Firebase(url: "https://gotobook.firebaseio.com")
    var USER_REF = Firebase(url: "https://gotobook.firebaseio.com/users")
    var userInfo: Firebase!

    @IBAction func SignUpButton(sender: AnyObject) {
        ref.createUser(EmailTextField.text, password: PasswordTextField.text,
            withValueCompletionBlock: { error, result in
                
                if error != nil {
                    print("There was an error creating the account")
                } else {
                    let uid = result["uid"] as? String
                    print("Successfully created user account with uid: \(uid)")
                    DataFirebase.dataService.BASE_REF.authUser(self.EmailTextField.text, password: self.PasswordTextField.text, withCompletionBlock: {
                        err, authData in
                        
                        let user = ["provider": authData.provider!, "email": self.EmailTextField!.text!, "password": self.PasswordTextField!.text!]
                        
                        DataFirebase.dataService.createNewAccount(authData.uid, user: user)
                    })
                    self.performSegueWithIdentifier("addBook", sender: nil)

                }
        })

    }
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        userInfo = ref.childByAppendingPath("users")
        
    }

    @IBAction func cancelRegistration(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

