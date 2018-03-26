//
//  SignUpViewController.swift
//  FDA
//
//  Created by Mahendar on 8/6/17.
//  Copyright © 2017 Mahendar. All rights reserved.
//
import UIKit

class SignUpViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate  {

    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtLastname: UITextField!
    @IBOutlet var txtFirstname: UITextField!
    
    var selectUserPicker : UIPickerView!
    var arrDropDown : NSMutableArray = []
    var arrRoleID : NSMutableArray = []
    var selectedRole : NSString = ""
    @IBOutlet var selectUser: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        selectUser.inputView = getSelectUserPickerView()
        
        CommanMethods.addProgrssView(aStrMessage: Constants.kstrLoading, isActivity: true)
        
        /*------------------------------------------------------
        Api call for gettinng user roles that will be fetched through the field select user in registration form field and will be populating the data in picker component
         ------------------------------------------------------*/
        
        RegistrationWebServices().getAllUserRole(Constants.getalluserRole, {(response,err) in
            
            if response != nil
            {
                CommanMethods.removeProgrssView(isActivity: true)
                
                let arrDictResponse = NSMutableArray.init(array: response!)
                
                var arr:[String]! = [String]()
                var arr1:[String]! = [String]()
                
                /*------------------------------------------------------
                 The below code will be fetching the role name from the arrDictResponse
                 ------------------------------------------------------*/
                
                for i in 0..<arrDictResponse.count
                {
                    let str = (arrDictResponse.object(at: i) as! [String:Any])["roleName"]!
                    let strRoleID = (arrDictResponse.object(at: i) as! [String:Any])["id"]!
                    
                    arr.append(str as! String)
                    arr1.append("\(strRoleID)")
                }
                
                /*------------------------------------------------------
                The below code will be appending the data of user role in arrDropDown which will be used for populating the picker view component.
                 ------------------------------------------------------*/
                
                self.self.arrDropDown = NSMutableArray.init(array: arr)
                
                if(self.arrDropDown.count > 0)
                {
                    /*------------------------------------------------------
                     Both component is not coming from web service response so here we need to append it manually
                     ------------------------------------------------------*/
                    
                    self.arrDropDown.add("Both")
                }
                
                /*------------------------------------------------------
                 All the role ids will be fetched in the below array
                 ------------------------------------------------------*/
                
                self.arrRoleID = NSMutableArray.init(array: arr1)
            }
           
            else
            {
                CommanMethods.removeProgrssView(isActivity: true)
                
                CommanMethods.alertView(message: Constants.kstrWrongResponse as NSString, viewController: self, type: 1)
//                self.showOKAlert(title :Constants.kstrError ,message: Constants.kstrWrongResponse)
            }
            
        })

    }

    /*------------------------------------------------------
     The below method will be setting the picker view manually according to the current view width size and all the set up regarding the picker view
     ------------------------------------------------------*/
    
    func getSelectUserPickerView() -> UIView
    {
        selectUserPicker  = UIPickerView(frame: CGRect(x:0,y:0,width:view.frame.size.width,height:250))
        selectUserPicker.dataSource = self
        selectUserPicker.delegate = self
        selectUserPicker.translatesAutoresizingMaskIntoConstraints = false
        return selectUserPicker
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    /*------------------------------------------------------\
     This is the action method for the Sign up process
     ------------------------------------------------------*/
    
    @IBAction func signUpPressed(_ sender : UIButton)
    {
        /*------------------------------------------------------
         test if first name is not provided by user
         ------------------------------------------------------*/
        
        if txtFirstname.text?.characters.count == 0 {
            CommanMethods.alertView(message: Constants.kAlert_Please_enter_First_Name as NSString, viewController: self, type: 1)
//            showOKAlert(title :"" ,message: Constants.kAlert_Please_enter_First_Name)
            return
        }
        
        /*------------------------------------------------------
         test if last name is not provided by user
         ------------------------------------------------------*/
        
        if txtLastname.text?.characters.count == 0 {
            CommanMethods.alertView(message: Constants.kAlert_Please_enter_Last_Name as NSString, viewController: self, type: 1)
//            showOKAlert(title :"" ,message: Constants.kAlert_Please_enter_Last_Name)
            return
        }
        
        /*------------------------------------------------------
         test if email id is not provided by user
         ------------------------------------------------------*/

        if txtEmail.text?.characters.count == 0 {
            CommanMethods.alertView(message: Constants.kAlert_Please_Email as NSString, viewController: self, type: 1)
//            showOKAlert(title :"" ,message: Constants.kAlert_Please_Email)
            return
        }
        
        /*------------------------------------------------------
         test if password is not provided by user
         ------------------------------------------------------*/
        
        if txtPassword.text?.characters.count == 0 {
            CommanMethods.alertView(message: Constants.kAlert_Please_enter_Password as NSString, viewController: self, type: 1)
//            showOKAlert(title :"" ,message: Constants.kAlert_Please_enter_Password)
            return
        }
        
        /*------------------------------------------------------
         test if role has not been selected by user
         ------------------------------------------------------*/        
        
        if selectedRole.length == 0 {
            CommanMethods.alertView(message: Constants.kAlert_Please_select_user_role as NSString, viewController: self, type: 1)
//            showOKAlert(title :"" ,message: Constants.kAlert_Please_select_user_role)
            return
        }
        
        /*------------------------------------------------------
         test if email id is valid or not by calling method definition written in common class
         ------------------------------------------------------*/
        
        if !CommanMethods.nsStringIsValidEmail(txtEmail.text!) {
            CommanMethods.alertView(message: Constants.kAlert_Please_enter_valid_email as NSString, viewController: self, type: 1)
//            showOKAlert(title :"" ,message: Constants.kAlert_Please_enter_valid_email)
            return
        }
        
        let dicionaryForTray = [Constants.kfirstName : txtFirstname.text!,Constants.klastName : txtLastname.text!, Constants.kemailID : txtEmail.text!,Constants.kuserName : "ads",Constants.kpassword : txtPassword.text!, Constants.krole : selectedRole] as Dictionary<String,Any>
        
        CommanMethods.addProgrssView(aStrMessage: Constants.kstrLoading, isActivity: true)

        /*------------------------------------------------------
         Api calling for Registration api
         ------------------------------------------------------*/
        
        RegistrationWebServices().registerUser(dicionaryForTray, Constants.getregistration,{(response,err) in
            
            CommanMethods.removeProgrssView(isActivity: true)
            
            if let message = response?["error"] as? String
            {
//                self.showOKAlert(title :Constants.kstrError ,message: message)
                CommanMethods.alertView(message: message as NSString, viewController: self, type: 1)
            }
            
            if let message = response?[Constants.kstrmessage] as? String
            {
                if  message == "Ok"
                {
                    self.navigationController?.popViewController(animated: true)
                }
                else
                {
                    CommanMethods.removeProgrssView(isActivity: true)

                    CommanMethods.alertView(message: Constants.kstrWrongResponse as NSString, viewController: self, type: 1)
//                    self.showOKAlert(title :Constants.kstrError ,message: Constants.kstrWrongResponse)
                }
            }
//            else
//            {
//                CommanMethods.removeProgrssView(isActivity: true)
//                CommanMethods.alertView(message: Constants.kstrWrongResponse as NSString, viewController: self, type: 1)
////                self.showOKAlert(title :Constants.kstrError ,message: Constants.kstrWrongResponse)
//            }
        })
        
    }
    
    /*------------------------------------------------------
     MARK: - UITextField View Delegate Methods
     ------------------------------------------------------*/
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        /*------------------------------------------------------
         Using below method we will be checkng if teh textField input as UIPickerView then the pickerView is being set to text field
         ------------------------------------------------------*/
        
        if let picker = textField.inputView as? UIPickerView{
        
            let index = picker.selectedRow(inComponent: 0)
            
            self.pickerView(picker, didSelectRow: index, inComponent: 0)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    /*------------------------------------------------------
     The number of rows will depends on the number of roles fetched in the Api call getUserRoleById response
     ------------------------------------------------------*/
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return arrDropDown.count
    }
    
    /*------------------------------------------------------
     The below method will be displaying the picker view elements per row. The elemnts has been set using arrDropDown elements index wise
     ------------------------------------------------------*/
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let label = UILabel(frame: CGRect(x:0,y:0,width:pickerView.frame.size.width,height:40))
        
        label.textAlignment = .center
        
        if(arrDropDown.count > 0)
        {
            switch row {
            case 0:
                label.text = (arrDropDown[0] as! String)
                
            case 1:
                label.text = (arrDropDown[1] as! String)
                
            case 2:
                label.text = (arrDropDown[2] as! String)
                
            default:
                label.text = "OR User"
            }
        }
        
        label.font = UIFont.systemFont(ofSize: label.getFontForDevice())
        return label
    }
    
    /*------------------------------------------------------
     The below method will be storing the selected role id in selectedRole variable that will be setting as one of the paramater in creating the user and send in registration api.
     ------------------------------------------------------*/
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if(arrDropDown.count>0)
        {
            var text:String!
            switch row {
            case 0:
                text = (arrDropDown[0] as! String)
                
                selectedRole = "\(arrRoleID[0])" as NSString
            case 1:
                text = (arrDropDown[1] as! String)
                
                selectedRole = "\(arrRoleID[1])" as NSString
                
            case 2:
                text = (arrDropDown[2] as! String)
                
                selectedRole = ("\(arrRoleID[0])" + "," + "\(arrRoleID[1])" ) as NSString
            default:
                text = "OR User"
            }
            selectUser.text = text
        }
        
        selectUser.resignFirstResponder()
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
    {
        return pickerView.getHeightForDevice()
    }
 
}
