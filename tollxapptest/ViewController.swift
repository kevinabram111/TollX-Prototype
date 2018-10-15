//
//  ViewController.swift
//  tollxapptest
//
//  Created by Kevin Abram on 8/14/17.
//  Copyright © 2017 Binus. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import CoreData

class ViewController: UIViewController{
    
    @IBOutlet weak var signinbutton: UIButton?
    @IBOutlet weak var signupbutton: UIButton?
    @IBOutlet weak var signinsuccess: UILabel?
    @IBOutlet weak var emailtextbox: UITextField?
    @IBOutlet weak var passwordtextbox: UITextField?
    
    var users: [User] = []
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        /*
         self.navigationController?.isNavigationBarHidden = true
         signinbutton?.layer.cornerRadius = 10
         signinbutton?.layer.borderWidth = 0
         signinbutton?.layer.borderColor = UIColor.white.cgColor
         
         signupbutton?.layer.cornerRadius = 10
         signupbutton?.layer.borderWidth = 0
         signupbutton?.layer.borderColor = UIColor.white.cgColor
         
         emailtextbox?.layer.borderColor = UIColor.blue.cgColor
         print("b")
         passwordtextbox?.layer.borderColor = UIColor.blue.cgColor
         */
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func loginclick(_ sender: Any) {
        if emailtextbox?.text == "" || passwordtextbox?.text == ""
        {
            let alert = UIAlertView()
            alert.title = "Log In Failed"
            alert.message = "Please fill in the email address and password"
            alert.addButton(withTitle: "Ok")
            alert.show()
        }
        else
        {
            var loginsuccess = false
            let namefetchequest = NSFetchRequest<NSManagedObject>(entityName : "User")
            do
            {
                let userObject = try managedObjectContext.fetch(namefetchequest)
                self.users = userObject as! [User]
            }
            catch let error as NSError
            {
                print(error)
            }
            for User in users
            {
               if (User.value(forKey: "email") as! String) == emailtextbox?.text && (User.value(forKey: "password") as! String) == passwordtextbox?.text
                  {
                       loginsuccess = true
                  }
            }
            
                if loginsuccess == true
                  {
//                    let alert = UIAlertView()
//                    alert.title = "Log In Successfull!"
//                    alert.message = "Login Sucess!!"
//                    alert.addButton(withTitle: "Ok")
//                    alert.show()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "Home")
                    self.present(controller, animated: true, completion: nil)
                    
                }
                else if loginsuccess == false
                {
//                    let alert = UIAlertView()
//                    alert.title = "Log In Failed"
//                    alert.message = "Incorrect email and/or password"
//                    alert.addButton(withTitle: "Ok")
//                    alert.show()
                }
        }
        
    }
    
}

