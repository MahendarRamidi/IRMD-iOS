 //
//  SelectImplantPreSurgeryTray2ViewController.swift
//  FDA
//
//  Created by Cygnet Infotech on 17/11/17.
//  Copyright © 2017 Aditya. All rights reserved.
//

import UIKit

class SelectImplantPreSurgeryTray2ViewController: UIViewController,CustomAlertDelegate
{
    var alertView = CustomAlertViewController.init()
    @IBOutlet weak var lblAssembleTray: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var arrScrewData : NSMutableArray = []
    var strBaseClass = ""
    var arrButtons : NSArray = []
    var trayNumber : Int = 0
    var arrButtonImageRemoved : NSArray = []
    var trayType : NSString = ""
    var arrTrayType : NSMutableArray = NSMutableArray.init()
    var arrButtonImagePresent : NSArray = []
    var arrButtonImageSelected : NSArray = []
    var arrButtonImagePlain : NSArray = []
    var isPinSelected = 0
    var tray :Dictionary <String,Any>! = nil
    var responseCloneTray : NSMutableDictionary = [:]
    var overrideHoles : NSMutableArray = []
    var decodedimage:UIImage! = nil
    var value:Any! = nil
    var caseId:Any! = nil
    var webserivceResponse = NSMutableDictionary.init()
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
    
    var dicForsaveTrays :[String: Any] = [:]
    
