//
//  AcceptTrayStep2ViewController.swift
//  FDA
//
//  Created by Mahendar on 8/6/17.
//  Copyright © 2017 Mahendar. All rights reserved.
//

import UIKit

class AcceptTrayStep2ViewController: UIViewController {
    var trayNumber : Int = 0
    var totalNumberOfTrays = 0
    var arrTrayBaseline :[[String: Any]] = [[:]]
    var trayType : NSString = ""
    var arrTrayType : NSMutableArray = NSMutableArray.init()
    @IBOutlet var btnEditImplants: UIButton!
    @IBOutlet weak var vwTray2Layout: UIView!
    //    var arrGroup1:[String: Any] = [:]
//    var arrGroup2:[String: Any] = [:]
//    var arrGroup3:[String: Any] = [:]
    var value:Int! = nil
    
    var dicForsaveTrays :[String: Any] = [:]
    var dicForImageRecognitionResponse :[String: Any] = [:]
    var arrSelectedScrews = NSMutableArray()
    var overrideHoles:NSMutableArray! = NSMutableArray()
    var newAssemblyID:Any! = nil
    var arrTrayData : NSMutableArray = NSMutableArray.init()
    var isDetectedImageIsAdded:Bool = false
    var isEditImplantsVisible:Bool = false
    var arrButtons : NSArray = []
    @IBOutlet var imageView: UIImageView!
    var image : UIImage? = nil
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
    @IBOutlet weak var gotoTrayButton : UIButton!
    var arrButtonImageRemoved : NSArray = []
    var arrButtonImagePresent : NSArray = []
    var arrButtonImageSelected : NSArray = []
    var arrButtonImagePlain : NSArray = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        value = (dicForsaveTrays[Constants.kstrtrayId]! as! [Int])[trayNumber-1]
        
        //gotoTrayButton.setTitle("Accept and Go To Tray \(trayNumber + 1)", for: .normal)
        gotoTrayButton.setTitle("Accept and Go to Next Tray", for: .normal)
        self.navigationItem.title = "Implant Recognition Tray \(value!)"

