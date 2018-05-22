//
//  SelectImplantTray2ViewController.swift
//  FDA
//
//  Created by Cygnet Infotech on 09/11/17.
//  Copyright © 2017 Aditya. All rights reserved.
//

import UIKit

class SelectImplantTray2ViewController: UIViewController ,CustomAlertDelegate{
    @IBOutlet weak var lblAssmebleTray: UILabel!
    var alertView = CustomAlertViewController.init()
    var imageView:UIImage! = nil
    var arrScrewData : NSMutableArray = []
    var arrTrayType : NSMutableArray = NSMutableArray.init()
    var arrButtons : NSArray = []
    var arrButtonImageRemoved : NSArray = []
    var differentiateAlertView = 0
    var isDetectedImageIsAdded:Bool = false
    var isEditImplantsVisible:Bool = false
    var isFromSerachTray:Bool = false
    var arrButtonImagePresent : NSArray = []
    var arrButtonImageSelected : NSArray = []
    var decodedimage:UIImage! = nil
    var arrTrayBaseline :[[String: Any]] = [[:]]
    var dicForsaveTrays :[String: Any] = [:]
    var arrButtonImagePlain : NSArray = []
    var isPinSelected = 0
    var strBaseClass = ""
    var value:Any! = nil
    var trayNumber : Int = 0
    var dicForImageRecognitionResponse :[String: Any] = [:]
    var fullResultDictionary :[String: Any] = [:]
    var tray :Dictionary <String,Any>! = nil
    var responseCloneTray : NSMutableDictionary = [:]
    var overrideHoles : NSMutableArray = []
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
    
    override func viewDidLoad()
    {
        /*------------------------------------------------------
         Below code if for preparing alert view for presenting as alert box and setting the delegate as current class. that will be helpful in calling the action of okbutton when user taps on ok button in alert view
         ------------------------------------------------------*/
        alertView = self.storyboard?.instantiateViewController(withIdentifier: Constants.kCustomAlertViewController) as! CustomAlertViewController
        alertView.delegate = self
        
        super.viewDidLoad()
        
        fullResultDictionary = dicForImageRecognitionResponse
        
        let fullResult = convertToArr(text: fullResultDictionary["fullResult"]! as! String)
        
        lblAssmebleTray.text = "Assembled Tray \(value!)"
        
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
        
        let predicate1 = NSPredicate(format: "SELF.TRAY_GROUP = 1");
        
        let arrScrewDataTemp = fullResult!.filter { predicate1.evaluate(with: $0) };
        
        arrScrewData = NSMutableArray.init(array: arrScrewDataTemp)
        
        self.setButtonAttribute()
    }
    
    /*------------------------------------------------------
     Below method will get called from view did load and will be converting the json response of screw details in array form
     ------------------------------------------------------*/
    
    func convertToArr(text: String) -> [[String: Any]]?
    {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
    
    }
    
