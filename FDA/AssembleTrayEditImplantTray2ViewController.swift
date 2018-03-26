//
//  AssembleTrayEditImplantTray2ViewController.swift
//  FDA
//
//  Created by Cygnet Infotech on 03/11/17.
//  Copyright © 2017 Aditya. All rights reserved.
//

import UIKit

class AssembleTrayEditImplantTray2ViewController: UIViewController,AssembleTrayScanBarCodeViewControllerDelegate, CustomAlertDelegate {
    
    var trayType : NSString = ""
    var differentiateAlertViewAction = 0
    var alertView = CustomAlertViewController.init()
    var arrScrewData : NSMutableArray = []
    var arrButtons : NSArray = []
    var arrButtonImageRemoved : NSArray = []
    var arrButtonImagePresent : NSArray = []
    var arrButtonImageSelected : NSArray = []
    var screwID : NSString = ""
    var arrButtonImagePlain : NSArray = []
    var isPinSelected = 0
    var tray :Dictionary <String,Any>! = nil
    var responseCloneTray : NSMutableDictionary = [:]
    var overrideHoles : NSMutableArray = []
    @IBOutlet weak var btnRemovedL: UIButton!
    @IBOutlet weak var btnPresentL: UIButton!
    @IBOutlet weak var btnRemovedP: UIButton!
    @IBOutlet weak var btnPresentP: UIButton!
    @IBOutlet weak var lblScrewRemovedL: UILabel!
    @IBOutlet weak var lblScrewPresentL: UILabel!
    @IBOutlet weak var lblScrewRemovedP: UILabel!
    @IBOutlet weak var lblScrewPresentP: UILabel!
    @IBOutlet weak var btnE5: UIButton!
    @IBOutlet weak var btnE4: UIButton!
    @IBOutlet weak var btnE3: UIButton!
    @IBOutlet weak var btnE2: UIButton!
    @IBOutlet weak var btnE1: UIButton!
    @IBOutlet weak var btnD4: UIButton!
    @IBOutlet weak var btnD3: UIButton!
    @IBOutlet weak var btnD2: UIButton!
    @IBOutlet weak var btnD1: UIButton!
    @IBOutlet weak var btnC6: UIButton!
    @IBOutlet weak var btnC5: UIButton!
    @IBOutlet weak var btnC4: UIButton!
    @IBOutlet weak var btnC3: UIButton!
    @IBOutlet weak var btnC2: UIButton!
    @IBOutlet weak var btnC1: UIButton!
    @IBOutlet weak var btnB8: UIButton!
    @IBOutlet weak var btnB7: UIButton!
    @IBOutlet weak var btnB6: UIButton!
    @IBOutlet weak var btnB5: UIButton!
    @IBOutlet weak var btnB4: UIButton!
    @IBOutlet weak var btnB3: UIButton!
    @IBOutlet weak var btnB2: UIButton!
    @IBOutlet weak var btnB1: UIButton!
    @IBOutlet weak var btnA5: UIButton!
    @IBOutlet weak var btnA4: UIButton!
    @IBOutlet weak var btnA3: UIButton!
    @IBOutlet weak var btnA2: UIButton!
    @IBOutlet weak var btnA1: UIButton!
    
    var arrScrewSelected : NSMutableArray = NSMutableArray.init()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        /*------------------------------------------------------
         the below array will contain the array of the buttons those are representing the implants in tray-2
         ------------------------------------------------------*/
        
        arrButtons = NSArray(objects: btnA1,btnA2,btnA3,btnA4,btnA5,btnB1,btnB2,btnB3,btnB4,btnB5,btnB6,btnB7,btnB8,btnC1,btnC2,btnC3,btnC4,btnC5,btnC6,btnD1,btnD2,btnD3,btnD4,btnE1,btnE2,btnE3,btnE4,btnE5)
        
        /*------------------------------------------------------
         the below array contains the images for REMOVED implants
         ------------------------------------------------------*/
        
        arrButtonImageRemoved =  Constants.karrBackGroundColorImplantRemoved
        
        /*------------------------------------------------------
         the below array contains the images for PRESENT implants
         ------------------------------------------------------*/
        
