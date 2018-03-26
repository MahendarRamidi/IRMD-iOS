//
//  ChooseWorkflowViewController.swift
//  FDA
//
//  Created by Kaustubh on 18/10/17.
//  Copyright © 2017 Aditya. All rights reserved.
//

import UIKit

class ChooseWorkflowViewController: UIViewController {
    
    @IBOutlet var btnNext: UIButton!
    @IBOutlet var vwForDropdown: UIView!
    var drop : UIDropDown!
    var selectedItem : NSString = ""
    var roleData : NSMutableArray = []
    var userToken : NSString = ""
    var arrRoleID : NSMutableArray = []
    var arrDictResponse : NSMutableArray = []
    var callerClass : NSString = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {

        /*------------------------------------------------------
         The below code will remove the drop down from main view and will add it again as to remove the UI issue that generates while changing the orientation of device in next screens and coming back to the current screen.
         ------------------------------------------------------*/
        if !(self.drop == nil)
        {
            self.drop.removeFromSuperview()
            
            self.drop = nil
        }
        
        /*------------------------------------------------------
         The below api will be calling the roles that is being selected in registration api for particular user as assembler, surgery type or both
         ------------------------------------------------------*/
        self.apiCallGetUserRoleByToken()
    }
    
    /*------------------------------------------------------
     The below method will be called every at every iteration of device orientation change and will be removing the drop down and setting it again as subview as to give functionality to support both the orientation
     ------------------------------------------------------*/
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        /*------------------------------------------------------
         First remove the drop down
         ------------------------------------------------------*/
        self.drop.removeFromSuperview()
        
        self.drop = nil
        
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            
            let orient = UIApplication.shared.statusBarOrientation
            