        /*------------------------------------------------------
         If the current tray is last tray then the title of the button gotoTrayButton will be "Accept And Finish"
         ------------------------------------------------------*/
        if trayNumber == totalNumberOfTrays
        {
            gotoTrayButton.setTitle("Accept And Finish", for: .normal)
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        imageView.image = image
        
        if(isEditImplantsVisible == true)
        {
            btnEditImplants.isHidden = true
        }
        
        /*------------------------------------------------------
         Updated on 18-Jan-2018 1:30
         
         The below code will distinguish the layout for tray 1 and tray 2 and will be setting the layout for tray 2 the vwTray2Layout is set hidden for tray 1 layout and for tray 2 layout the view will be visible and will be setting the button image as per screw status
         ------------------------------------------------------*/
        if(arrTrayType.object(at: trayNumber-1) as! NSString == "tray 1")
        {
            self.vwTray2Layout.isHidden = true;
            
            self.imageView.isUserInteractionEnabled = true
        }
        else
        {
            self.vwTray2Layout.isHidden = false;
            
            self.imageView.isUserInteractionEnabled = false
            
            self.setButtonAttribute()
        }
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
    
    func setButtonAttribute() -> Void
    {
       arrButtons = NSArray(objects: btnA1,btnA2,btnA3,btnA4,btnA5,btnB1,btnB2,btnB3,btnB4,btnB5,btnB6,btnB7,btnB8,btnC1,btnC2,btnC3,btnC4,btnC5,btnC6,btnD1,btnD2,btnD3,btnD4,btnE1,btnE2,btnE3,btnE4,btnE5)
        
        /*------------------------------------------------------
         the below array contains the images for REMOVED implants
         ------------------------------------------------------*/
        
        arrButtonImageRemoved =  Constants.karrBackGroundColorImplantRemoved
        
        /*------------------------------------------------------
         the below array contains the images for PRESENT implants
         ------------------------------------------------------*/
        let predicate1 = NSPredicate(format: "SELF.TRAY_GROUP = 1");
        
        let fullResult = convertToArr(text: dicForImageRecognitionResponse["fullResult"]! as! String)

        let arrScrewDataTemp = fullResult!.filter { predicate1.evaluate(with: $0) };
        
        arrTrayData = NSMutableArray.init(array: arrScrewDataTemp)

        arrButtonImagePresent = Constants.karrBackGroundColorImplantPresent
        
        /*------------------------------------------------------
         the below array contains the images for OTHER implants
         ------------------------------------------------------*/
        
        arrButtonImageSelected = Constants.karrBackGroundColorImplantSelected
        
        /*------------------------------------------------------
         the below array contains the images for PLAIN implants
         ------------------------------------------------------*/
        
        arrButtonImagePlain = Constants.karrBackGroundColorImplantPlain
        
        let arrayHoleNumber = Constants.karrayHoleNumber
        
        /* Set button accessibility value as hole number */
        
        for j in 0..<arrButtons.count
        {
            (arrButtons.object(at: j) as! UIButton).accessibilityValue = arrayHoleNumber.object(at: j) as! NSString as String
            
            (arrButtons.object(at: j) as! UIButton).setImage(UIImage(named:arrButtonImagePlain.object(at: j) as! String), for: UIControlState.normal)
        }
        if arrTrayData.count > 0
        {
            for i in 0..<arrTrayData.count
            {
                for j in 0..<arrButtons.count
                {
                    /*------------------------------------------------------
                     The below code will set the screw background color and status according to the arrScrewData hole number parameter and then will be setting the accessibility hint as present and removed for status which will be later used as identifying the button status as removed, selected, deselected and present
                     ------------------------------------------------------*/
                    
                    if (arrTrayData.object(at: i) as! NSDictionary).value(forKey: Constants.kHOLE_NUMBER)as! NSString == (arrButtons.object(at: j) as! UIButton).accessibilityValue! as NSString
                    {
                        if (((arrTrayData.object(at: i) as! NSDictionary).value(forKey: Constants.kSCREW_STATUS)as! NSString) as String).lowercased() == "present"
                        {
                            (arrButtons.object(at: j) as! UIButton).setImage(UIImage(named:arrButtonImagePresent.object(at: j) as! String), for: UIControlState.normal)
                            
                            (arrButtons.object(at: j) as! UIButton).accessibilityHint = Constants.kPresent
                        }
                        else if (((arrTrayData.object(at: i) as! NSDictionary).value(forKey: Constants.kSCREW_STATUS)as! NSString) as String).lowercased() == Constants.kother
                        {
                            (arrButtons.object(at: j) as! UIButton).setImage(UIImage(named:arrButtonImageSelected.object(at: j) as! String), for: UIControlState.normal)
                            
                            (arrButtons.object(at: j) as! UIButton).accessibilityHint = Constants.kother
                        }
                        else if (((arrTrayData.object(at: i) as! NSDictionary).value(forKey: Constants.kSCREW_STATUS)as! NSString) as String).lowercased() == "removed"
                        {
                            (arrButtons.object(at: j) as! UIButton).setImage(UIImage(named:arrButtonImageRemoved.object(at: j) as! String), for: UIControlState.normal)
                            
                            (arrButtons.object(at: j) as! UIButton).accessibilityHint = Constants.kRemoved
                        }
                        else
                        {
                            (arrButtons.object(at: j) as! UIButton).setImage(UIImage(named:arrButtonImagePlain.object(at: j) as! String), for: UIControlState.normal)
                            
                            (arrButtons.object(at: j) as! UIButton).accessibilityHint = Constants.kDeselected
                        }
                    }
                }
            }
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "trayDetail"
        {
            let destVC = segue.destination as! TrayDetailViewController
            destVC.trayNumber = 1
            destVC.totalNumberOfTrays = totalNumberOfTrays
            destVC.dicForsaveTrays = dicForsaveTrays
            //destVC.image = image
            destVC.trayType = trayType
            destVC.arrTrayType = arrTrayType
            destVC.newAssemblyID = newAssemblyID
            
        }
        else if segue.identifier == "goToImplants"
        {
            let destVC = segue.destination as! EditImplantsViewController
            destVC.image = imageView.image
            destVC.trayType = trayType
            destVC.arrTrayType = arrTrayType
            destVC.arrTrayBaseline = arrTrayBaseline
            destVC.dicForsaveTrays = dicForsaveTrays
            destVC.dicForImageRecognitionResponse = dicForImageRecognitionResponse
            destVC.trayNumber = trayNumber
        }
    }
 
    /*------------------------------------------------------
     The below methdo will be calling the api updateDetectedImagebyAssemblyId or saveAssemblyAPICall depending on variable value isDetectedImageIsAdded that is being updateed by method updateDetectedImagebyAssemblyId
     ------------------------------------------------------*/
    @IBAction func acceptPressed(sender : UIButton)
    {
//        if trayNumber < totalNumberOfTrays{
//            let nextTrayVC = self.storyboard?.instantiateViewController(withIdentifier: "AcceptTrayStep1ViewController") as! AcceptTrayStep1ViewController
//            nextTrayVC.totalNumberOfTrays = self.totalNumberOfTrays
//            nextTrayVC.trayNumber = self.trayNumber + 1
//            nextTrayVC.dicForsaveTrays = dicForsaveTrays
//            self.navigationController?.pushViewController(nextTrayVC, animated: true)
//        }
//        else{
        
            CommanMethods.addProgrssView(aStrMessage: Constants.kstrLoading, isActivity: true)
            if(isDetectedImageIsAdded == false)
            {
                updateDetectedImagebyAssemblyId(isFromAcceptAndFinish: true)
            }
            else
            {
                saveAssemblyAPICall(isFromAcceptAndFinish: true)
            }
        //}
    }
    
    /*------------------------------------------------------
     the below method will get called from method acceptPressed
     ------------------------------------------------------*/
    func updateDetectedImagebyAssemblyId(isFromAcceptAndFinish:Bool)
    {
        /*------------------------------------------------------
         If iamge is not nil updatedetectedimagebyassemblyid api will get called using current trayid
         ------------------------------------------------------*/
        if(imageView.image != nil)
        {
            let urlString =  Constants.updatedetectedimagebyassemblyid + "/\(value!)"
            
            updateTrayPictureWebservice().postTrayImage([:], urlString, imageView.image!, { (response, err) in
                
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

                self.isDetectedImageIsAdded = true
                self.saveAssemblyAPICall(isFromAcceptAndFinish: isFromAcceptAndFinish)
            })
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    /*------------------------------------------------------
     The below method will get called from acceptPressed and updateDetectedImagebyAssemblyId method call and will be calling api saveassembly
     ------------------------------------------------------*/
    func saveAssemblyAPICall(isFromAcceptAndFinish:Bool){
        
        var data:Array<Dictionary<String, Any>>! = nil
        let reply = (dicForImageRecognitionResponse["fullResult"]! as! String)
        do
        {
            data  = try JSONSerialization.jsonObject(with: reply.data(using: .utf8)!, options: .allowFragments) as? Array<Dictionary<String, Any>>
        }
        catch
        {
            print ("Handle error")
        }
        
        let arrtray = dicForsaveTrays[Constants.ktrayData] as! [[String:Any]]
        
        let trayData = arrtray[trayNumber - 1]
        
        let dicionaryForTray = [Constants.kstrtrayID:"\(value!)",Constants.kcaseID:"\(trayData[Constants.kcaseID]!)",Constants.ktrayBaseline:data] as Dictionary<String,Any>
        
        /*------------------------------------------------------
         Api call saveassembly by passing the tray data
         ------------------------------------------------------*/
        CommanAPIs().saveassembly(dicionaryForTray, Constants.saveassembly, { (response,err) in
            
            if let msg:String = response?[Constants.kstrmessage] as? String
            {
                if(msg == Constants.kstrFailed)
                {
                     CommanMethods.removeProgrssView(isActivity: true)
                    CommanMethods.alertView(message: Constants.kstrFailed as NSString , viewController: self, type: 1)

                    return
                }
                else if(msg == "Case with Assembly entities is not found")
                {
                     CommanMethods.removeProgrssView(isActivity: true)
                    CommanMethods.alertView(message: "Case with Assembly entities is not found" as NSString , viewController: self, type: 1)

                    return
                }
                else if(msg == "Failed to update Case Detail Assemble")
                {
                     CommanMethods.removeProgrssView(isActivity: true)
                    CommanMethods.alertView(message: "Failed to update Case Detail Assemble" as NSString , viewController: self, type: 1)

                    return
                }
            }
            
            if response != nil
            {
                if let msg:String = response?[Constants.kstrmessage] as? String
                {
                    /*------------------------------------------------------
                     if success
                         then if tray is not tha last tray then,
                             navigate to AcceptTrayStep1ViewController with increased trayNumber
                         else
                             navigate to tray details VC
                     Else
                         show wrong response
                     ------------------------------------------------------*/
                    if(msg == Constants.kSuccess)
                    {
                        if self.trayNumber < self.totalNumberOfTrays
                        {
                            let nextTrayVC = self.storyboard?.instantiateViewController(withIdentifier: "AcceptTrayStep1ViewController") as! AcceptTrayStep1ViewController
                            nextTrayVC.totalNumberOfTrays = self.totalNumberOfTrays
                            nextTrayVC.trayNumber = self.trayNumber + 1
                            nextTrayVC.arrTrayType = self.arrTrayType
                            //self.dicForsaveTrays["newAssemblyID"] = [response!["newAssemblyID"]!]
                            if self.dicForsaveTrays[Constants.knewAssemblyID] != nil
                            {
                                var arr = self.dicForsaveTrays["newAssemblyID"] as! [Any]
                                arr.append(response![Constants.knewAssemblyID]!)
                                self.dicForsaveTrays[Constants.knewAssemblyID] = arr
                            }
                            else
                            {
                                self.dicForsaveTrays[Constants.knewAssemblyID] = [response![Constants.knewAssemblyID]!]
                            }
                            
                            nextTrayVC.dicForsaveTrays = self.dicForsaveTrays
                            
                            self.navigationController?.pushViewController(nextTrayVC, animated: true)
                        }
                        else
                        {
                            if self.dicForsaveTrays[Constants.knewAssemblyID] != nil
                            {
                                var arr = self.dicForsaveTrays[Constants.knewAssemblyID] as! [Any]
                                arr.append(response![Constants.knewAssemblyID]!)
                                self.dicForsaveTrays[Constants.knewAssemblyID] = arr
                            }
                            else
                            {
                                self.dicForsaveTrays[Constants.knewAssemblyID] = [response![Constants.knewAssemblyID]!]
                            }
                            
                            self.performSegue(withIdentifier: "trayDetail", sender: nil)
                        }
                        self.updateAssemblyImage(assemblyID: (response?["newAssemblyID"] as? String)! as NSString)
                    }
                }
                else
                {
                     CommanMethods.removeProgrssView(isActivity: true)
                    CommanMethods.alertView(message: Constants.kstrWrongResponse as NSString , viewController: self, type: 1)
                }
            }
            else
            {
                 CommanMethods.removeProgrssView(isActivity: true)
                CommanMethods.alertView(message: Constants.kstrWrongResponse as NSString , viewController: self, type: 1)
            }
        })
    }
    func updateAssemblyImage(assemblyID : NSString)
    {
        let url = "\(Constants.kupdateassemblyimagebyassemblyid)/" + (assemblyID as String)
        
        let dataDecoded : Data = Data(base64Encoded: self.dicForImageRecognitionResponse[Constants.kPreImage] as! String, options: .ignoreUnknownCharacters)!

        
        updateTrayPictureWebservice().postTrayImage([:], url, UIImage(data: dataDecoded)!, { (response, err) in
            
            CommanMethods.removeProgrssView(isActivity: true)
            
            if let msg:String = response?[Constants.kstrmessage] as? String
            {
                if (msg == Constants.kSuccess)
                {
                    print("success")

                }
                else
                {
                    CommanMethods.alertView(message: Constants.kAlert_Please_take_picture_again as NSString , viewController: self, type: 1)
                }
            }
            else
            {
                CommanMethods.alertView(message: Constants.kstrWrongResponse as NSString , viewController: self, type: 1)
            }
        })
        
    }
    @IBAction func openMenu(_ sender: UIButton)
    {
       CommanMethods.openSideMenu(navigationController: navigationController!)
    }
    
    @IBAction func backToAcceptTray(for segue: UIStoryboardSegue)
    {
        
    }
    
    /*------------------------------------------------------
     The below method will navigate user to either selectimplant for tray-1 or tray-2 based on the type of trayTYpe variable
     ------------------------------------------------------*/
    @IBAction func btnGoToEditImplant(_ sender: UIButton)
    {
        if(arrTrayType.object(at: trayNumber-1) as! NSString == "tray 1")        
        {
            let btnSender = sender as! UIButton
            
            let selectedImplant = self.storyboard?.instantiateViewController(withIdentifier: Constants.kSelectedImplantViewController) as! SelectedImplantViewController
            
            selectedImplant.value = value
            
            selectedImplant.dicForImageRecognitionResponse = dicForImageRecognitionResponse
            
            selectedImplant.arrTrayBaseline = arrTrayBaseline
            
            selectedImplant.trayNumber = trayNumber
            
            selectedImplant.arrTrayType = arrTrayType
            
            selectedImplant.dicForsaveTrays = dicForsaveTrays
            
            selectedImplant.imageView = imageView.image
            
            selectedImplant.strBaseClass = "SurgerySession"
            
            if btnSender.tag == 100 {
                selectedImplant.iSelectedGroup = 0
            } else if btnSender.tag == 101 {
                selectedImplant.iSelectedGroup = 1
            } else {
                selectedImplant.iSelectedGroup = 2
            }
            self.navigationController?.pushViewController(selectedImplant, animated: true)
        }
        else
        {
            let selectedImplant = self.storyboard?.instantiateViewController(withIdentifier: Constants.kSelectImplantTray2ViewController) as! SelectImplantTray2ViewController
            
            selectedImplant.dicForImageRecognitionResponse = dicForImageRecognitionResponse
            
            selectedImplant.value = value
            
            selectedImplant.arrTrayBaseline = arrTrayBaseline
            
            selectedImplant.arrTrayType = arrTrayType
            
            selectedImplant.strBaseClass = "SurgerySession"
            
            selectedImplant.trayNumber = trayNumber
            selectedImplant.imageView = imageView.image
            selectedImplant.dicForsaveTrays = dicForsaveTrays
            
            self.navigationController?.pushViewController(selectedImplant, animated: true)
        }
    }
    
    /*------------------------------------------------------
     The below method will be called from class PreSurgeryAcceptAndTakePictureVC to unwind the segue and will be updating the dicForsaveTrays value for trayId after updating a new assembly id in controller SelectImplantPreSurgery succussful attempt
     ------------------------------------------------------*/
    @IBAction func unwindToAcceptTrayStep2(segue:UIStoryboardSegue)
    {
        if let sourceViewController = segue.source as? SelectedImplantViewController
        {
            arrSelectedScrews = sourceViewController.arrSelectedScrews
            
            if(overrideHoles.count > 0)
            {
                overrideHoles = sourceViewController.overrideHoles!
            }
            image = sourceViewController.decodedimage
            arrTrayType = sourceViewController.arrTrayType
            dicForsaveTrays = sourceViewController.dicForsaveTrays
            isDetectedImageIsAdded = sourceViewController.isDetectedImageIsAdded
            isEditImplantsVisible = sourceViewController.isEditImplantsVisible
            dicForImageRecognitionResponse = sourceViewController.dicForImageRecognitionResponse
        }
        else if let sourceViewController = segue.source as? SelectImplantTray2ViewController
        {
//            arrSelectedScrews = sourceViewController.arrp
            
            if(overrideHoles.count > 0)
            {
                overrideHoles = sourceViewController.overrideHoles
            }
            image = sourceViewController.decodedimage
            arrTrayType = sourceViewController.arrTrayType
            dicForsaveTrays = sourceViewController.dicForsaveTrays
            isDetectedImageIsAdded = sourceViewController.isDetectedImageIsAdded
            isEditImplantsVisible = sourceViewController.isEditImplantsVisible
            dicForImageRecognitionResponse = sourceViewController.dicForImageRecognitionResponse
        }
    }
    
    /*------------------------------------------------------
     The below method is written for showing image in different controller for making it viewable to user by pushing it in different controller where user can zoom it and see the image clearly . the method is being called by the tap gesture on the image
     ------------------------------------------------------*/
    @IBAction func tapAction(_ sender: Any)
    {
      CommanMethods.showImage(imageView: imageView, viewController: self)
    }
}