        arrButtonImagePresent = Constants.karrBackGroundColorImplantPresent
        
        /*------------------------------------------------------
         the below array contains the images for OTHER implants
         ------------------------------------------------------*/
        
        arrButtonImageSelected = Constants.karrBackGroundColorImplantSelected
        
        /*------------------------------------------------------
         the below array contains the images for PLAIN implants
         ------------------------------------------------------*/
        
        arrButtonImagePlain = Constants.karrBackGroundColorImplantPlain
        
        /*------------------------------------------------------
         calling below method at view load for renedering the data retrived in api response in previous screen in form of arrScrewData
         ------------------------------------------------------*/
        
        /*------------------------------------------------------
         Below code if for preparing alert view for presenting as alert box and setting the delegate as current class. that will be helpful in calling the action of okbutton when user taps on ok button in alert view
         ------------------------------------------------------*/
        alertView = self.storyboard?.instantiateViewController(withIdentifier: Constants.kCustomAlertViewController) as! CustomAlertViewController
        
        alertView.delegate = self
        /*------------------------------------------------------*/
        
        self.setButtonAttribute()
    }
    
    /*------------------------------------------------------
     From below method the user will navigate to either AssembleTrayScanBarCodeViewController or AssembleTrayDetailViewController controller depending on the segue
     ------------------------------------------------------*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == Constants.kgotoEditImplant2)
        {
            let asssembleVC = segue.destination as! AssembleTrayScanBarCodeViewController
            asssembleVC.overrideHoles = overrideHoles
            asssembleVC.trayType = trayType
            asssembleVC.delegate = self
            asssembleVC.identifyVC = Constants.kstrgotoEditImplant as NSString
        }
        else
        {
            let trayDetail = segue.destination as! AssembleTrayDetailViewController
            trayDetail.trayGroup = 2
            trayDetail.arrResponseCloneTray = responseCloneTray.value(forKey: Constants.kassemblyDetails) as! NSMutableArray
            trayDetail.trayNumber = responseCloneTray.value(forKey: "id") as! Int
        }
    }
    
    /*------------------------------------------------------
     Created on 19-Jan-2018
     Purpose : The below method is the delegate method the declareation and the data passing in the current method will be form the AssembleTrayScanBarCodeViewController class that will be setting the screwID parameter.
     ------------------------------------------------------*/
    func getScrewID(implantScrewID : NSString) -> Void
    {
        self.screwID = implantScrewID
    }
    
    /*------------------------------------------------------
     The below method is delegate method of class AssemblyTrayScanBarCodeVC and will be called only when the reponse for scaning the product for implant selection gets true api:-validatescrewforproduct in screen AssemblyTrayScanBarCodeVC
     ------------------------------------------------------*/
    
    func validateScrewForProductApiResponse(response : Bool)->Void
    {
        /*------------------------------------------------------
         if response true
         ------------------------------------------------------*/
        
        if(response)
        {
            for i in 0..<arrButtons.count
            {
                /*------------------------------------------------------
                 if accessibility value is equal to the holenumber of selected array then replace the status with present
                 ------------------------------------------------------*/
                
                if (arrButtons.object(at: i) as! UIButton).accessibilityValue! as NSString == (overrideHoles.object(at: 0) as! NSDictionary).value(forKey: Constants.kstrholeNumber) as! NSString
                {
                    (arrButtons.object(at: i) as! UIButton).setImage(UIImage(named:arrButtonImagePresent.object(at: i) as! String), for: UIControlState.normal)

                    (arrButtons.object(at: i) as! UIButton).accessibilityHint =  Constants.kPresent
                    
                    /*------------------------------------------------------
                     Updated on 19-Jan-2018 12:23 PM
                     
                     The below accessibilityIdentifier is used to distinguish between the old screws and the newly added screws. as we need to add screwID parameter in newly added screws and keep the old ones the same with three paramters as tray group, hole number, status while calling the createassemblyclone api
                     ------------------------------------------------------*/
                    (arrButtons.object(at: i) as! UIButton).accessibilityIdentifier = Constants.kSelected
                }
            }
        }
        overrideHoles = NSMutableArray.init()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    /*------------------------------------------------------
     The below method will get called when the user change the orientation of the device and according to that the layout of the view will change.
     Portrait:- every thing will look the same as the story board controller. The buttons those are Verticle will be visible
     Landscape:- The buttons those are horizotally will be visible
     ------------------------------------------------------*/
     
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        if UIDevice.current.orientation.isPortrait
        {
            btnPresentL.isHidden = true
            
            btnRemovedL.isHidden = true
            
            lblScrewPresentL.isHidden = true
            
            lblScrewRemovedL.isHidden = true
            
            btnPresentP.isHidden = false
            
            btnRemovedP.isHidden = false
            
            lblScrewPresentP.isHidden = false
            
            lblScrewRemovedP.isHidden = false
        }
        else if UIDevice.current.orientation.isLandscape
        {
            btnPresentL.isHidden = false
            
            btnRemovedL.isHidden = false
            
            lblScrewPresentL.isHidden = false
            
            lblScrewRemovedL.isHidden = false
            
            btnPresentP.isHidden = true
            
            btnRemovedP.isHidden = true
            
            lblScrewPresentP.isHidden = true
            
            lblScrewRemovedP.isHidden = true
        }
        else
        {
            btnPresentL.isHidden = true
            
            btnRemovedL.isHidden = true
            
            lblScrewPresentL.isHidden = true
            
            lblScrewRemovedL.isHidden = true
            
            btnPresentP.isHidden = false
            
            btnRemovedP.isHidden = false
            
            lblScrewPresentP.isHidden = false
            
            lblScrewRemovedP.isHidden = false
        }
    }
    
    /*------------------------------------------------------
     The below if the action call of the button of alertView that is customis a delegate method of CustomAlertDelegate. The alertview is same but the actions are different that is being set while calling the alertView custom
     ------------------------------------------------------*/
    func okBtnAction()
    {
        if(differentiateAlertViewAction == 0)
        {
            self.performSegue(withIdentifier: Constants.kgotoEditImplant2, sender: nil)
        }
        else
        {
            self.performSegue(withIdentifier: Constants.kGoToAssembleTrayDetailTray2 , sender: nil)
        }
    }
    
    /*------------------------------------------------------
     the below method will get called when user selects the implant and according to the implant current accessibility value and color the state of the implant wil get change
     ------------------------------------------------------*/
    
    @IBAction func btnPinClicked(_ sender:UIButton)
    {
        print(sender.tag)
        
        /*------------------------------------------------------
         if the accessibility hint is present change to removed after selection
         ------------------------------------------------------*/
        
        if sender.accessibilityHint == Constants.kPresent
        {
            sender.setImage(UIImage(named:arrButtonImageRemoved.object(at: sender.tag-1) as! String), for: UIControlState.normal)
                
            sender.accessibilityHint = Constants.kRemoved
        }
        
        /*------------------------------------------------------
         if the accessibility hint is Selected change to Deselected after selection
         ------------------------------------------------------*/
            
        else if sender.accessibilityHint == Constants.kSelected
        {
            sender.setImage(UIImage(named:arrButtonImagePlain.object(at: sender.tag-1) as! String), for: UIControlState.normal)
            
            sender.accessibilityHint = Constants.kDeselected
        }
        
        /*------------------------------------------------------
         if the accessibility hint is Removed change to Present after selection
         ------------------------------------------------------*/
            
        else if sender.accessibilityHint == Constants.kRemoved
        {
            sender.setImage(UIImage(named:arrButtonImagePresent.object(at: sender.tag-1) as! String), for: UIControlState.normal)
                
            sender.accessibilityHint = Constants.kPresent
        }
        
        /*------------------------------------------------------
         if the accessibility hint is Other
         ------------------------------------------------------*/
            
        else
        {
            /*------------------------------------------------------
              As to perform functionality one selection at one time. Search for all the buttons having accessibility hint as selected and replace the color as well as accessibility hint
             ------------------------------------------------------*/
            
            for i in 0..<arrButtons.count
            {
                if (arrButtons.object(at: i) as! UIButton).accessibilityHint == Constants.kSelected
                {
                    (arrButtons.object(at: i) as! UIButton).setImage(UIImage(named:arrButtonImagePlain.object(at: i) as! String), for: UIControlState.normal)
                    (arrButtons.object(at: i) as! UIButton).accessibilityHint = Constants.kDeselected
                }
            }
            
            sender.accessibilityHint = Constants.kSelected
            
            let dictTemp = NSMutableDictionary.init()
            
            dictTemp.setValue(sender.accessibilityValue, forKey: Constants.kstrholeNumber)
            
            dictTemp.setValue("1", forKey: Constants.kstrtrayGroup)
            
            overrideHoles = NSMutableArray.init()
            
            overrideHoles.add(dictTemp)
            
            sender.setImage(UIImage(named:arrButtonImageSelected.object(at: sender.tag-1) as! String), for: UIControlState.normal)
            
            isPinSelected = 1
        }
        
    }
    
    /*------------------------------------------------------
     this method will navigate user to scan implant phase-2 screen for validating the screw selected
     ------------------------------------------------------*/
    
    @IBAction func btnScanImplant(_ sender: Any)
    {
        differentiateAlertViewAction = 0
        
        if(overrideHoles.count > 0)
        {
            let msg = "Selected Implant : " + "\nTray Position \((overrideHoles.object(at: 0) as! NSDictionary).value(forKey: Constants.kstrholeNumber) as AnyObject)"

            CommanMethods.alertView(alertView: self.alertView, message: msg as NSString, viewController: self, type: 1)
        }
        else
        {
            CommanMethods.alertView(message: Constants.kAlert_Please_select_screw as NSString , viewController: self, type: 1)
        }
    }
    
    @IBAction func openMenu(_ sender: Any)
    {
       CommanMethods.openSideMenu(navigationController: navigationController!)
    }
    
    /*------------------------------------------------------
     The below method will get called when user clicks on the done button after selecting the implant. The user array with buttons current status, accessibility hint and group ie default 1 will be set to array as a parameter to api call createassemblyclone
     ------------------------------------------------------*/
    
    @IBAction func btnDone(_ sender: Any)
    {
        differentiateAlertViewAction = 1
        
        CommanMethods.addProgrssView(aStrMessage: Constants.kstrLoading, isActivity: true)

        let arrayPins = NSMutableArray.init()
        
        var dictPins = NSMutableDictionary.init()
        
        for i in 0..<arrButtons.count
        {
            /*------------------------------------------------------
             set the STATUS, HOLENUMBER, TRAYGOUP for the array using buttons accessibity hint that is set when user clicks on the button
             ------------------------------------------------------*/
            
            if (arrButtons.object(at: i) as! UIButton).accessibilityHint == Constants.kPresent
            {
                dictPins = NSMutableDictionary.init()
                
                dictPins.setValue( Constants.kPresent , forKey: Constants.kscrewStatus)
                
                dictPins.setValue((arrButtons.object(at: i) as! UIButton).accessibilityValue, forKey: Constants.kstrholeNumber)
                
                dictPins.setValue((arrButtons.object(at: i) as! UIButton).accessibilityIdentifier, forKey: Constants.kscrewID)
                
                dictPins.setValue("1", forKey: Constants.kstrtrayGroup)
                
                arrayPins.add(dictPins)
            }
            else if (arrButtons.object(at: i) as! UIButton).accessibilityHint == Constants.kRemoved
            {
                dictPins = NSMutableDictionary.init()
                
                dictPins.setValue(Constants.kRemoved, forKey: Constants.kscrewStatus)
                
                dictPins.setValue((arrButtons.object(at: i) as! UIButton).accessibilityValue, forKey: Constants.kstrholeNumber)
                
                if (arrButtons.object(at: i) as! UIButton).accessibilityIdentifier == nil
                {
                    dictPins.setValue("", forKey: Constants.kscrewID)
                }
                else
                {
                    dictPins.setValue((arrButtons.object(at: i) as! UIButton).accessibilityIdentifier, forKey: Constants.kscrewID)
                }
                
                dictPins.setValue((arrButtons.object(at: i) as! UIButton).accessibilityIdentifier, forKey: Constants.kscrewID)

                dictPins.setValue("1", forKey: Constants.kstrtrayGroup)
                
                arrayPins.add(dictPins)
            }
        }
        let dicionaryForTray = [Constants.kstrtrayID :"\((tray["id"]!))",Constants.ktrayBaseline:arrayPins] as Dictionary<String,Any>
        
        /*------------------------------------------------------
         APi call createassemblyclone
         ------------------------------------------------------*/
        
        print(dicionaryForTray)
        
        CommanAPIs().saveassembly(dicionaryForTray, Constants.kcreateassemblyclone, { (response,err) in
            
            CommanMethods.removeProgrssView(isActivity: true)
            
            if response != nil
            {
                self.responseCloneTray = NSMutableDictionary.init(dictionary: response!)
                
                CommanMethods.alertView(alertView: self.alertView, message: Constants.kTray_Assembly_Has_Been_Edited as NSString, viewController: self, type: 1)
            }
            else
            {
                CommanMethods.alertView(message: Constants.kstrWrongResponse as NSString , viewController: self, type: 1)
            }
        })
    }
    
    func setButtonAttribute() -> Void
    {
        for i in 0..<arrButtons.count
        {
            (arrButtons.object(at: i) as! UIButton).addTarget(self, action:#selector(btnPinClicked(_:)) , for: UIControlEvents.touchUpInside)
        }
        
        /*------------------------------------------------------
         Set button accessibility value as hole number
         ------------------------------------------------------*/
        
        let arrayHoleNumber = Constants.karrayHoleNumber
        
        for j in 0..<arrButtons.count
        {
            (arrButtons.object(at: j) as! UIButton).accessibilityValue = arrayHoleNumber.object(at: j) as! NSString as String
        }

        /*------------------------------------------------------
         Set the background image and the accessibility hint for the implants those are already present in the array passed from previous VC to render in the current screen
         ------------------------------------------------------*/        
        
        if arrScrewData.count > 0
        {
            /*------------------------------------------------------
             Updated on 11-Dec-2017:- below code added to filter out only the green status implant and only render them
            ------------------------------------------------------*/
            var  arrGroup:[[String:Any]] = [[:]]
            arrGroup = arrScrewData as! [[String : Any]]
            arrGroup = arrGroup.filter { ("\(String(describing: $0[Constants.kscrewStatus]!))" as NSString) == "Present"}
            arrScrewData = NSMutableArray.init(array: arrGroup)
            for i in 0..<arrScrewData.count
            {
                for j in 0..<arrButtons.count
                {
                    if (arrScrewData.object(at: i) as! NSDictionary).value(forKey: Constants.kstrholeNumber)as! NSString == (arrButtons.object(at: j) as! UIButton).accessibilityValue! as NSString
                    {
                        if ((arrScrewData.object(at: i) as! NSDictionary).value(forKey: Constants.kscrewStatus)as! NSString) as String == Constants.kPresent
                        {
                            (arrButtons.object(at: j) as! UIButton).setImage(UIImage(named:arrButtonImagePresent.object(at: j) as! String), for: UIControlState.normal)
                        
                            (arrButtons.object(at: j) as! UIButton).accessibilityHint = Constants.kPresent
                            
                            (arrButtons.object(at: j) as! UIButton).accessibilityIdentifier = (arrScrewData.object(at: i) as! NSDictionary).value(forKey: Constants.kscrewID)! as? String
                        }
                        else
                        {
                            (arrButtons.object(at: j) as! UIButton).setImage(UIImage(named:arrButtonImageRemoved.object(at: j) as! String), for: UIControlState.normal)
                            
                            (arrButtons.object(at: j) as! UIButton).accessibilityHint = Constants.kRemoved
                            
                            (arrButtons.object(at: j) as! UIButton).accessibilityIdentifier = (arrScrewData.object(at: i) as! NSDictionary).value(forKey: Constants.kscrewID)! as? String
                        }
                    }
                }
            }
        }
    }
}
