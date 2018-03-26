      //
//  AppDelegate.swift
//  Sample
//
//  Created by Mahendar on 8/5/17.
//  Copyright © 2017 Mahendar. All rights reserved.
//

import UIKit

let headerColor = UIColor(red:32.0/255.0,green:36.0/255.0,blue:76.0/255.0,alpha:1.0)
//let defaultColor = UIColor(red:25.0/255.0,green:120.0/255.0,blue:176.0/255.0,alpha:1.0)

public struct A12
{
    public var i : Int!
}

class LoginViewController: UIViewController, UITextFieldDelegate,CustomAlertDelegate
{
    @IBOutlet weak var emailView : UIView!
    @IBOutlet weak var passwdView : UIView!
    var alertView = CustomAlertViewController.init()
    @IBOutlet weak var emailTextField : UITextField!
    @IBOutlet weak var passwdTextField : UITextField!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        /*------------------------------------------------------
         Below code if for preparing alert view for presenting as alert box and setting the delegate as current class
         ------------------------------------------------------*/
        alertView = self.storyboard?.instantiateViewController(withIdentifier: Constants.kCustomAlertViewController) as! CustomAlertViewController
        alertView.delegate = self
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        /*------------------------------------------------------
          For making email text field first responder on tap
         ------------------------------------------------------*/
        
        let emailTapped = UITapGestureRecognizer(target:self,action:#selector(LoginViewController.emailTapped(tap:)))
        
        /*------------------------------------------------------
         For making password text field first responder on tap
         ------------------------------------------------------*/
        
        let paswordTapped = UITapGestureRecognizer(target:self,action:#selector(LoginViewController.passwordTapped(tap:)))
        
        emailView.addGestureRecognizer(emailTapped)
        
        passwdView.addGestureRecognizer(paswordTapped)
    }
    func okBtnAction()
    {
        print("true")
    }
    /*------------------------------------------------------
     MARK: - Navigation
     In a storyboard-based application, you will often want to do a little preparation before navigation
     ------------------------------------------------------*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        /*------------------------------------------------------
          Get the new view controller using segue.destinationViewController.
          Pass the selected object to the new view controller.
         ------------------------------------------------------*/
        if segue.identifier ==  Constants.kshowLanding
        {
            if let landingVC = segue.destination as? LandingViewController
            {
                landingVC.username = emailTextField.text!
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        emailTextField.text = "test1@test.com"
        passwdTextField.text = "abcd"
        
        /*------------------------------------------------------
        dummy login for testing purpose
        Aquire both the rights 1. Assembler 2. Surgery
        ------------------------------------------------------*/
        
//      emailTextField.text = "abc@gmail.com"
//      passwdTextField.text = "abc"
        
        /*------------------------------------------------------
        dummy login for testing purpose
        Aquire just one right 1. Assembler
        ------------------------------------------------------*/
        
//        emailTextField.text = "abcd@gmail.com"
//        passwdTextField.text = "abcd"
        
        /*------------------------------------------------------
        dummy login for testing purpose
        Aquire just one right 1. Surgery
        ------------------------------------------------------*/
        
//        emailTextField.text = "test123@gmail.com"
//        passwdTextField.text = "test"
    }
    
    override func didReceiveMemoryWarning()
    {
        /*------------------------------------------------------
         Dispose of any resources that can be recreated.
         ------------------------------------------------------*/
        
        super.didReceiveMemoryWarning()
    }
    
    func emailTapped(tap: UITapGestureRecognizer)
    {
        emailTextField.becomeFirstResponder()
    }
    
    func passwordTapped(tap: UITapGestureRecognizer)
    {
        passwdTextField.becomeFirstResponder()
    }
    
    /*------------------------------------------------------
     MARK: - UITextField delegate Method
     ------------------------------------------------------*/
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        /*------------------------------------------------------
         Set email text field border width
         ------------------------------------------------------*/
        
        emailTextField.layer.borderWidth = 2.0
        passwdTextField.layer.borderWidth = 2.0
        
        /*------------------------------------------------------
         Set email text field border color
         ------------------------------------------------------*/
        
        emailTextField.layer.borderColor = UIColor.clear.cgColor
        passwdTextField.layer.borderColor = UIColor.clear.cgColor
    }

    /*------------------------------------------------------
     MARK: - login Method
     ------------------------------------------------------*/
    @IBAction func loginPressed(_ sender : UIButton)
    {
        if emailTextField.text?.characters.count == 0
        {
            self.emailTextField.layer.borderColor = UIColor.red.cgColor

            CommanMethods.alertView(message: Constants.kAlertPlease_enter_email as NSString, viewController: self, type: 1)

            return
        }
        if passwdTextField.text?.characters.count == 0
        {
            self.passwdTextField.layer.borderColor = UIColor.red.cgColor

            CommanMethods.alertView(message: Constants.kAlert_Please_enter_Password as NSString, viewController: self, type: 1)
            
            return
        }
        
        if passwdTextField.isFirstResponder
        {
            passwdTextField.resignFirstResponder()
        }
        
        if emailTextField.isFirstResponder
        {
            emailTextField.resignFirstResponder()
        }
        
        let user = User()
        user.email = emailTextField.text!
        user.password = passwdTextField.text!
        
        CommanMethods.addProgrssView(aStrMessage: Constants.kstrLoading, isActivity: true)
        
        /*------------------------------------------------------
         /* Api call for login user */
         ------------------------------------------------------*/
        
        LoginWebServices().loginUser(user,{(response,err) in
            
            if let msg:String = response?[Constants.kstrmessage] as? String
            {
                if(msg == Constants.kstrFailed)
                {
                    CommanMethods.removeProgrssView(isActivity: true)
                    CommanMethods.alertView(message: Constants.kstrWrongResponse as NSString, viewController: self, type: 1)
                    return
                }
            }
            if response != nil
            {
                if let token = response?["token"] as? String
                {
                   
                user.token = token
             
                UserSettings.saveLoggedInUser(user: user)
                
                CommanMethods.removeProgrssView(isActivity: true)
                    
                self.performSegue(withIdentifier: Constants.ksuccessfullLogin , sender: nil)
                }
                else
                {
                    CommanMethods.removeProgrssView(isActivity: true)

                    CommanMethods.alertView(message: Constants.kAlert_Wrong_Username_Or_Password as NSString, viewController: self, type: 1)
                }
            }                
            else
            {
                CommanMethods.removeProgrssView(isActivity: true)
                CommanMethods.alertView(message: Constants.kAlert_Wrong_Username_Or_Password as NSString, viewController: self, type: 1)
            }
            
        })
    }
    
}

/*------------------------------------------------------
 The below extension is being used from every class as a method showOKAlert to display the msg in alert.
 Just need to pass the msg parameter and the title for that in below method.
 ------------------------------------------------------*/
extension UIViewController
{
//    let temp = UIAlertView.init()
    func showOKAlert(title : String = Constants.kstrError, message : String)
    {
        let alert : UIAlertController = UIAlertController(title: title, message: message, preferredStyle:.alert)
        
        let alertAction = UIAlertAction (title: "Ok", style: .default,handler: {(action) in
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
}