    /*------------------------------------------------------
     the below method will get called when user selects the implant and according to the implant current accessibility value and color the state of the implant wil get change
     ------------------------------------------------------*/
    @IBAction func btnPinClicked(_ sender:UIButton)
    {
        /*------------------------------------------------------
         if the accessibility hint is present change to removed after selection
         ------------------------------------------------------*/
      
        print(sender.tag)
        
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
    
    /*------------------------------------------------------
     Below method is the delegate method of alert view ok button action and will be called when user clicks on ok button ok alert view to perform necessary action
     ------------------------------------------------------*/
    func okBtnAction()
    {
        if differentiateAlertView == 0
        {
            /*------------------------------------------------------
             Unwind segue to edit implant screen
             ------------------------------------------------------*/
            self.callUpdateImageRecognitionApi()
        }
        else if differentiateAlertView == 1
        {
            self.isDetectedImageIsAdded = true
            self.isEditImplantsVisible = true
            
            if(self.strBaseClass == "ScanBarCode")
            {
                self.performSegue(withIdentifier: "backToAcceptAndFinishWhileSearchTray", sender: nil)
            }
            else
            {
                self.performSegue(withIdentifier: "unwindToAcceptTrayStep2WithSegue", sender: nil)
            }
        }
        else
        {
            self.isDetectedImageIsAdded = false
            self.isEditImplantsVisible = false
            
            if(self.isFromSerachTray == true)
            {
                self.performSegue(withIdentifier: Constants.kbackToAcceptAndFinish, sender: nil)
            }
            else
            {
                self.performSegue(withIdentifier: "unwindToAcceptTrayStep2WithSegue", sender: nil)
            }
        }
    }
    
    /*------------------------------------------------------
     The below method will set all the buttons as implants having status selected to send them as selected implant back to edit implants screen
     ------------------------------------------------------*/
    @IBAction func btnDone(_ sender: Any)
    {
        let arrayPins = NSMutableArray.init()
        
        var dictPins = NSMutableDictionary.init()
        
        var strPins = NSString.init()
        
        differentiateAlertView = 0
        
        for i in 0..<arrButtons.count
        {
            /*------------------------------------------------------
             The implants those are having the selected accessibility hint will be set as present and send back to edit implant
             ------------------------------------------------------*/
            
            if (arrButtons.object(at: i) as! UIButton).accessibilityHint == Constants.kSelected
            {
                dictPins = NSMutableDictionary.init()
                
                dictPins.setValue(Constants.kPresent, forKey: Constants.kSCREW_STATUS)
                
                dictPins.setValue((arrButtons.object(at: i) as! UIButton).accessibilityValue, forKey: Constants.kHOLE_NUMBER)
                
                dictPins.setValue("1", forKey: Constants.kTRAY_GROUP)
                
                strPins = (strPins as String) + "\(String(describing: (dictPins.value(forKey: Constants.kHOLE_NUMBER))!))" as NSString
                
                arrayPins.add(dictPins)
            }
        }
        
        let msg = "Selected values : " + (strPins as String)
        
        CommanMethods.alertView(alertView: alertView, message: msg as NSString, viewController: self, type: 1)
        
//        let alertController = UIAlertController(title: Constants.kProjectName, message: msg, preferredStyle: .alert)
//
//        let btnOk = UIAlertAction(title: Constants.kOk, style: .default, handler:
//        {(action : UIAlertAction!) -> Void in
//             self.performSegue(withIdentifier: Constants.kbackToEditImplants, sender: nil)
//        });
        
//        alertController.addAction(btnOk)
//
//        self.present(alertController, animated: true, completion: nil)
      
    }
    func callUpdateImageRecognitionApi()
    {
        var json :Any! = nil
        var json1 :Any! = nil
        var json2 :Any! = nil
        
        do {
            if let file = Bundle.main.url(forResource: Constants.kexample, withExtension: Constants.kjson) {
                let data = try Data(contentsOf: file)
                
                let jsonData = try JSONSerialization.data(withJSONObject: arrTrayBaseline, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                let jsonData1 = try JSONSerialization.data(withJSONObject: overrideHoles, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                json = try JSONSerialization.jsonObject(with: data, options: [])
                
                json1 = try JSONSerialization.jsonObject(with: jsonData, options: [])
                
                json2 = try JSONSerialization.jsonObject(with: jsonData1, options: [])
                
                
                if let object = json as? [String: Any]
                {
                    /*------------------------------------------------------
                     json is a dictionary
                     ------------------------------------------------------*/
                    print(object)
                    print(jsonData)
                    
                    let objectData = try? JSONSerialization.data(withJSONObject: overrideHoles, options: JSONSerialization.WritingOptions(rawValue: 0))
                    let objectString = String(data: objectData!, encoding: .utf8)
                    print(objectString)
                    
                    
                } else if let object = json as? [Any]
                {
                    /*------------------------------------------------------
                     json is an array
                     ------------------------------------------------------*/
                    print(object)
                    print(json1)
                    
                    let objectData = try? JSONSerialization.data(withJSONObject: overrideHoles, options: JSONSerialization.WritingOptions(rawValue: 0))
                    let objectString = String(data: objectData!, encoding: .utf8)
                    print(objectString)
                }
                else
                {
                    print(Constants.kAlert_JSON_is_invalid)
                }
            }
            else
            {
                print("no file")
            }
        }
        catch
        {
            print(error.localizedDescription)
        }
        
        let dataDecoded : Data = Data(base64Encoded: self.dicForImageRecognitionResponse[Constants.kPreImage] as! String, options: .ignoreUnknownCharacters)!
        
        let imgdata = UIImagePNGRepresentation(UIImage(data: dataDecoded)!)
        let strBase64:String = imgdata!.base64EncodedString(options: .init(rawValue: 0))
        
        let dic = [Constants.kpicture:strBase64,Constants.ktrayBaseline:json1, Constants.koverrideHoles :json2] as [String : Any]
        
        /*------------------------------------------------------
         Api call imageRecognition by passing the data of screw details in json data format
         Note:
         Updated on : 15-Dec-2017
         Updation reason : the image recognition api for tray-2 and tray-1 is different and because of that we will be separating the api name by checking the arrTrayType value as tray 1 or tray 2
         ------------------------------------------------------*/
        var strApiName = ""
        
        if(arrTrayType.object(at: trayNumber-1) as! NSString == "tray 1")
        {
            strApiName = Constants.imageRecognition
        }
        else
        {
            strApiName = Constants.imageRecognitionTray2
        }
        
        CommanMethods.addProgrssView(aStrMessage: Constants.kstrLoading, isActivity: true)
        
        updateTrayPictureWebservice().processImage(dic, strApiName, { (response, err) in
            
            if let msg:Int = response?[Constants.kstrmessage] as? Int
            {
                if(msg == 1)
                {
                    CommanMethods.removeProgrssView(isActivity: true)
                    CommanMethods.alertView(message: Constants.kstrWrongResponse as NSString , viewController: self, type: 1)
                    //                    self.showOKAlert(title :Constants.kstrError ,message: Constants.kstrWrongResponse)
                    return
                }
            }
            
            if response != nil && response![Constants.kstatusFlag] as! Int != 1
            {
                let preimage = self.dicForImageRecognitionResponse[Constants.kPreImage] as! String
                self.dicForImageRecognitionResponse = response!
                self.dicForImageRecognitionResponse[Constants.kPreImage] = preimage
                
                let dataDecoded : Data = Data(base64Encoded: response![Constants.kmarkedImage] as! String, options: .ignoreUnknownCharacters)!
                self.dicForsaveTrays["\(self.trayNumber - 1)"] = response![Constants.kmarkedImage] as! String
                
                self.decodedimage = UIImage(data: dataDecoded)
                
                /*------------------------------------------------------
                 call updateDetectedImagebyAssemblyId api to update the detected image using assemblyId
                 ------------------------------------------------------*/
                DispatchQueue.main.async
                    {
                        self.updateDetectedImagebyAssemblyId()
                }
            }
            else
            {
                CommanMethods.alertView(message: Constants.kAlert_Please_take_picture_again as NSString , viewController: self, type: 1)
                //                self.showOKAlert(title :Constants.kstrError ,message: Constants.kAlert_Please_take_picture_again)
                
                DispatchQueue.main.async {
                    CommanMethods.removeProgrssView(isActivity: true)
                }
            }
        })
    }
    
    /*------------------------------------------------------
     The below method will get called from method savePressed
     ------------------------------------------------------*/
    func updateDetectedImagebyAssemblyId()
    {
        /*------------------------------------------------------
         If image is available the updatedetectedimagebyassemblyid will get called from assembly id
         ------------------------------------------------------*/
        
        let urlString =  Constants.updatedetectedimagebyassemblyid + "/\(value!)"
        
        CommanMethods.addProgrssView(aStrMessage: Constants.kstrLoading, isActivity: true)
        
        updateTrayPictureWebservice().postTrayImage([:], urlString, imageView!, { (response, err) in
            
            CommanMethods.removeProgrssView(isActivity: true)
            
            //                let actionsheet = UIAlertController.init(title: "", message: "", preferredStyle: UIAlertControllerStyle.alert)
            
            //                var okButton:UIAlertAction! = nil
            
            /*------------------------------------------------------
             if response msg is failed then show alert for failed response
             ------------------------------------------------------*/
            
            if let msg:String = response?[Constants.kstrmessage] as? String
            {
                if(msg == Constants.kstrFailed)
                {
                    CommanMethods.removeProgrssView(isActivity: true)
                    CommanMethods.alertView(message: Constants.kstrWrongResponse as NSString , viewController: self, type: 1)
                    //                        self.showOKAlert(title :Constants.kstrError ,message: Constants.kstrWrongResponse)
                    return
                }
            }
            
            /*------------------------------------------------------
             Else display image updated.
             ------------------------------------------------------*/
            
            if response != nil
            {
                self.differentiateAlertView = 1
                
                CommanMethods.alertView(alertView: self.alertView, message: Constants.kAlert_Image_updated as NSString, viewController: self, type: 1)
                
                //                    actionsheet.message = Constants.kAlert_Image_updated
                //                    okButton = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                //                        self.isDetectedImageIsAdded = true
                //                        self.isEditImplantsVisible = true
                //
                //                        if(self.strBaseClass == "ScanBarCode")
                //                        {
                //                            self.performSegue(withIdentifier: "backToAcceptAndFinishWhileSearchTray", sender: nil)
                //                        }
                //                        else
                //                        {
                //                            self.performSegue(withIdentifier: "unwindToAcceptTrayStep2WithSegue", sender: nil)
                //                        }
                //                    })
            }
            else
            {
                CommanMethods.alertView(alertView: self.alertView, message: "Wrong Response" as NSString, viewController: self, type: 1)
                
                //                    actionsheet.message = "Wrong Response"
                //                    okButton = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                //                        self.isDetectedImageIsAdded = false
                //                        self.isEditImplantsVisible = false
                //
                //                        if(self.isFromSerachTray == true)
                //                        {
                //                            self.performSegue(withIdentifier: Constants.kbackToAcceptAndFinish, sender: nil)
                //                        }
                //                        else
                //                        {
                //                            self.performSegue(withIdentifier: "unwindToAcceptTrayStep2WithSegue", sender: nil)
                //                        }
                //                    })
            }
            
            //                actionsheet.addAction(okButton)
            //
            //                DispatchQueue.main.async {
            //                    self.present(actionsheet, animated: true, completion: nil)
            //                }
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let arrayPins = NSMutableArray.init()
        
        var dictPins = NSMutableDictionary.init()
        
        var strPins = NSString.init()
        
        for i in 0..<arrButtons.count
        {
            dictPins.setValue((arrButtons.object(at: i) as! UIButton).accessibilityValue, forKey: Constants.kHOLE_NUMBER)
            
            dictPins.setValue("1", forKey: Constants.kTRAY_GROUP)
            
            if (arrButtons.object(at: i) as! UIButton).accessibilityHint == Constants.kSelected
            {
                dictPins = NSMutableDictionary.init()
                
                dictPins.setValue("Other", forKey: Constants.kSCREW_STATUS)
                
                dictPins.setValue("1", forKey: Constants.kSCREW_ID)
                
                strPins = (strPins as String) + ", " + ((arrButtons.object(at: i) as! UIButton).accessibilityValue)! as NSString
                
                arrayPins.add(dictPins)
            }
            else if (arrButtons.object(at: i) as! UIButton).accessibilityHint == Constants.kPresent
            {
                dictPins = NSMutableDictionary.init()
                
                dictPins.setValue(Constants.kRemoved, forKey: Constants.kSCREW_STATUS)
                
                dictPins.setValue("1", forKey: Constants.kSCREW_ID)
                
                strPins = (strPins as String) + ", " + ((arrButtons.object(at: i) as! UIButton).accessibilityValue)! as NSString
                
                arrayPins.add(dictPins)
            }
            else if (arrButtons.object(at: i) as! UIButton).accessibilityHint == Constants.kDeselected
            {
                dictPins = NSMutableDictionary.init()
                
                dictPins.setValue("Other", forKey: Constants.kSCREW_STATUS)
                
                dictPins.setValue("0", forKey: Constants.kSCREW_ID)
                
                strPins = (strPins as String) + ", " + ((arrButtons.object(at: i) as! UIButton).accessibilityValue)! as NSString
                
                arrayPins.add(dictPins)
            }
            else if (arrButtons.object(at: i) as! UIButton).accessibilityHint == Constants.kRemoved
            {
                dictPins = NSMutableDictionary.init()
                
                dictPins.setValue(Constants.kPresent, forKey: Constants.kSCREW_STATUS)
                
                dictPins.setValue("0", forKey: Constants.kSCREW_ID)
                
                strPins = (strPins as String) + ", " + ((arrButtons.object(at: i) as! UIButton).accessibilityValue)! as NSString
                
                arrayPins.add(dictPins)
            }
        }
        if(segue.identifier == "unwindToAcceptTrayStep2WithSegue")
        {
            let obj = segue.destination as! AcceptTrayStep2ViewController
            obj.arrSelectedScrews = arrayPins
            
            if(overrideHoles.count > 0)
            {
                obj.overrideHoles = overrideHoles
            }
            obj.image = decodedimage
            obj.arrTrayType = arrTrayType
            obj.dicForsaveTrays = dicForsaveTrays
            obj.isDetectedImageIsAdded = isDetectedImageIsAdded
            obj.isEditImplantsVisible = isEditImplantsVisible
            obj.dicForImageRecognitionResponse = dicForImageRecognitionResponse
        }
    }
    
    @IBAction func openMenu(_ sender: UIButton){
        CommanMethods.openSideMenu(navigationController: navigationController!)
    }
    
    /*------------------------------------------------------
     The below method will be called from view did load and will be rendering the implant status, background image and group is static =1 in the buttons property
     ------------------------------------------------------*/
    
    func setButtonAttribute() -> Void
    {
        for i in 0..<arrButtons.count
        {
            (arrButtons.object(at: i) as! UIButton).addTarget(self, action:#selector(btnPinClicked(_:)) , for: UIControlEvents.touchUpInside)
        }
        
        let arrayHoleNumber = Constants.karrayHoleNumber
        
        /* Set button accessibility value as hole number */
        
        for j in 0..<arrButtons.count
        {
            (arrButtons.object(at: j) as! UIButton).accessibilityValue = arrayHoleNumber.object(at: j) as! NSString as String
        }
        
        if arrScrewData.count > 0
        {
            for i in 0..<arrScrewData.count
            {
                for j in 0..<arrButtons.count
                {
                    /*------------------------------------------------------
                      The below code will set the screw background color and status according to the arrScrewData hole number parameter and then will be setting the accessibility hint as present and removed for status which will be later used as identifying the button status as removed, selected, deselected and present
                     ------------------------------------------------------*/
                    
                    if (arrScrewData.object(at: i) as! NSDictionary).value(forKey: Constants.kHOLE_NUMBER)as! NSString == (arrButtons.object(at: j) as! UIButton).accessibilityValue! as NSString
                    {
                        if ((arrScrewData.object(at: i) as! NSDictionary).value(forKey: Constants.kSCREW_STATUS)as! NSString) as String == Constants.kPresent
                        {
                            (arrButtons.object(at: j) as! UIButton).setImage(UIImage(named:arrButtonImagePresent.object(at: j) as! String), for: UIControlState.normal)
                            
                            (arrButtons.object(at: j) as! UIButton).accessibilityHint = Constants.kPresent
                        }
                        else
                        {
                            (arrButtons.object(at: j) as! UIButton).setImage(UIImage(named:arrButtonImageRemoved.object(at: j) as! String), for: UIControlState.normal)

                            (arrButtons.object(at: j) as! UIButton).accessibilityHint = Constants.kRemoved
                        }
                    }
                }
            }
        }
    }
}