    override func viewDidLoad()
    {
        /*------------------------------------------------------
         Below code if for preparing alert view for presenting as alert box and setting the delegate as current class. that will be helpful in calling the action of okbutton when user taps on ok button in alert view
         ------------------------------------------------------*/
        alertView = self.storyboard?.instantiateViewController(withIdentifier: Constants.kCustomAlertViewController) as! CustomAlertViewController
        
        alertView.delegate = self
        /*------------------------------------------------------*/
        
        super.viewDidLoad()

        self.imageView.image = decodedimage
        
        lblAssembleTray.text = "Assembled Tray \(value!)"
        
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

        self.setButtonAttribute()
    }
    override func viewWillAppear(_ animated: Bool)
    {
        //self.navigationItem.hidesBackButton = true;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*------------------------------------------------------
     The below if the action call of the button of alertView that is customis a delegate method of CustomAlertDelegate. The alertview is same but the actions are different that is being set while calling the alertView custom
     ------------------------------------------------------*/
    func okBtnAction()
    {
        let destVC = self.storyboard?.instantiateViewController(withIdentifier: Constants.kPresurgeryAcceptAndTakePictureViewController) as! PresurgeryAcceptAndTakePictureViewController
        
        destVC.trayNumber = self.trayNumber
        
        destVC.assemblyID = ((webserivceResponse[Constants.knew_Assigned_ID])!)as! NSString
        
        /*------------------------------------------------------
         The unwind segue identifier will get change according to the strbaseClass variable that is being set by goToTray and ScanBarcodePreSurgeryViewController controller
         ------------------------------------------------------*/
        
        if(self.strBaseClass == Constants.kScanBarcodePreSurgeryViewController)
        {
            destVC.strBaseClass = Constants.kScanBarcodePreSurgeryViewController
        }
        else
        {
            destVC.strBaseClass = Constants.kGoToTrayViewController
        }
        
        destVC.dicForsaveTrays = self.dicForsaveTrays
        
        destVC.trayType = self.trayType
        
        destVC.arrTrayType = self.arrTrayType
        
        destVC.caseId = self.caseId
        
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    /*------------------------------------------------------
     The below method is written for showing image in different controller for making it viewable to user by pushing it in different controller where user can zoom it and see the image clearly . the method is being called by the tap gesture on the image
     ------------------------------------------------------*/
    @IBAction func tapAction(_ sender: Any)
    {
       CommanMethods.showImage(imageView: imageView, viewController: self)
    }
    
    /*------------------------------------------------------
     The below method will be setting the data of screws in terms of button property, as background image, screw status, accessibility value, hint etc
     ------------------------------------------------------*/
    func setButtonAttribute() -> Void
    {
        for i in 0..<arrButtons.count
        {
            (arrButtons.object(at: i) as! UIButton).addTarget(self, action:#selector(btnPinClicked(_:)) , for: UIControlEvents.touchUpInside)
        }
        
        let arrayHoleNumber = Constants.karrayHoleNumber
        
        /*------------------------------------------------------
         Set button accessibility value as hole number
         ------------------------------------------------------*/
        
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
            arrGroup = arrGroup.filter { ("\(String(describing: $0[Constants.kSCREW_STATUS]!))" as NSString) == "Present"}
            arrScrewData = NSMutableArray.init(array: arrGroup)

            for i in 0..<arrScrewData.count
            {
                for j in 0..<arrButtons.count
                {
                    if (arrScrewData.object(at: i) as! NSDictionary).value(forKey: Constants.kHOLE_NUMBER)as! NSString == (arrButtons.object(at: j) as! UIButton).accessibilityValue! as NSString
                    {
                        if ((arrScrewData.object(at: i) as! NSDictionary).value(forKey: Constants.kSCREW_STATUS)as! NSString) as String == Constants.kPresent
                        {
                            (arrButtons.object(at: j) as! UIButton).setImage(UIImage(named:arrButtonImagePresent.object(at: j) as! String), for: UIControlState.normal)
                            
                            (arrButtons.object(at: j) as! UIButton).accessibilityHint = Constants.kPresent
                        }
                        else if ((arrScrewData.object(at: i) as! NSDictionary).value(forKey: Constants.kSCREW_STATUS)as! NSString) as String == "Removed"
                        {
                            (arrButtons.object(at: j) as! UIButton).setImage(UIImage(named:arrButtonImageRemoved.object(at: j) as! String), for: UIControlState.normal)
                            
                            (arrButtons.object(at: j) as! UIButton).accessibilityHint = Constants.kRemoved
                        }
                        else if ((arrScrewData.object(at: i) as! NSDictionary).value(forKey: Constants.kSCREW_STATUS)as! NSString) as String == "Other"
                        {
                            (arrButtons.object(at: j) as! UIButton).setImage(UIImage(named:arrButtonImagePlain.object(at: j) as! String), for: UIControlState.normal)
                            
                            (arrButtons.object(at: j) as! UIButton).accessibilityHint = Constants.kother
                        }
                    }
                }
            }
        }
    }
    
    /*------------------------------------------------------
     The below method will get called when user taps on any of the implants
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
            sender.accessibilityHint = Constants.kSelected
            
            let dictTemp = NSMutableDictionary.init()
            
            dictTemp.setValue(sender.accessibilityValue, forKey: Constants.kHOLE_NUMBER)
            
            dictTemp.setValue("1", forKey: Constants.kTRAY_GROUP)
            
            overrideHoles = NSMutableArray.init()
            
            overrideHoles.add(dictTemp)
            
            sender.setImage(UIImage(named:arrButtonImageSelected.object(at: sender.tag-1) as! String), for: UIControlState.normal)
            
            isPinSelected = 1
        }
        
    }
    
    @IBAction func openMenu(_ sender: UIButton)
    {
       CommanMethods.openSideMenu(navigationController: navigationController!)
    }
    
    /*------------------------------------------------------
     The below method will update the screw details by calling the method updateScrewDetails
     ------------------------------------------------------*/
    @IBAction func btnAccept(_ sender: Any)
    {
       self.updateScrewDetails()
    }
    
    /*------------------------------------------------------
     The below method will get called when user taps in the accept button after clicking on that the screw details of current implant will get cloned by calling the api createpreassemblyclone and new assembly id will be generated. the new assembly id will replace the data trayID in dicForsavetrays variable and all the following task will be performed in new generated id.
     ------------------------------------------------------*/
    func updateScrewDetails()-> Void
    {
        CommanMethods.addProgrssView(aStrMessage: Constants.kstrLoading, isActivity: true)
                
        let arrayPins = NSMutableArray.init()
        
        var dictPins = NSMutableDictionary.init()
        
        /*------------------------------------------------------
         set arrayPins for api call createpreassemblyclone parameter
         ------------------------------------------------------*/
        
        for i in 0..<arrButtons.count
        {
            /*------------------------------------------------------
            if the button accessibility hint is "Pesent". that is set in btnClicked then below dictionary will get append in arrayPins and so on for other status
             ------------------------------------------------------*/
            
            if (arrButtons.object(at: i) as! UIButton).accessibilityHint == Constants.kPresent
            {
                dictPins = NSMutableDictionary.init()
                
                dictPins.setValue(Constants.kPresent, forKey: Constants.kSCREW_STATUS)
                
                dictPins.setValue((arrButtons.object(at: i) as! UIButton).accessibilityValue, forKey: Constants.kHOLE_NUMBER)
                
                dictPins.setValue("1", forKey: Constants.kTRAY_GROUP)
                
                arrayPins.add(dictPins)
            }
            else if (arrButtons.object(at: i) as! UIButton).accessibilityHint == Constants.kRemoved
            {
                dictPins = NSMutableDictionary.init()
                
                dictPins.setValue(Constants.kRemoved, forKey: Constants.kSCREW_STATUS)
                
                dictPins.setValue((arrButtons.object(at: i) as! UIButton).accessibilityValue, forKey: Constants.kHOLE_NUMBER)
                
                dictPins.setValue("1", forKey: Constants.kTRAY_GROUP)
                
                arrayPins.add(dictPins)
            }
            else if (arrButtons.object(at: i) as! UIButton).accessibilityHint == Constants.kSelected
            {
                dictPins = NSMutableDictionary.init()
                
                dictPins.setValue(Constants.kPresent, forKey: Constants.kSCREW_STATUS)
                
                dictPins.setValue((arrButtons.object(at: i) as! UIButton).accessibilityValue, forKey: Constants.kHOLE_NUMBER)
                
                dictPins.setValue("1", forKey: Constants.kTRAY_GROUP)
                
                arrayPins.add(dictPins)
            }
        }
        let arrayInput = arrayPins
        
        let dicionaryForTray = [Constants.kcaseID:"\(((caseId as! NSDictionary).value(forKey: "id"))!)",Constants.ktrayBaseline:arrayInput,Constants.kstrtrayID:"\((dicForsaveTrays[Constants.kstrtrayId]! as! [Any])[trayNumber-1])"] as Dictionary<String,Any>
        
        /*------------------------------------------------------
         APi call createpreassemblyclone
         ------------------------------------------------------*/
        
        CommanAPIs().saveassembly(dicionaryForTray, Constants.kcreatepreassemblyclone, { (response,err) in
            
            CommanMethods.removeProgrssView(isActivity: true)
            
            if response != nil
            {
                if !((((response![Constants.kstrmessage])!)as! NSString) as String == Constants.kSuccess)
                {
                    CommanMethods.alertView(message: ((((response![Constants.kstrmessage])!)as! NSString) as String) as String as NSString , viewController: self, type: 1)
                }
                else
                {
                    self.webserivceResponse = NSMutableDictionary.init(dictionary: response!)
                    
                    CommanMethods.alertView(alertView: self.alertView, message: Constants.kTray_Assembly_Has_Been_Edited as NSString, viewController: self, type: 1)
                }
            }
            else
            {
                CommanMethods.alertView(message: Constants.kstrWrongResponse as NSString , viewController: self, type: 1)
            }
        })
    }
}