            /*------------------------------------------------------
             Second Add the drop down again according to the current orientation and W:H
             ------------------------------------------------------*/
            switch orient
            {
                case .portrait:
                
                self.setDropDownFrame()
                break
            
                default:
                self.setDropDownFrame()
                break
            }
        }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            print("rotation completed")
        })
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    @IBAction func openMenu(_ sender: Any)
    {
        CommanMethods.openSideMenu(navigationController: navigationController!)
    }

    /*------------------------------------------------------
     The below method will get called from drawerController when user clicks on search by surgery menu. and will set the caller class that will differentiate between scan by bar code menu and surgery search menu in side bar. The variable will be send to landing controller there it will get differentiate and will navigate to corresponding view
     ------------------------------------------------------*/
    func surgerySession()
    {
        callerClass = Constants.kdrawerClassSurgerySession as NSString

        self.performSegue(withIdentifier: "SurgerySession", sender: nil)
    }

    /*------------------------------------------------------
     The below method will get called from drawerController when user clicks on search by tray menu. and will set the caller class that will differentiate between scan by bar code menu and surgery search menu in side bar. The variable will be send to landing controller there it will get differentiate and will navigate to corresponding view
     ------------------------------------------------------*/
    func scanBarCode()
    {
        callerClass = "drawerClassScanBarCode"
        
        self.performSegue(withIdentifier: "SurgerySession", sender: nil)
    }

    /*------------------------------------------------------
     The below api will be calling the roles that is being selected in registration api for particular user as assembler, surgery type or both
     ------------------------------------------------------*/
    func apiCallGetUserRoleByToken()
    {
        CommanMethods.addProgrssView(aStrMessage: Constants.kstrLoading, isActivity: true)
        
        let dicSettings = UserDefaults.standard.value(forKey: "latestSettings") as! Dictionary<String,Any>
        
        LoginWebServices().getUserRoleByToken(dicSettings, {(response,err) in
            
            CommanMethods.removeProgrssView(isActivity: true)
            
            if let msg:String = response?[Constants.kstrmessage] as? String
            {
                if(msg == Constants.kstrFailed)
                {
                    CommanMethods.alertView(message: Constants.kstrWrongResponse as NSString, viewController: self, type: 1)
//                    self.showOKAlert(title :Constants.kstrError ,message: Constants.kstrWrongResponse)
                    
                    return
                }
            }
            else
            {
                if response != nil
                {
                    self.arrDictResponse = response!["userRoleId"] as! NSMutableArray
                    
                    /*------------------------------------------------------
                     the below data condition will be compare in the drawer class to differebtiate the user role and side menu access
                     ------------------------------------------------------*/
                    UserDefaults.standard.set(self.arrDictResponse , forKey: Constants.krole)

                    self.setDropDownFrame()
                }
                else
                {
                    CommanMethods.alertView(message: Constants.kstrWrongResponse as NSString, viewController: self, type: 1)
                    //self.showOKAlert(title :Constants.kstrError ,message: Constants.kstrWrongResponse)
                }
            }
            
        })
    }
    
    /*------------------------------------------------------
     The below Method will set the Drop down frame every time the view is being initiated and every call of method viewWillTransition that is being called when device orientation is being change
     ------------------------------------------------------*/
    func setDropDownFrame() -> Void
    {
        if self.drop == nil
        {
            self.drop = UIDropDown(frame: self.vwForDropdown.frame)
            self.drop.hideOptionsWhenSelect = true
            self.drop.tableHeight = self.vwForDropdown.frame.size.height * CGFloat(self.arrDictResponse.count)
            
            self.drop.rowHeight = self.vwForDropdown.frame.size.height
            
            self.drop.fontSize = (self.self.btnNext.titleLabel?.font.pointSize)!;
            
            var arr:[String]! = [String]()
            var arr1:[String]! = [String]()
            
            /*------------------------------------------------------
             The below method will be set the user role in the arr
             ------------------------------------------------------*/
            
            for i in 0..<self.arrDictResponse.count
            {
                let str = (self.arrDictResponse.object(at: i) as! [String:Any])["description"]!
                let strRoleID = (self.arrDictResponse.object(at: i) as! [String:Any])["id"]!
                arr1.append("\(strRoleID)")
                arr?.append(str as! String)
            }
            self.drop.options = arr
            
            self.arrRoleID = NSMutableArray.init(array: arr1)
            
            /*------------------------------------------------------
             Default value of the selectedItem will be set as the  first item present in the array
             ------------------------------------------------------*/
            
            if(arrRoleID.count > 0 )
            {
                self.selectedItem = ("\(self.arrRoleID[0])" as NSString)
            }
            
            self.drop.didSelectRowAt(option: 0)
            
            /*------------------------------------------------------
             The below code is setting the touch property(selection) of drop down and will be setting the drop down selected role in variable selectedItem that is being used at the time of accept the flow to differentiate the surgery session flow and assembly flow
             ------------------------------------------------------*/
            
            self.drop.didSelect { (option, index) in
                if(self.arrRoleID.count > 0 )
                {
                    self.selectedItem = ("\(self.arrRoleID[index])" as NSString)
                }
                print("You just select: \(option) at index: \(index)")
                
            }
            self.view.addSubview(self.drop)
            
            CommanMethods.removeProgrssView(isActivity: true)
        }
    }
    
    @IBAction func actionNext(_ sender: Any)
    {
        /*------------------------------------------------------
         According to selected role by user if assemble flow then the user will navigate to assebler flow else surgery session flow the selected item value is being set in setDropDown frame as default and as selected user role
         ------------------------------------------------------*/
        if self.selectedItem == "1"
        {
            self.performSegue(withIdentifier: "AssembleTrayBarCode", sender: nil)
        }
        else
        {
            self.performSegue(withIdentifier: "SurgerySession", sender: nil)
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        /*------------------------------------------------------
         The below identifier distinguish be¡tween the segue coming from drawer menu. Where we need to pass the callerClass variable as to perform the segue to surgery session VC
         ------------------------------------------------------*/
        if(callerClass as String == Constants.kdrawerClassSurgerySession || callerClass == "drawerClassScanBarCode")
        {
            let mainVC : LandingViewController = segue.destination as! LandingViewController
            
            mainVC.callerClass = callerClass
        }
        else
        {
            /*------------------------------------------------------
             The below condition distinguish between assembler flow(1) and surgery flow(else ie 2)
             ------------------------------------------------------*/
            if self.selectedItem == "1"
            {
                let mainVC : AssembleTrayScanBarCodeViewController = segue.destination as! AssembleTrayScanBarCodeViewController
                
                mainVC.identifyVC = "chooseVC"
            }
        }
    }
}

