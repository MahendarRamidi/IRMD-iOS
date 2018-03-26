//
//  SelectedImplantViewController.swift
//  FDA
//
//  Created by Cygnet on 11/08/17.
//  Copyright © 2017 Aditya. All rights reserved.
//

import UIKit

class SelectedImplantViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, CustomAlertDelegate
{
    @IBOutlet weak var imageVw: UIImageView!
    var alertView = CustomAlertViewController.init()
    var differentiateAlertView = 0
    var arrTrayType : NSMutableArray = NSMutableArray.init()
    @IBOutlet var assembledTrayLabel: UILabel!
    @IBOutlet weak var heightConstraint:NSLayoutConstraint!
    var arrTrayBaseline :[[String: Any]] = [[:]]
    @IBOutlet weak var screwsCollectionVw:UICollectionView!
    var dicForImageRecognitionResponse :[String: Any] = [:]
    var fullResultDictionary :[String: Any] = [:]
    var value:Any! = nil
    var iSelectedGroup = 0
    
    var decodedimage:UIImage! = nil
    
    var imageView:UIImage! = nil
    
    var arrGroup1 = Constants.karrGroup1
    
    var arrGroup2 = Constants.karrGroup2
    
    var arrGroup3 = Constants.karrGroup3
    
    var arrSections = Constants.karrSection
    
    var arrSelectedScrews = NSMutableArray()
    
    var dicForsaveTrays :[String: Any] = [:]
    
    var isDetectedImageIsAdded:Bool = false
    
    var isEditImplantsVisible:Bool = false
    
    var isFromSerachTray:Bool = false
    
    var strBaseClass = ""
    
    var trayNumber : Int = 0
    
    @IBOutlet weak var collectionViewGrpB: UICollectionView!
    
    @IBOutlet weak var collectionViewGrpC: UICollectionView!
    var  arrGroupA:[[String:Any]] = [[:]]
    var  arrGroupB:[[String:Any]] = [[:]]
    var  arrGroupC:[[String:Any]] = [[:]]
    var  overrideHoles:NSMutableArray! = NSMutableArray()
    var  tempOverrideHoles:NSMutableArray! = NSMutableArray()
    
    override func viewDidLoad() {
        
        fullResultDictionary = dicForImageRecognitionResponse
        
        let fullResult = convertToArr(text: fullResultDictionary["fullResult"]! as! String)
        
        assembledTrayLabel.text = "Assembled Tray \(value!)"
        
        /*------------------------------------------------------
         If the full result array contains object. then separate the array of screws from different tray group or 1,2,3 from full result using the predicate
         ------------------------------------------------------*/
        
        if((fullResult!.count) > 0)
        {
            let predicate1 = NSPredicate(format: "SELF.TRAY_GROUP = 1");
            let predicate2 = NSPredicate(format: "SELF.TRAY_GROUP = 2");
            let predicate3 = NSPredicate(format: "SELF.TRAY_GROUP = 3");
            
            arrGroupA = fullResult!.filter { predicate1.evaluate(with: $0) };
            arrGroupB = fullResult!.filter { predicate2.evaluate(with: $0) };
            arrGroupC = fullResult!.filter { predicate3.evaluate(with: $0) };
        }
        
        /*------------------------------------------------------
         Below code if for preparing alert view for presenting as alert box and setting the delegate as current class. that will be helpful in calling the action of okbutton when user taps on ok button in alert view
         ------------------------------------------------------*/
        alertView = self.storyboard?.instantiateViewController(withIdentifier: Constants.kCustomAlertViewController) as! CustomAlertViewController
        
        alertView.delegate = self
        
        self.getAssemblyImage()
    }
    
    func getAssemblyImage() -> Void
    {
        CommanMethods.addProgrssView(aStrMessage: Constants.kstrLoading, isActivity: true)
        
        CommanAPIs().getAssemblyImage([Constants.kstrtrayID:value], Constants.getassemblyimagebyassemblyid) { (response,err) in
            
            CommanMethods.removeProgrssView(isActivity: true)
            
            if let msg:String = response?[Constants.kstrmessage] as? String
            {
                if(msg == Constants.kstrFailed)
                {
                    return
                }
            }
            else if response != nil
            {
                let dataDecoded : Data = Data(base64Encoded: response!["data"] as! String, options: .ignoreUnknownCharacters)!
                
                self.imageVw.image = UIImage(data: dataDecoded)
                
                /*------------------------------------------------------
                 call the assembly details api by calling below method
                 ------------------------------------------------------*/
            }
            else
            {
                print("no assembly image")
            }
        }
    }
    
    /*------------------------------------------------------
     The below method is written for showing image in different controller for making it viewable to user by pushing it in different controller where user can zoom it and see the image clearly . the method is being called by the tap gesture on the image
     ------------------------------------------------------*/
    
    @IBAction func tapAction(_ sender: Any)
    {
        CommanMethods.showImage(imageView: imageVw, viewController: self)
    }
    
