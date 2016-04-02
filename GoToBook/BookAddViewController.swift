//
//  BookAddViewController.swift
//  GoToBook
//
//  Created by Nurzhan Sagyndyk on 01.04.16.
//  Copyright © 2016 Nurzhan Sagyndyk. All rights reserved.
//

import UIKit
import Firebase

class BookAddViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var firebase : Firebase!
    var viaSegue: String = ""
    

    @IBOutlet weak var BookNameTextField: UITextField!
    
    @IBAction func AddBookAction(sender: UIButton) {
        firebase = Firebase(url: "https://gotobook.firebaseio.com/books")
        let name = BookNameTextField.text ?? ""
        var data: NSData = NSData()
        if let image = BookPhotoImageView.image {
            data = UIImageJPEGRepresentation(image,0.1)!
        }
        
        let base64String = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        let book: NSDictionary = ["title":name,"photoBase64":base64String]
        
        //add firebase child node
        let profile = firebase.ref.childByAppendingPath(name)
        
        // Write data to Firebase
        profile.setValue(book)
        
        navigationController?.popViewControllerAnimated(true)
        
        print("It works")
        print(viaSegue)

        
    }
    @IBOutlet weak var BookPhotoImageView: UIImageView!
    
    @IBOutlet weak var SaveButton: UIBarButtonItem!
    
    @IBAction func saveBook(sender: UIBarButtonItem) {
        firebase = Firebase(url: "https://gotobook.firebaseio.com/profiles")
        let name = BookNameTextField.text ?? ""
        var data: NSData = NSData()
        if let image = BookPhotoImageView.image {
            data = UIImageJPEGRepresentation(image,0.1)!
        }
        
        let base64String = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        let book: NSDictionary = ["title":name,"photoBase64":base64String]
        
        //add firebase child node
        let profile = firebase.ref.childByAppendingPath("books")
        
        let userFirebase = firebase.ref.childByAppendingPath("\(viaSegue)")
        userFirebase.setValue(profile)
        profile.setValue(book)
        
        navigationController?.popViewControllerAnimated(true)
        
        print("It works")
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func selectImageGestureRecognizer(sender: UITapGestureRecognizer) {
        BookNameTextField.resignFirstResponder()
        let imagePicker: UIImagePickerController
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .Camera
            
            presentViewController(imagePicker, animated: true, completion: nil)
        } else {
            imagePicker =  UIImagePickerController()
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .PhotoLibrary
            imagePicker.delegate = self
            presentViewController(imagePicker, animated: true, completion:nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        BookPhotoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if SaveButton === sender {
            firebase = Firebase(url: "https://gotobook.firebaseio.com/profiles")
            let name = BookNameTextField.text ?? ""
            var data: NSData = NSData()
            if let image = BookPhotoImageView.image {
                data = UIImageJPEGRepresentation(image,0.1)!
            }
            
            let base64String = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
            
            let book: NSDictionary = ["title":name,"photoBase64":base64String]
            
            //add firebase child node
            let profile = firebase.ref.childByAppendingPath("books")
            
            // Write data to Firebase
            profile.setValue(book)
            
            navigationController?.popViewControllerAnimated(true)
        }
        else {print("Save is not sender")}
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        SaveButton.enabled = false
    }
    
    func checkValidBookName() {
        // Disable the Save button if the text field is empty.
        let text = BookNameTextField.text ?? ""
        SaveButton.enabled = !text.isEmpty
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidBookName()
        navigationItem.title = textField.text
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        BookNameTextField.delegate = self
        viaSegue = "Ss"
        
        // Enable the Save button only if the text field has a valid Meal name.
        checkValidBookName()
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