    /*------------------------------------------------------
     The below method will get called when the user change the orientation of the device and according to that the layout of the view will change.
     Portrait:- every thing will look the same as the story board controller. The buttons those are Verticle will be visible
     Landscape:- The buttons those are horizotally will be visible
     ------------------------------------------------------*/
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        coordinator.animate(alongsideTransition:
            {
                (UIViewControllerTransitionCoordinatorContext) -> Void in
                let orient = UIApplication.shared.statusBarOrientation
                switch orient
                {
                case .portrait:
                    self.screwsCollectionVw.reloadData()
                    self.collectionViewGrpB.reloadData()
                    self.collectionViewGrpC.reloadData()
                    print("Portrait")
                break            // Do something
                default:
                    self.screwsCollectionVw.reloadData()
                    self.collectionViewGrpB.reloadData()
                    self.collectionViewGrpC.reloadData()
                    print("LandScape")                // Do something else
                    break
                    
                }
                
        }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in            print("rotation completed")
            
        })
        super.viewWillTransition(to: size, with: coordinator)
        
    }
    
    /*------------------------------------------------------
     The below if the action call of the button of alertView that is customis a delegate method of CustomAlertDelegate. The alertview is same but the actions are different that is being set while calling the alertView custom
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
     The below method will convert the json data into array form
     ------------------------------------------------------*/
    func convertToArr(text: String) -> [[String: Any]]?
    {
        if let data = text.data(using: .utf8)
        {
            do
            {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
            }
            catch
            {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationItem.hidesBackButton = true;
        assembledTrayLabel.text = "Assembled Tray \(value!)"
    }
    
    /*------------------------------------------------------
     The accept button will be displaying the selected screws from different groups and will be performing the unwide segue backToEditImplants on clieck of ok button
     ------------------------------------------------------*/
    @IBAction func actionAccept(_ sender: Any)
    {
        var strSElectedScrewsFromTray1 = ""
        var strSElectedScrewsFromTray2 = ""
        var strSElectedScrewsFromTray3 = ""
        var strEmptyString = ""
        
        if overrideHoles.count > 0
        {
            let predicate1 = NSPredicate(format: "SELF.TRAY_GROUP = 1");
            
            let arr1 = ((overrideHoles as AnyObject).filtered(using: predicate1) as NSArray).mutableCopy() as! NSArray
            
            var sortedArray1 = (arr1.value(forKey: "HOLE_NUMBER") as! NSArray).sorted {
                (s1, s2) -> Bool in return (s1 as AnyObject).localizedStandardCompare(s2 as! String) == .orderedAscending
                } as NSArray
            
            for iCount in 0..<sortedArray1.count
            {
                if(strSElectedScrewsFromTray1.count == 0)
                {
                    strSElectedScrewsFromTray1 = "\((sortedArray1.object(at: iCount))as AnyObject)"
                }
                else
                {
                    strSElectedScrewsFromTray1 = strSElectedScrewsFromTray1 + ", " + "\((sortedArray1.object(at: iCount)) as AnyObject)"
                }
            }
            let predicate2 = NSPredicate(format: "SELF.TRAY_GROUP = 2");
            
            let arr2 = ((overrideHoles as AnyObject).filtered(using: predicate2) as NSArray).mutableCopy() as! NSArray
            
            var sortedArray2 = (arr2.value(forKey: "HOLE_NUMBER") as! NSArray).sorted {
                (s1, s2) -> Bool in return (s1 as AnyObject).localizedStandardCompare(s2 as! String) == .orderedAscending
                } as NSArray
            
            for iCount in 0..<sortedArray2.count
            {
                if(strSElectedScrewsFromTray2.count == 0)
                {
                    strSElectedScrewsFromTray2 = "\((sortedArray2.object(at: iCount))as AnyObject)"
                }
                else
                {
                    strSElectedScrewsFromTray2 = strSElectedScrewsFromTray2 + ", " + "\((sortedArray2.object(at: iCount)) as AnyObject)"
                }
            }
            let predicate3 = NSPredicate(format: "SELF.TRAY_GROUP = 3");
            
            let arr3 = ((overrideHoles as AnyObject).filtered(using: predicate3) as NSArray).mutableCopy() as! NSArray
            
            var sortedArray3 = (arr3.value(forKey: "HOLE_NUMBER") as! NSArray).sorted {
                (s1, s2) -> Bool in return (s1 as AnyObject).localizedStandardCompare(s2 as! String) == .orderedAscending
                } as NSArray
            
            for iCount in 0..<sortedArray3.count
            {
                if(strSElectedScrewsFromTray3.count == 0)
                {
                    strSElectedScrewsFromTray3 = "\((sortedArray3.object(at: iCount))as AnyObject)"
                }
                else
                {
                    strSElectedScrewsFromTray3 = strSElectedScrewsFromTray3 + ", " + "\((sortedArray3.object(at: iCount)) as AnyObject)"
                }
            }
        }
        var emptyScrewsString1 = 0
        var emptyScrewsString2 = 0
        var emptyScrewsString3 = 0
        
        if(strSElectedScrewsFromTray1.count > 0)
        {
            strSElectedScrewsFromTray1 = strSElectedScrewsFromTray1 + " from Group 1."
        }
        else
        {
            emptyScrewsString1 = 1
            
            strEmptyString = "No edits for Group 1."
        }
        if(strSElectedScrewsFromTray2.count > 0)
        {
            strSElectedScrewsFromTray2 = strSElectedScrewsFromTray2 + " from Group 2."
        }
        else
        {
            emptyScrewsString2 = 1
            
            if emptyScrewsString1 == 1
            {
                strEmptyString = "No edits for Group 1 and 2."
            }
            else
            {
                strEmptyString = "No edits for Group 2."
            }
        }
        if(strSElectedScrewsFromTray3.count > 0)
        {
            strSElectedScrewsFromTray3 = strSElectedScrewsFromTray3 + " from Group 3."
        }
        else
        {
            emptyScrewsString3 = 1
            
            if emptyScrewsString1 == 1 && emptyScrewsString2 == 1
            {
                strEmptyString = "No edits for Groups 1, 2, and 3."
            }
            else if emptyScrewsString1 == 1 && emptyScrewsString2 == 0
            {
                strEmptyString = "No edits for Groups 1 and 3."
            }
            else if emptyScrewsString1 == 0 && emptyScrewsString2 == 1
            {
                strEmptyString = "No edits for Groups 2 and 3."
            }
            else
            {
                strEmptyString = "No edits for Group 3."
            }
        }
        
        var attrString = NSMutableAttributedString.init()
        
        if strEmptyString.count == 0
        {
            attrString = NSMutableAttributedString.init(string: "Selected Implants:\nTray Position(s) \(strSElectedScrewsFromTray1)\nTray Position(s) \(strSElectedScrewsFromTray2)\nTray Position(s) \(strSElectedScrewsFromTray3).", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName:UIColor.black])
        }
        else
        {
            if emptyScrewsString1 == 1 && emptyScrewsString2 == 1 && emptyScrewsString3 == 1
            {
                attrString = NSMutableAttributedString.init(string: "Selected Implants:\n\(strEmptyString)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName:UIColor.black])
            }
            else
            {
                if emptyScrewsString1 == 1 && emptyScrewsString2 == 1 && emptyScrewsString3 == 0
                {
                    attrString = NSMutableAttributedString.init(string: "Selected Implants:\nTray Position(s) \(strSElectedScrewsFromTray3)\n\(strEmptyString)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName:UIColor.black])
                }
                else if emptyScrewsString1 == 1 && emptyScrewsString2 == 0 && emptyScrewsString3 == 1
                {
                    attrString = NSMutableAttributedString.init(string: "Selected Implants:\nTray Position(s) \(strSElectedScrewsFromTray2)\n\(strEmptyString)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName:UIColor.black])
                }
                else if emptyScrewsString1 == 0 && emptyScrewsString2 == 1 && emptyScrewsString3 == 1
                {
                    attrString = NSMutableAttributedString.init(string: "Selected Implants:\nTray Position(s) \(strSElectedScrewsFromTray1)\n\(strEmptyString)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName:UIColor.black])
                }
                else if emptyScrewsString1 == 1 && emptyScrewsString2 == 0 && emptyScrewsString3 == 0
                {
                    //attrString = NSMutableAttributedString.init(string: "Selected Implants:\n\(strSElectedScrewsFromTray2)\n\(strSElectedScrewsFromTray3)\n\(strEmptyString).", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName:UIColor.black])
                    
                    attrString = NSMutableAttributedString.init(string: "Selected Implants:\n\(strEmptyString)\nTray Position(s) \(strSElectedScrewsFromTray2)\nTray Position(s) \(strSElectedScrewsFromTray3).", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName:UIColor.black])
                }
                else if emptyScrewsString1 == 0 && emptyScrewsString2 == 0 && emptyScrewsString3 == 1
                {
                    attrString = NSMutableAttributedString.init(string: "Selected Implants:\nTray Position(s) \(strSElectedScrewsFromTray1)\nTray Position(s) \(strSElectedScrewsFromTray2)\n\(strEmptyString)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName:UIColor.black])
                }
                else if emptyScrewsString1 == 0 && emptyScrewsString2 == 1 && emptyScrewsString3 == 0
                {
                    //attrString = NSMutableAttributedString.init(string: "Selected Implants:\n\(strSElectedScrewsFromTray1)\n\(strSElectedScrewsFromTray3)\n\(strEmptyString).", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName:UIColor.black])
                    
                     attrString = NSMutableAttributedString.init(string: "Selected Implants:\nTray Position(s) \(strSElectedScrewsFromTray1)\n\(strEmptyString)\nTray Position(s) \(strSElectedScrewsFromTray3).", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName:UIColor.black])
                }
            }
        }
        
        if (arrSelectedScrews.count > 0)
        {
            differentiateAlertView = 0
            
            CommanMethods.alertViewForPostSurgery(alertView: self.alertView, message: attrString, viewController: self, type: 1)
        }
        else
        {
            /*------------------------------------------------------
             Unwind segue to edit implant screen
             ------------------------------------------------------*/
            
            self.callUpdateImageRecognitionApi()
        }
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
                    
                    
                }
                else if let object = json as? [Any]
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
                    return
                }
            }
            
            if response != nil && response![Constants.kstatusFlag] as! Int == 0
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
                
                CommanMethods.alertView(alertView: self.alertView, message: Constants.kPostop_Tray_Configuration_Updated as NSString, viewController: self, type: 1)
                
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
                CommanMethods.alertView(alertView: self.alertView, message: "Please Try Again" as NSString, viewController: self, type: 1)
                
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
    
    /*------------------------------------------------------
     While unwinding the current segue to editImplant screen the selected screw details that is saved in overrideHoles will be send back to edit implant screen to update the tray details
     ------------------------------------------------------*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //        let edit = segue.destination as! EditImplantsViewController
        //        edit.arrSelectedScrews = arrSelectedScrews
        //
        //        if(overrideHoles.count > 0)
        //        {
        //            if(edit.overrideHoles.count > 0)
        //            {
        //                edit.overrideHoles.addObjects(from: overrideHoles! as! [Any])
        //            }
        //            else
        //            {
        //                edit.overrideHoles = overrideHoles!
        //            }
        //        }
        if(segue.identifier == "unwindToAcceptTrayStep2WithSegue")
        {
            let obj = segue.destination as! AcceptTrayStep2ViewController
            obj.arrSelectedScrews = arrSelectedScrews
            
            if(overrideHoles.count > 0)
            {
                obj.overrideHoles = overrideHoles!
            }
            obj.image = decodedimage
            obj.arrTrayType = arrTrayType
            obj.dicForsaveTrays = dicForsaveTrays
            obj.isDetectedImageIsAdded = isDetectedImageIsAdded
            obj.isEditImplantsVisible = isEditImplantsVisible
            obj.dicForImageRecognitionResponse = dicForImageRecognitionResponse
        }
    }
    
    //    func numberOfSections(in collectionView: UICollectionView) -> Int {
    //        if iSelectedGroup == 0 {
    //            return 10
    //        } else {
    //            return 8
    //        }
    //    }
    //
    //    func collectionView(_ collectionView: UICollectionView,
    //                        numberOfItemsInSection section: Int) -> Int {
    //        if iSelectedGroup == 0 {
    //            return 24
    //        } else if iSelectedGroup == 1 {
    //            return 18
    //        } else {
    //            return 16
    //        }
    //    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        /*------------------------------------------------------
         For group 1 no of screws horizontally will be 10
         ------------------------------------------------------*/
        if collectionView == screwsCollectionVw
        {
            return 10
        }
            /*------------------------------------------------------
             For group 2 and 3 no of screws horizontally will be 8
             ------------------------------------------------------*/
        else
        {
            return 8
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int
    {
        /*------------------------------------------------------
         For group 1 no of screws vertically is 24
         ------------------------------------------------------*/
        if collectionView == screwsCollectionVw
        {
            return 24
        }
            /*------------------------------------------------------
             For group 2 no of screws vertically is 18
             ------------------------------------------------------*/
        else if collectionView == collectionViewGrpB
        {
            return 18
        }
            /*------------------------------------------------------
             For group 1 no of screws vertically is 16
             ------------------------------------------------------*/
        else
        {
            return 16
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        //var cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "cellWithLabel", for: indexPath)
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "cellWithLabel", for: indexPath) as! collectionCell
        
        let orient = UIApplication.shared.statusBarOrientation
        
        /*------------------------------------------------------
         Depending on the device orientation the buttons that represents the screws size will get set dynamically
         ------------------------------------------------------*/
        if orient.isPortrait
        {
            if collectionView == screwsCollectionVw
            {
                cell.btnPin.frame = CGRect(x: 5, y: 3, width: 18, height: 18)
            }
            else
            {
                cell.btnPin.frame = CGRect(x: 0, y: 5, width: 15, height: 15)
            }
        }
        else if orient.isLandscape
        {
            if collectionView == screwsCollectionVw
            {
                cell.btnPin.frame = CGRect(x: 10, y: 3, width: 14, height: 14)
            }
            else
            {
                cell.btnPin.frame = CGRect(x: 10, y: 0, width: 13, height: 13)
            }
        }
        else
        {
            if collectionView == screwsCollectionVw
            {
                cell.btnPin.frame = CGRect(x: 5, y: 3, width: 18, height: 18)
            }
            else
            {
                cell.btnPin.frame = CGRect(x: 0, y: 5, width: 15, height: 15)
            }
        }
        if indexPath.section == 0
        {
            //cell.lblText.isHidden = false
            
            if collectionView == screwsCollectionVw
            {
                cell.lblText.text = arrGroup1.object(at: indexPath.row) as? String
            }
            else if collectionView == collectionViewGrpB
            {
                cell.lblText.text = arrGroup2.object(at: indexPath.row) as? String
            }
            else
            {
                cell.lblText.text = arrGroup3.object(at: indexPath.row) as? String
            }
        }
        else
        {
            cell.lblText.isHidden = true
        }
        
        var strSection:String = arrSections.object(at: indexPath.section) as! String
        
        strSection = strSection+"\(indexPath.row+1)"
        
        var arr:[[String:Any]] = [[:]]
        
        if collectionView == screwsCollectionVw
        {
            let predicate1 = NSPredicate(format: "SELF.HOLE_NUMBER like '\(strSection)'");
            
            arr = arrGroupA.filter { predicate1.evaluate(with: $0) };
            
        }
        else if collectionView == collectionViewGrpB
        {
            let predicate1 = NSPredicate(format: "SELF.HOLE_NUMBER like '\(strSection)'");
            
            arr = arrGroupB.filter { predicate1.evaluate(with: $0) };
        }
        else
        {
            let predicate1 = NSPredicate(format: "SELF.HOLE_NUMBER like '\(strSection)'");
            
            arr = arrGroupC.filter { predicate1.evaluate(with: $0) };
        }
        
        if(arr.count > 0)
        {
            let dic = arr[0] as [String:Any]
            if((dic["SCREW_STATUS"] as! String) == "Present")
            {
                cell.btnPin.backgroundColor = UIColor.green
            }
            else if((dic["SCREW_STATUS"] as! String) == "other")
            {
                cell.btnPin.backgroundColor = UIColor.yellow
            }
            else if((dic["SCREW_STATUS"] as! String) == "Removed")
            {
                cell.btnPin.backgroundColor = UIColor.red
            }
            else
            {
                cell.btnPin.backgroundColor = UIColor(red: 83.0/255.0, green: 119.0/255.0, blue: 178.0/255.0, alpha: 1.0)
            }
            if(tempOverrideHoles.count > 0)
            {
                let predicate1 = NSPredicate(format: "SELF.HOLE_NUMBER like '\(dic["HOLE_NUMBER"]!)' AND SELF.TRAY_GROUP == \(dic["TRAY_GROUP"]!)");

                let arrOverride = tempOverrideHoles.filter { predicate1.evaluate(with: $0) } as! [[String : Any]];
                
                if arrOverride.count > 0
                {
                    let dic = arrOverride[0] as [String:Any]
                    if((dic["SCREW_STATUS"] as! String) == "Present")
                    {
                        cell.btnPin.backgroundColor = UIColor.green
                    }
                    else if((dic["SCREW_STATUS"] as! String) == "other")
                    {
                        cell.btnPin.backgroundColor = UIColor.yellow
                    }
                    else if((dic["SCREW_STATUS"] as! String) == "Removed")
                    {
                        cell.btnPin.backgroundColor = UIColor.red
                    }
                    else
                    {
                        cell.btnPin.backgroundColor = UIColor(red: 83.0/255.0, green: 119.0/255.0, blue: 178.0/255.0, alpha: 1.0)
                    }
                }
            }
        }
        else if(tempOverrideHoles.count > 0)
        {
            var arrOverride : [[String:Any]] = [[String:Any]]()
            
            if collectionView == screwsCollectionVw
            {
                let predicate1 = NSPredicate(format: "SELF.HOLE_NUMBER like '\(strSection)' AND SELF.TRAY_GROUP == 1");
                
                arrOverride = tempOverrideHoles.filter { predicate1.evaluate(with: $0) } as! [[String : Any]];
                
            }
            else if collectionView == collectionViewGrpB
            {
                let predicate1 = NSPredicate(format: "SELF.HOLE_NUMBER like '\(strSection)' AND SELF.TRAY_GROUP == 2");
                
                arrOverride = tempOverrideHoles.filter { predicate1.evaluate(with: $0) } as! [[String : Any]];
            }
            else
            {
                let predicate1 = NSPredicate(format: "SELF.HOLE_NUMBER like '\(strSection)' AND SELF.TRAY_GROUP == 3");
                
                arrOverride = tempOverrideHoles.filter { predicate1.evaluate(with: $0) } as! [[String : Any]];
            }
            
            if(arrOverride.count > 0)
            {
                let dic = arrOverride[0] as [String:Any]
                if((dic["SCREW_STATUS"] as! String) == "Present")
                {
                    cell.btnPin.backgroundColor = UIColor.green
                }
                else if((dic["SCREW_STATUS"] as! String) == "other")
                {
                    cell.btnPin.backgroundColor = UIColor.yellow
                }
                else if((dic["SCREW_STATUS"] as! String) == "Removed")
                {
                    cell.btnPin.backgroundColor = UIColor.red
                }
                else
                {
                    cell.btnPin.backgroundColor = UIColor(red: 83.0/255.0, green: 119.0/255.0, blue: 178.0/255.0, alpha: 1.0)
                }
            }
            else
            {
                cell.btnPin.backgroundColor = UIColor(red: 83.0/255.0, green: 119.0/255.0, blue: 178.0/255.0, alpha: 1.0)
            }
        }
        else
        {
            cell.btnPin.backgroundColor = UIColor(red: 83.0/255.0, green: 119.0/255.0, blue: 178.0/255.0, alpha: 1.0)
        }
        if collectionView == screwsCollectionVw
        {
            cell.btnPin.tag = 1
        }
        else if collectionView == collectionViewGrpB
        {
            cell.btnPin.tag = 2
        }
        else
        {
            cell.btnPin.tag = 3
        }
        cell.objSelectedImpantVwController = self
        
        
        
        //        if indexPath.section > 0 {
        //            cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "cellWithOutLabel", for: indexPath)
        //        } else {
        //            cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "cellWithLabel", for: indexPath)
        //        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
    }
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
    //        if iSelectedGroup == 0
    //        {
    //            return CGSize(width:collectionView.frame.size.width/25,height:collectionView.frame.size.height/11)
    //        }
    //        if iSelectedGroup == 1{
    //            return CGSize(width:collectionView.frame.size.width/19,height:collectionView.frame.size.height/9)
    //        }
    //        // for group 2
    //        return CGSize(width:collectionView.frame.size.width/17,height:collectionView.frame.size.height/9)
    //    }
    
    /*------------------------------------------------------
     The height of collection view will get change according to the portrait and landscape mode
     ------------------------------------------------------*/
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let orient = UIApplication.shared.statusBarOrientation
        
        if orient.isPortrait
        {
            if collectionView == screwsCollectionVw
            {
                return CGSize(width:collectionView.frame.size.width/30,height:collectionView.frame.size.height/10)
            }
            else if collectionView == collectionViewGrpB
            {
                return CGSize(width:collectionView.frame.size.width/21,height:collectionView.frame.size.height/8)
            }
            else
            {
                return CGSize(width:collectionView.frame.size.width/18,height:collectionView.frame.size.height/8)
            }
        }
        else if orient.isLandscape
        {
            if collectionView == screwsCollectionVw
            {
                return CGSize(width:collectionView.frame.size.width/25,height:collectionView.frame.size.height/10)
            }
            else if collectionView == collectionViewGrpB
            {
                return CGSize(width:collectionView.frame.size.width/21,height:collectionView.frame.size.height/8)
            }
            else
            {
                return CGSize(width:collectionView.frame.size.width/18,height:collectionView.frame.size.height/8)
            }
        }
        else
        {
            
            if collectionView == screwsCollectionVw
            {
                return CGSize(width:collectionView.frame.size.width/30,height:collectionView.frame.size.height/10)
            }
            else if collectionView == collectionViewGrpB
            {
                return CGSize(width:collectionView.frame.size.width/21,height:collectionView.frame.size.height/8)
            }
            else
            {
                return CGSize(width:collectionView.frame.size.width/18,height:collectionView.frame.size.height/8)
            }
        }
    }
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    //        guard let heightConstraint = heightConstraint else {
    //            return 6.0
    //        }
    //        if iSelectedGroup == 0 {
    //            heightConstraint.constant = 210.0
    //            return 2.0//return 2.5
    //        } else if iSelectedGroup == 1 {
    //            heightConstraint.constant = 170.0
    //            return 6.0//return 7.0
    //        } else {
    //            heightConstraint.constant = 170.0
    //            return 8.0//return 9.0
    //        }
    //    }
    
    @IBAction func openMenu(_ sender: UIButton)
    {
        CommanMethods.openSideMenu(navigationController: navigationController!)
    }
    
    /*------------------------------------------------------
     The spacing between the screws will get change according to the landscape and portrait mode using following method
     ------------------------------------------------------*/
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        let orient = UIApplication.shared.statusBarOrientation
        
        if orient.isPortrait
        {
            if(collectionView == screwsCollectionVw)
            {
                return 6.0
            }
            else if collectionView == collectionViewGrpB
            {
                return 3.0
            }
            else
            {
                return 2.0
            }
        }
        else if orient.isLandscape
        {
            if(collectionView == screwsCollectionVw)
            {
                return 0.05
            }
            else if collectionView == collectionViewGrpB
            {
                return 3.0
            }
            else
            {
                return 2.0
            }
        }
        else
        {
            if(collectionView == screwsCollectionVw)
            {
                return 6.0
            }
            else if collectionView == collectionViewGrpB
            {
                return 3.0
            }
            else
            {
                return 2.0
            }
        }
    }
}

class collectionCell:UICollectionViewCell
{
    @IBOutlet weak var btnPin:UIButton!
    @IBOutlet weak var lblText:UILabel!
    var objSelectedImpantVwController:SelectedImplantViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnPin.layer.cornerRadius = btnPin.frame.size.width/2
    }
    
    @IBAction func btnPinClicked(_ sender:Any)
    {
        let indexPath:IndexPath?
        
        if(btnPin.tag == 1)
        {
            indexPath = objSelectedImpantVwController.screwsCollectionVw.indexPath(for: self)
        }
        else if (btnPin.tag == 2)
        {
            indexPath = objSelectedImpantVwController.collectionViewGrpB.indexPath(for: self)
        }
        else
        {
            indexPath = objSelectedImpantVwController.collectionViewGrpC.indexPath(for: self)
        }
        
        if btnPin.isSelected
        {
            if indexPath != nil
            {
                var strSection = objSelectedImpantVwController.arrSections.object(at: indexPath!.section) as! String
                strSection = strSection+"\(indexPath!.row+1)"
                
                var arr:[[String:Any]] = [[:]]
                if(btnPin.tag == 1)
                {
                    let predicate1 = NSPredicate(format: "SELF.HOLE_NUMBER like '\(strSection)'");
                    
                    arr = objSelectedImpantVwController.arrGroupA.filter { predicate1.evaluate(with: $0) };
                    
                } else if(btnPin.tag == 2){
                    
                    let predicate1 = NSPredicate(format: "SELF.HOLE_NUMBER like '\(strSection)'");
                    arr = objSelectedImpantVwController.arrGroupB.filter { predicate1.evaluate(with: $0) };
                    
                } else {
                    
                    let predicate1 = NSPredicate(format: "SELF.HOLE_NUMBER like '\(strSection)'");
                    arr = objSelectedImpantVwController.arrGroupC.filter { predicate1.evaluate(with: $0) };
                }
                
                if(arr.count == 0)
                {
                    //var dicForoverrideHoles:[String:Any] = [:]
                    /*------------------------------------------------------
                     Here we are checking that if the same dictionary is already added in the overrideHoles array or not
                     if it is added then we are taking the same and updating the dictionary
                     ------------------------------------------------------*/
                    
                    let searchPredicate = NSPredicate(format: "SELF.HOLE_NUMBER ==[c] %@ AND SELF.TRAY_GROUP = %d", strSection,btnPin.tag)
                    
                    var arrAlready = NSArray()
                    
                    if(objSelectedImpantVwController.overrideHoles != nil)
                    {
                        arrAlready = objSelectedImpantVwController.overrideHoles.filtered(using: searchPredicate) as NSArray
                    }
                    
                    if(arrAlready.count != 0)
                    {
                        
                        let dic = arrAlready[0] as! NSMutableDictionary
                        dic.setValue("\(strSection)", forKey: "HOLE_NUMBER")
                        dic.setValue(0, forKey: "SCREW_ID")
                        dic.setValue(btnPin.tag, forKey: "TRAY_GROUP")
                        
                        var t = dic
                        if(btnPin.backgroundColor == UIColor.red)
                        {
                            t["SCREW_STATUS"] = "Present"
                        }
                        else if(btnPin.backgroundColor == UIColor.green)
                        {
                            t["SCREW_STATUS"] = "Removed"
                        }
                        else if(btnPin.backgroundColor == UIColor.yellow)
                        {
                            t["SCREW_STATUS"] = "-"
                        }
                        else
                        {
                            t["SCREW_STATUS"] = "other"
                        }
                        
                        objSelectedImpantVwController.overrideHoles.remove(dic)
                        objSelectedImpantVwController.tempOverrideHoles.remove(t)
                    }
                    else
                    {
                        
                        let dic = NSMutableDictionary()
                        dic.setValue("\(strSection)", forKey: "HOLE_NUMBER")
                        dic.setValue(0, forKey: "SCREW_ID")
                        dic.setValue(btnPin.tag , forKey: "TRAY_GROUP")
                        
                        var t = dic
                        if(btnPin.backgroundColor == UIColor.red)
                        {
                            t["SCREW_STATUS"] = "Present"
                        }
                        else if(btnPin.backgroundColor == UIColor.green)
                        {
                            t["SCREW_STATUS"] = "Removed"
                        }
                        else if(btnPin.backgroundColor == UIColor.yellow)
                        {
                            t["SCREW_STATUS"] = "-"
                        }
                        else
                        {
                            t["SCREW_STATUS"] = "other"
                        }
                        
                        objSelectedImpantVwController.overrideHoles.add(dic as! [String : Any])
                        objSelectedImpantVwController.tempOverrideHoles.add(t as! [String : Any])
                    }
                }
                else
                {
                    
                    let searchPredicate = NSPredicate(format: "SELF.HOLE_NUMBER ==[c] %@ AND SELF.TRAY_GROUP = %d", strSection,btnPin.tag)
                    
                    var arrAlready = NSArray()
                    if(objSelectedImpantVwController.overrideHoles != nil)
                    {
                        arrAlready = objSelectedImpantVwController.overrideHoles.filtered(using: searchPredicate) as NSArray
                    }
                    
                    if(arrAlready.count != 0)
                    {
                        var dic = arr[0] as [NSString:Any]
                        dic["HOLE_NUMBER"] = "\(strSection)"
                        dic["SCREW_ID"] = 0
                        dic["TRAY_GROUP"] = btnPin.tag
                        
                        
                        var t = dic
                        if(btnPin.backgroundColor == UIColor.red)
                        {
                            t["SCREW_STATUS"] = "Present"
                        }
                        else if(btnPin.backgroundColor == UIColor.green)
                        {
                            t["SCREW_STATUS"] = "Removed"
                        }
                        else if(btnPin.backgroundColor == UIColor.yellow)
                        {
                            t["SCREW_STATUS"] = "-"
                        }
                        else
                        {
                            t["SCREW_STATUS"] = "other"
                        }
                        
                        objSelectedImpantVwController.overrideHoles.remove(dic)
                        objSelectedImpantVwController.tempOverrideHoles.remove(t)
                    }
                    else
                    {
                        var dic = arr[0] as [NSString:Any]
                        dic["HOLE_NUMBER"] = "\(strSection)"
                        dic["SCREW_ID"] = 0
                        dic["TRAY_GROUP"] = btnPin.tag
                     
                        var t = dic
                        if(btnPin.backgroundColor == UIColor.red)
                        {
                            t["SCREW_STATUS"] = "Present"
                        }
                        else if(btnPin.backgroundColor == UIColor.green)
                        {
                            t["SCREW_STATUS"] = "Removed"
                        }
                        else if(btnPin.backgroundColor == UIColor.yellow)
                        {
                            t["SCREW_STATUS"] = "-"
                        }
                        else
                        {
                            t["SCREW_STATUS"] = "other"
                        }
                        
                        
                        
                        objSelectedImpantVwController.overrideHoles.add(dic)
                        objSelectedImpantVwController.tempOverrideHoles.add(t)
                    }
                }
                
                if objSelectedImpantVwController.arrSelectedScrews.contains(strSection) {
                    objSelectedImpantVwController.arrSelectedScrews.remove(strSection)
                }
            }
            btnPin.isSelected = false
        } else {
            if indexPath != nil {
                var strSection = objSelectedImpantVwController.arrSections.object(at: indexPath!.section) as! String
                strSection = strSection+"\(indexPath!.row+1)"
                
                
                var arr:[[String:Any]] = [[:]]
                //if objSelectedImpantVwController.iSelectedGroup == 0
                
                if(btnPin.tag == 1){
                    
                    let predicate1 = NSPredicate(format: "SELF.HOLE_NUMBER ==[c] '\(strSection)'");
                    
                    arr = objSelectedImpantVwController.arrGroupA.filter { predicate1.evaluate(with: $0) };
                    
                } else if (btnPin.tag == 2){
                    
                    let predicate1 = NSPredicate(format: "SELF.HOLE_NUMBER ==[c] '\(strSection)'");
                    arr = objSelectedImpantVwController.arrGroupB.filter { predicate1.evaluate(with: $0) };
                    
                } else {
                    
                    let predicate1 = NSPredicate(format: "SELF.HOLE_NUMBER ==[c] '\(strSection)'");
                    arr = objSelectedImpantVwController.arrGroupC.filter { predicate1.evaluate(with: $0) };
                }
                
                
                if(arr.count == 0)
                {
                    //var dicForoverrideHoles = NSMutableDictionary()
                    
                    /*------------------------------------------------------
                     Here we are checking that if the same dictionary is already added in the overrideHoles array or not
                     if it is added then we are taking the same and updating the dictionary
                     ------------------------------------------------------*/
                    
                    let searchPredicate = NSPredicate(format: "SELF.HOLE_NUMBER ==[c] %@ AND SELF.TRAY_GROUP = %d", strSection,btnPin.tag)
                    
                    var arrAlready = NSArray()
                    if(objSelectedImpantVwController.overrideHoles != nil)
                    {
                        arrAlready = objSelectedImpantVwController.overrideHoles.filtered(using: searchPredicate) as NSArray
                        
                    }
                    
                    if(arrAlready.count != 0)
                    {
                        let dic = arrAlready[0] as! NSMutableDictionary
                        dic.setValue("\(strSection)", forKey: "HOLE_NUMBER")
                        dic.setValue(1, forKey: "SCREW_ID")
                        dic.setValue(btnPin.tag, forKey: "TRAY_GROUP")
                        
                        var t = dic
                        if(btnPin.backgroundColor == UIColor.red)
                        {
                            t["SCREW_STATUS"] = "Present"
                        }
                        else if(btnPin.backgroundColor == UIColor.green)
                        {
                            t["SCREW_STATUS"] = "Removed"
                        }
                        else if(btnPin.backgroundColor == UIColor.yellow)
                        {
                            t["SCREW_STATUS"] = "-"
                        }
                        else
                        {
                            t["SCREW_STATUS"] = "other"
                        }
                        
                        objSelectedImpantVwController.overrideHoles.remove(dic)
                        objSelectedImpantVwController.tempOverrideHoles.remove(t)
                    }
                    else
                    {
                        let dic = NSMutableDictionary()
                        dic.setValue("\(strSection)", forKey: "HOLE_NUMBER")
                        dic.setValue(1, forKey: "SCREW_ID")
                        dic.setValue(btnPin.tag, forKey: "TRAY_GROUP")
                        
                        var t = dic
                        if(btnPin.backgroundColor == UIColor.red)
                        {
                            t["SCREW_STATUS"] = "Present"
                        }
                        else if(btnPin.backgroundColor == UIColor.green)
                        {
                            t["SCREW_STATUS"] = "Removed"
                        }
                        else if(btnPin.backgroundColor == UIColor.yellow)
                        {
                            t["SCREW_STATUS"] = "-"
                        }
                        else
                        {
                            t["SCREW_STATUS"] = "other"
                        }
                        
                        objSelectedImpantVwController.overrideHoles.add(dic)
                        objSelectedImpantVwController.tempOverrideHoles.add(t)
                        
                    }
                }
                else
                {
                    let searchPredicate = NSPredicate(format: "SELF.HOLE_NUMBER ==[c] %@ AND SELF.TRAY_GROUP = %d", strSection,btnPin.tag)
                    
                    var arrAlready = NSArray()
                    if(objSelectedImpantVwController.overrideHoles != nil)
                    {
                        arrAlready = objSelectedImpantVwController.overrideHoles.filtered(using: searchPredicate) as NSArray
                    }
                    
                    if(arrAlready.count != 0)
                    {
                        var dic = arr[0] as [NSString:Any]
                        dic["HOLE_NUMBER"] = "\(strSection)"
                        dic["SCREW_ID"] = 1
                        dic["TRAY_GROUP"] = btnPin.tag
                        
                        var t = dic
                        if(btnPin.backgroundColor == UIColor.red)
                        {
                            t["SCREW_STATUS"] = "Present"
                        }
                        else if(btnPin.backgroundColor == UIColor.green)
                        {
                            t["SCREW_STATUS"] = "Removed"
                        }
                        else if(btnPin.backgroundColor == UIColor.yellow)
                        {
                            t["SCREW_STATUS"] = "-"
                        }
                        else
                        {
                            t["SCREW_STATUS"] = "other"
                        }
                        
                        objSelectedImpantVwController.overrideHoles.remove(dic)
                        objSelectedImpantVwController.tempOverrideHoles.remove(t)
                    }
                    else
                    {
                        var dic = arr[0] as [NSString:Any]
                        dic["HOLE_NUMBER"] = "\(strSection)"
                        
                        /*------------------------------------------------------
                         Here if the button back ground is yellow then we are sending screwid 0 other wise we are sending the screwid 1
                         ------------------------------------------------------*/
                        
                        
                        
                        if(btnPin.backgroundColor == UIColor.yellow || btnPin.backgroundColor == UIColor.green)
                        {
                            dic["SCREW_ID"] = 0
                            
                        }
                        else
                        {
                            dic["SCREW_ID"] = 1
                            
                        }
                        
                        var t = dic
                        if(btnPin.backgroundColor == UIColor.red)
                        {
                            t["SCREW_STATUS"] = "Present"
                        }
                        else if(btnPin.backgroundColor == UIColor.green)
                        {
                            t["SCREW_STATUS"] = "Removed"
                        }
                        else if(btnPin.backgroundColor == UIColor.yellow)
                        {
                            t["SCREW_STATUS"] = "-"
                        }
                        else
                        {
                            t["SCREW_STATUS"] = "other"
                        }
                        
                        dic["TRAY_GROUP"] = btnPin.tag
                        
                        objSelectedImpantVwController.overrideHoles.add(dic)
                        
                        
                        objSelectedImpantVwController.tempOverrideHoles.add(t)
                        
                    }
                    
                }
                
                objSelectedImpantVwController.arrSelectedScrews.add(strSection)
            }
            btnPin.isSelected = true
        }
        
        if(btnPin.backgroundColor == UIColor.red)
        {
            btnPin.backgroundColor = UIColor.green
        }
        else if(btnPin.backgroundColor == UIColor.green)
        {
            btnPin.backgroundColor = UIColor.red
        }
        else if(btnPin.backgroundColor == UIColor.yellow)
        {
            btnPin.backgroundColor = UIColor(red: 83.0/255.0, green: 119.0/255.0, blue: 178.0/255.0, alpha: 1.0)
        }
        else
        {
            btnPin.backgroundColor = UIColor.yellow
        }
    }
}

