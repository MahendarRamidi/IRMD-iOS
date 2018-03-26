////
////  SelectImplantPreSurgeryViewController.swift
////  FDA
////
////  Created by Cygnet Infotech on 08/11/17.
////  Copyright © 2017 Aditya. All rights reserved.
////
//
import UIKit

protocol EditImplantPreSurgeryViewControllerDelegate
{
    func getDataFromEditImplant(response : Bool)->Void
}

class SelectImplantPreSurgeryViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,CustomAlertDelegate
{
    var webserivceResponse = NSMutableDictionary.init()
    @IBOutlet weak var imageView: UIImageView!
    var alertView = CustomAlertViewController.init()
    var trayNumber : Int = 0
    var tray :Dictionary <String,Any>! = nil
    var decodedimage:UIImage! = nil
    @IBOutlet weak var collectionViewGrpB: UICollectionView!
    @IBOutlet weak var collectionViewGrpC: UICollectionView!
    @IBOutlet var assembledTrayLabel: UILabel!
    var trayType : NSString = ""
    var arrTrayType : NSMutableArray = NSMutableArray.init()
    @IBOutlet weak var heightConstraint:NSLayoutConstraint!
    @IBOutlet weak var screwsCollectionVw:UICollectionView!
    var dicForImageRecognitionResponse :[String: Any] = [:]
    var fullResultDictionary :[String: Any] = [:]
    var value:Any! = nil
    var iSelectedGroup = 0
    var arrGroup1 = Constants.karrGroup1
    var arrGroup2 = Constants.karrGroup2
    var arrGroup3 = Constants.karrGroup3
    var arrSections = Constants.karrSection
    var arrSelectedScrews = NSMutableArray()
    var caseId:Any! = nil
    var  fullResult:[[String:Any]] = [[:]]
    var  arrGroupA:[[String:Any]] = [[:]]
    var  arrGroupB:[[String:Any]] = [[:]]
    var  arrGroupC:[[String:Any]] = [[:]]
    var strBaseClass = ""
    var  overrideHoles:NSMutableArray! = NSMutableArray()
    var dicForsaveTrays :[String: Any] = [:]
    var  tempOverrideHoles:NSMutableArray! = NSMutableArray()

    override func viewDidLoad()
    {
        /*------------------------------------------------------
         Below code if for preparing alert view for presenting as alert box and setting the delegate as current class. that will be helpful in calling the action of okbutton when user taps on ok button in alert view
         ------------------------------------------------------*/
        alertView = self.storyboard?.instantiateViewController(withIdentifier: Constants.kCustomAlertViewController) as! CustomAlertViewController
        
        alertView.delegate = self
        /*------------------------------------------------------*/
        
        fullResultDictionary = dicForImageRecognitionResponse
        
        assembledTrayLabel.text = "Assembled Tray \(value!)"
        
        self.imageView.image = decodedimage
        
        /*------------------------------------------------------
         Below code will be differentiating the array group according to the tray group and all the editing will be done on the temp array and at the time of the calling api for creating the clone the data is being rendered in tha main array
         ------------------------------------------------------*/
//        if((fullResult.count) > 0)
//        {
            let predicate1 = NSPredicate(format: "SELF.TRAY_GROUP = 1");
            let predicate2 = NSPredicate(format: "SELF.TRAY_GROUP = 2");
            let predicate3 = NSPredicate(format: "SELF.TRAY_GROUP = 3");
            
            arrGroupA = fullResult.filter { predicate1.evaluate(with: $0) };
            arrGroupA = arrGroupA.filter { ("\(String(describing: $0[Constants.kSCREW_STATUS]!))" as NSString) == "Present"}

            arrGroupB = fullResult.filter { predicate2.evaluate(with: $0) };
            arrGroupB = arrGroupB.filter { ("\(String(describing: $0[Constants.kSCREW_STATUS]!))" as NSString) == "Present"}
            
            arrGroupC = fullResult.filter { predicate3.evaluate(with: $0) };
            arrGroupC = arrGroupC.filter { ("\(String(describing: $0[Constants.kSCREW_STATUS]!))" as NSString) == "Present"}
            
            var arrayfinal = NSMutableArray.init()
            var dictTemp = NSMutableDictionary.init()
            
            var arrayTemp = NSMutableArray.init(array: arrGroupA)
            
            /*------------------------------------------------------
             The full result array consist of four parameters tray group, hole number, screw status and screw id as per requirement we need only three parameters and trayGroup should be in string as per api requirement so following code will manually fill the array as per need
             ------------------------------------------------------*/
            /*------------------------------------------------------
             Group A
             ------------------------------------------------------*/
            for i in 0..<arrGroupA.count
            {
                dictTemp = NSMutableDictionary()
                
                dictTemp.setValue("\((((arrayTemp.object(at: 0)) as! NSDictionary).value(forKey: Constants.kTRAY_GROUP))!)", forKey: Constants.kTRAY_GROUP)
                
                dictTemp.setValue(((arrayTemp.object(at: i)) as! NSDictionary).value(forKey: Constants.kHOLE_NUMBER), forKey: Constants.kHOLE_NUMBER)
                
                dictTemp.setValue(((arrayTemp.object(at: i)) as! NSDictionary).value(forKey: Constants.kSCREW_STATUS), forKey: Constants.kSCREW_STATUS)

                arrayfinal.add(dictTemp)
            }
                        
            arrGroupA = (arrayfinal.mutableCopy()) as! [[String:Any]]
            
            arrayfinal = NSMutableArray.init()
            
            arrayTemp = NSMutableArray.init(array: arrGroupB)
            
            /*------------------------------------------------------
             Group B
             ------------------------------------------------------*/
            
            for i in 0..<arrGroupB.count
            {
                dictTemp = NSMutableDictionary()
                
                dictTemp.setValue("\((((arrayTemp.object(at: 0)) as! NSDictionary).value(forKey: Constants.kTRAY_GROUP))!)", forKey: Constants.kTRAY_GROUP)
                
                dictTemp.setValue(((arrayTemp.object(at: i)) as! NSDictionary).value(forKey: Constants.kHOLE_NUMBER), forKey: Constants.kHOLE_NUMBER)
                
                dictTemp.setValue(((arrayTemp.object(at: i)) as! NSDictionary).value(forKey: Constants.kSCREW_STATUS), forKey: Constants.kSCREW_STATUS)

                arrayfinal.add(dictTemp)
            }
            
            arrGroupB = (arrayfinal.mutableCopy()) as! [[String:Any]]
            
            arrayfinal = NSMutableArray.init()
            
            arrayTemp = NSMutableArray.init(array: arrGroupC)
            
            /*------------------------------------------------------
             Group C
             ------------------------------------------------------*/
            for i in 0..<arrGroupC.count
            {
                dictTemp = NSMutableDictionary()
                
                dictTemp.setValue("\((((arrayTemp.object(at: 0)) as! NSDictionary).value(forKey: Constants.kTRAY_GROUP))!)", forKey: Constants.kTRAY_GROUP)
                
                dictTemp.setValue(((arrayTemp.object(at: i)) as! NSDictionary).value(forKey: Constants.kHOLE_NUMBER), forKey: Constants.kHOLE_NUMBER)
                
                dictTemp.setValue(((arrayTemp.object(at: i)) as! NSDictionary).value(forKey: Constants.kSCREW_STATUS), forKey: Constants.kSCREW_STATUS)

                arrayfinal.add(dictTemp)
            }
            
            arrGroupC = (arrayfinal.mutableCopy()) as! [[String:Any]]
//        }
//        else
//        {
//            arrGroupA = nil
//            arrGroupB = nil
//            arrGroupC = nil
//        }
    }
    
    /*------------------------------------------------------
     The below if the action call of the button of alertView that is customis a delegate method of CustomAlertDelegate. The alertview is same but the actions are different that is being set while calling the alertView custom
     ------------------------------------------------------*/
    func okBtnAction()
    {
        let destVC = self.storyboard?.instantiateViewController(withIdentifier: Constants.kPresurgeryAcceptAndTakePictureViewController) as! PresurgeryAcceptAndTakePictureViewController
        
        /*------------------------------------------------------
         The unwind segue identifier will get change according to the strbaseClass variable that is being set by goToTray and ScanBarcodePreSurgeryViewController controller
         ------------------------------------------------------*/
        destVC.assemblyID = ((webserivceResponse[Constants.knew_Assigned_ID])!)as! NSString
        
        destVC.trayNumber = self.trayNumber
        
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
     Below method will get called from view did load and will be converting the json response of screw details in array form
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
    override func viewWillAppear(_ animated: Bool)
    {
        //self.navigationItem.hidesBackButton = true;        
    }
    
    /*------------------------------------------------------
     Call updateScrewDetails method that wil further call createpreassemblyclone api to clone current tray
     ------------------------------------------------------*/
    @IBAction func actionAccept(_ sender: Any)
    {
        self.updateScrewDetails()
    }
    
    @IBAction func openMenu(_ sender: UIButton)
    {
       CommanMethods.openSideMenu(navigationController: navigationController!)
    }
    
    func updateScrewDetails()-> Void
    {
        CommanMethods.addProgrssView(aStrMessage: Constants.kstrLoading, isActivity: true)
        
        let arrayInput = NSMutableArray.init()
        
        var tempArrGroup = NSArray.init()

        /*------------------------------------------------------
         Store the values of arrGroupA, arrGroupB, arrGroupC into mutable array to perform some of the mutable task as to replace the object
         ------------------------------------------------------*/
        let tempArrGroupA = NSMutableArray.init(array: arrGroupA)

        let tempArrGroupB = NSMutableArray.init(array: arrGroupB)

        let tempArrGroupC = NSMutableArray.init(array: arrGroupC)

        /*------------------------------------------------------
         Here we perform replacement of that array which was already present in the main array arrGroupA, arrGroupB, arrGroupC but state has been altered later for that we perform following steps
         Step 1. Create a predicate that contains a particular hole number and tray group in overrideHoles that is being created when the user clicks on any implant
         Step 2. Check is that combination presents in arrGroupA, if Not then go to Step 3, if Yes then go to Step 5
         Step 3. Check in arrGroupB, if Not then go to Step 4, if Yes then go to Step 6
         Step 4. Check in arrGroupC, if Not then append that array in arrayInput that is newly added implant, if Yes then go to Step 7
         Step 5. Replace that object at that index in tempArrGroupA, so that the status of that implant will get change
         Step 6. Replace that object at that index in tempArrGroupB, so that the status of that implant will get change
         Step 7. Replace that object at that index in tempArrGroupC, so that the status of that implant will get change
         ------------------------------------------------------*/
        for j in 0..<overrideHoles.count
        {
            if ((overrideHoles.object(at: j)as! NSDictionary).value(forKey: Constants.kSCREW_STATUS) as! NSString) != "Other"
            {
                /*------------------------------------------------------
                 Step 1
                 ------------------------------------------------------*/
                let searchPredicate = NSPredicate(format: "SELF.HOLE_NUMBER == %@ AND SELF.TRAY_GROUP == %@", ((overrideHoles.object(at: j)as! NSDictionary).value(forKey: Constants.kHOLE_NUMBER) as! CVarArg),((overrideHoles.object(at: j)as! NSDictionary).value(forKey: Constants.kTRAY_GROUP) as! CVarArg))
                
                /*------------------------------------------------------
                 Step 2
                 ------------------------------------------------------*/
                tempArrGroup = arrGroupA.filter { searchPredicate.evaluate(with: $0) } as NSArray;
                
                /*------------------------------------------------------
                 Step 5
                 ------------------------------------------------------*/
                if(tempArrGroup.count > 0)
                {
                    let index = tempArrGroupA.index(of: tempArrGroup.object(at: 0))
                    
                    tempArrGroupA.replaceObject(at: index, with: overrideHoles.object(at: j))
                }
                    /*------------------------------------------------------
                     Step 3
                     ------------------------------------------------------*/
                else
                {
                    tempArrGroup = arrGroupB.filter { searchPredicate.evaluate(with: $0) } as NSArray;
                    
                    /*------------------------------------------------------
                     Step 6
                     ------------------------------------------------------*/
                    if(tempArrGroup.count > 0)
                    {
                        let index = tempArrGroupB.index(of: tempArrGroup.object(at: 0))
                        
                        tempArrGroupB.replaceObject(at: index, with: overrideHoles.object(at: j))
                    }
                        /*------------------------------------------------------
                         Step 4
                         ------------------------------------------------------*/
                    else
                    {
                        tempArrGroup = arrGroupC.filter { searchPredicate.evaluate(with: $0) } as NSArray;
                        
                        if(tempArrGroup.count > 0)
                        {
                            let index = tempArrGroupC.index(of: tempArrGroup.object(at: 0))
                            
                            tempArrGroupC.replaceObject(at: index, with: overrideHoles.object(at: j))
                        }
                            /*------------------------------------------------------
                             Step 7
                             ------------------------------------------------------*/
                        else
                        {
                            arrayInput.add(overrideHoles.object(at: j))
                        }
                    }
                }
            }
        }
        
        var tempDict = NSMutableDictionary.init()
        var tempNewlyAddedArray = NSMutableArray.init()
        
        for j in 0..<overrideHoles.count
        {
            if(((overrideHoles.object(at: j)as! NSDictionary).value(forKey: Constants.kSCREW_STATUS) as! NSString)) == "Other"
            {
                tempDict = NSMutableDictionary.init()
                
                tempDict.setValue("Present", forKey: Constants.kSCREW_STATUS)
                tempDict.setValue((overrideHoles.object(at: j)as! NSDictionary).value(forKey: Constants.kHOLE_NUMBER), forKey: Constants.kHOLE_NUMBER)
                tempDict.setValue((overrideHoles.object(at: j)as! NSDictionary).value(forKey: Constants.kTRAY_GROUP), forKey: Constants.kTRAY_GROUP)
                tempNewlyAddedArray.add(tempDict)
            }
        }
        
        /*------------------------------------------------------
        Add all the arrays in arrayInput to prepare final input array in api createpreassemblyclone parameter
         ------------------------------------------------------*/
//        let searchPredicate = NSPredicate(format: "SELF.SCREW_STATUS ==[c] Present")
        arrayInput.addObjects(from: tempNewlyAddedArray as! [Any])
        arrayInput.addObjects(from: tempArrGroupA as! [Any])
        arrayInput.addObjects(from: tempArrGroupB as! [Any])
        arrayInput.addObjects(from: tempArrGroupC as! [Any])
        
        let dicionaryForTray = [Constants.kcaseID:"\(((caseId as! NSDictionary).value(forKey: "id"))!)",Constants.ktrayBaseline:arrayInput,Constants.kstrtrayID:"\((dicForsaveTrays[Constants.kstrtrayId]! as! [Any])[trayNumber-1])"] as Dictionary<String,Any>
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let edit = segue.destination as! EditImplantPreSurgeryViewController
        edit.arrSelectedScrews = arrSelectedScrews
        
        if(overrideHoles.count > 0)
        {
            if(edit.overrideHoles.count > 0)
            {
                edit.overrideHoles.addObjects(from: overrideHoles! as! [Any])
            }
            else
            {
                edit.overrideHoles = overrideHoles!
            }
        }
    }
    
    /*------------------------------------------------------
     The number of screws in A = 10 and number of screws in B and C is 8 vertically
     ------------------------------------------------------*/
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == screwsCollectionVw
        {
            return 10
        }
        else
        {
            return 8
            
        }
    }
    
    /*------------------------------------------------------
     The number of screws in A = 24 and number of screws in B = 18 and C = 16 horizontally
     ------------------------------------------------------*/    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if collectionView == screwsCollectionVw
        {
            return 24
        }
        else if collectionView == collectionViewGrpB
        {
            return 18
        }
        else
        {
            return 16
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        //var cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "cellWithLabel", for: indexPath)
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "cellWithLabel2", for: indexPath) as! collectionCell2
        
        let orient = UIApplication.shared.statusBarOrientation
        
        /*------------------------------------------------------
         Based on the device orientation the screws size(btnPis) will get change
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
//            cell.lblText.isHidden = false
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
            else if((dic["SCREW_STATUS"] as! String) == "Other")
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
            if(overrideHoles.count > 0)
            {
                let predicate1 = NSPredicate(format: "SELF.HOLE_NUMBER like '\(dic["HOLE_NUMBER"]!)' AND SELF.TRAY_GROUP == '\(dic["TRAY_GROUP"]!)'");
                
                let arrOverride = overrideHoles.filter { predicate1.evaluate(with: $0) } as! [[String : Any]];
                
                if arrOverride.count > 0
                {
                    let dic = arrOverride[0] as [String:Any]
                    if((dic["SCREW_STATUS"] as! String) == "Present")
                    {
                        cell.btnPin.backgroundColor = UIColor.green
                    }
                    else if((dic["SCREW_STATUS"] as! String) == "Other")
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
        else if(overrideHoles.count > 0)
        {
            var arrOverride : [[String:Any]] = [[String:Any]]()
            
            if collectionView == screwsCollectionVw
            {
                let predicate1 = NSPredicate(format: "SELF.HOLE_NUMBER like '\(strSection)' AND SELF.TRAY_GROUP == '1'");
                
                arrOverride = overrideHoles.filter { predicate1.evaluate(with: $0) } as! [[String : Any]];
                
            }
            else if collectionView == collectionViewGrpB
            {
                let predicate1 = NSPredicate(format: "SELF.HOLE_NUMBER like '\(strSection)' AND SELF.TRAY_GROUP == '2'");
                
                arrOverride = overrideHoles.filter { predicate1.evaluate(with: $0) } as! [[String : Any]];
            }
            else
            {
                let predicate1 = NSPredicate(format: "SELF.HOLE_NUMBER like '\(strSection)' AND SELF.TRAY_GROUP == '3'");
                
                arrOverride = overrideHoles.filter { predicate1.evaluate(with: $0) } as! [[String : Any]];
            }
            
            if(arrOverride.count > 0)
            {
                let dic = arrOverride[0] as [String:Any]
                if((dic["SCREW_STATUS"] as! String) == "Present")
                {
                    cell.btnPin.backgroundColor = UIColor.green
                }
                else if((dic["SCREW_STATUS"] as! String) == "Other")
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


class collectionCell2:UICollectionViewCell {
    @IBOutlet weak var btnPin:UIButton!
    @IBOutlet weak var lblText:UILabel!
    var objSelectedImpantVwController:SelectImplantPreSurgeryViewController!
    
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
        
        if btnPin.isSelected {
            if indexPath != nil {
                var strSection = objSelectedImpantVwController.arrSections.object(at: indexPath!.section) as! String
                strSection = strSection+"\(indexPath!.row+1)"
                
                var arr:[[String:Any]] = [[:]]
                if btnPin.tag == 1 {
                    
                    let predicate1 = NSPredicate(format: "SELF.HOLE_NUMBER like '\(strSection)'");
                    
                    arr = objSelectedImpantVwController.arrGroupA.filter { predicate1.evaluate(with: $0) };
                    
                } else if btnPin.tag == 2 {
                    
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
                    
                    let searchPredicate = NSPredicate(format: "SELF.HOLE_NUMBER ==[c] %@ AND SELF.TRAY_GROUP ==[c] %@", strSection,"\(btnPin.tag)")
                    
                    var arrAlready = NSArray()
                    
                    if(objSelectedImpantVwController.overrideHoles != nil)
                    {
                        arrAlready = objSelectedImpantVwController.overrideHoles.filtered(using: searchPredicate) as NSArray
                    }
                    
                    if(arrAlready.count != 0)
                    {
                        let dic =  NSMutableDictionary.init()
                        
                        dic.setValue("\(strSection)", forKey: Constants.kHOLE_NUMBER)
                        
                        if(btnPin.backgroundColor == UIColor.green)
                        {
                            dic.setValue(Constants.kPresent, forKey: Constants.kSCREW_STATUS)
                        }
                        else if(btnPin.backgroundColor == UIColor.red)
                        {
                            dic.setValue(Constants.kRemoved, forKey: Constants.kSCREW_STATUS)
                        }
                        else if(btnPin.backgroundColor == UIColor(red: 83.0/255.0, green: 119.0/255.0, blue: 178.0/255.0, alpha: 1.0))
                        {
                            dic.setValue("-", forKey: Constants.kSCREW_STATUS)
                        }
                        else
                        {
                            dic.setValue("Other", forKey: Constants.kSCREW_STATUS)
                        }
                        dic.setValue("\(btnPin.tag)", forKey: Constants.kTRAY_GROUP)
                        
                        objSelectedImpantVwController.overrideHoles.remove(dic)
                    }
                    else
                    {
                        
                        let dic = NSMutableDictionary()
                        dic.setValue("\(strSection)", forKey: Constants.kHOLE_NUMBER)
                        if(btnPin.backgroundColor == UIColor.green)
                        {
                            dic.setValue(Constants.kRemoved, forKey: Constants.kSCREW_STATUS)
                        }
                        else if(btnPin.backgroundColor == UIColor.red)
                        {
                            dic.setValue(Constants.kPresent, forKey: Constants.kSCREW_STATUS)
                        }
                        else if(btnPin.backgroundColor == UIColor(red: 83.0/255.0, green: 119.0/255.0, blue: 178.0/255.0, alpha: 1.0))
                        {
                            dic.setValue("Other", forKey: Constants.kSCREW_STATUS)
                        }
                        else
                        {
                            dic.setValue("Other", forKey: Constants.kSCREW_STATUS)
                        }
                        dic.setValue("\(btnPin.tag)", forKey: Constants.kTRAY_GROUP)
                     
                        objSelectedImpantVwController.overrideHoles.add(dic as! [String : Any])
                    }
                }
                else
                {
                    
                    let searchPredicate = NSPredicate(format: "SELF.HOLE_NUMBER ==[c] %@ AND SELF.TRAY_GROUP ==[c] %@", strSection,"\(btnPin.tag)")
                    
                    var arrAlready = NSArray()
                    if(objSelectedImpantVwController.overrideHoles != nil)
                    {
                        arrAlready = objSelectedImpantVwController.overrideHoles.filtered(using: searchPredicate) as NSArray
                    }
                    
                    if(arrAlready.count != 0)
                    {
                        let dic = NSMutableDictionary()
                        dic.setValue("\(strSection)", forKey: Constants.kHOLE_NUMBER)
                        
                        if(btnPin.backgroundColor == UIColor.green)
                        {
                            dic.setValue(Constants.kPresent, forKey: Constants.kSCREW_STATUS)
                        }
                        else if(btnPin.backgroundColor == UIColor.red)
                        {
                            dic.setValue(Constants.kRemoved, forKey: Constants.kSCREW_STATUS)
                        }
                        else if(btnPin.backgroundColor == UIColor(red: 83.0/255.0, green: 119.0/255.0, blue: 178.0/255.0, alpha: 1.0))
                        {
                            dic.setValue("-", forKey: Constants.kSCREW_STATUS)
                        }
                        else
                        {
                            dic.setValue("Other", forKey: Constants.kSCREW_STATUS)
                        }
                        dic.setValue("\(btnPin.tag)", forKey: Constants.kTRAY_GROUP)

                        objSelectedImpantVwController.overrideHoles.remove(dic)
                    }
                    else
                    {
                        let dic = NSMutableDictionary()
                        dic.setValue("\(strSection)", forKey: Constants.kHOLE_NUMBER)
                        if(btnPin.backgroundColor == UIColor.green)
                        {
                            dic.setValue(Constants.kRemoved, forKey: Constants.kSCREW_STATUS)
                        }
                        else if(btnPin.backgroundColor == UIColor.red)
                        {
                            dic.setValue(Constants.kPresent, forKey: Constants.kSCREW_STATUS)
                        }
                        else if(btnPin.backgroundColor == UIColor(red: 83.0/255.0, green: 119.0/255.0, blue: 178.0/255.0, alpha: 1.0))
                        {
                            dic.setValue("Other", forKey: Constants.kSCREW_STATUS)
                        }
                        else
                        {
                            dic.setValue("Other", forKey: Constants.kSCREW_STATUS)
                        }
                        dic.setValue("\(btnPin.tag)", forKey: Constants.kTRAY_GROUP)
                        
                        objSelectedImpantVwController.overrideHoles.add(dic)
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
                if btnPin.tag == 1 {
                    
                    let predicate1 = NSPredicate(format: "SELF.HOLE_NUMBER like '\(strSection)'");
                    
                    arr = objSelectedImpantVwController.arrGroupA.filter { predicate1.evaluate(with: $0) };
                    
                } else if btnPin.tag == 2 {
                    
                    let predicate1 = NSPredicate(format: "SELF.HOLE_NUMBER like '\(strSection)'");
                    arr = objSelectedImpantVwController.arrGroupB.filter { predicate1.evaluate(with: $0) };
                    
                } else {
                    
                    let predicate1 = NSPredicate(format: "SELF.HOLE_NUMBER like '\(strSection)'");
                    arr = objSelectedImpantVwController.arrGroupC.filter { predicate1.evaluate(with: $0) };
                }
                
                
                if(arr.count == 0)
                {
                    //var dicForoverrideHoles = NSMutableDictionary()
                    /*------------------------------------------------------
                     Here we are checking that if the same dictionary is already added in the overrideHoles array or not
                     if it is added then we are taking the same and updating the dictionary
                     ------------------------------------------------------*/

                    let searchPredicate = NSPredicate(format: "SELF.HOLE_NUMBER ==[c] %@ AND SELF.TRAY_GROUP ==[c] %@", strSection,"\(btnPin.tag)")
                    
                    var arrAlready = NSArray()
                    if(objSelectedImpantVwController.overrideHoles != nil)
                    {
                        arrAlready = objSelectedImpantVwController.overrideHoles.filtered(using: searchPredicate) as NSArray
                        
                    }
                    
                    if(arrAlready.count != 0)
                    {
                        let dic =  NSMutableDictionary.init()
                        dic.setValue("\(strSection)", forKey: Constants.kHOLE_NUMBER)
                        if(btnPin.backgroundColor == UIColor.green)
                        {
                            dic.setValue(Constants.kPresent, forKey: Constants.kSCREW_STATUS)
                        }
                        else if(btnPin.backgroundColor == UIColor.red)
                        {
                            dic.setValue(Constants.kRemoved, forKey: Constants.kSCREW_STATUS)
                        }
                        else if(btnPin.backgroundColor == UIColor(red: 83.0/255.0, green: 119.0/255.0, blue: 178.0/255.0, alpha: 1.0))
                        {
                            dic.setValue("-", forKey: Constants.kSCREW_STATUS)
                        }
                        else
                        {
                            dic.setValue("Other", forKey: Constants.kSCREW_STATUS)
                        }
                        dic.setValue("\(btnPin.tag)", forKey: Constants.kTRAY_GROUP)

                        objSelectedImpantVwController.overrideHoles.remove(dic)
                    }
                    else
                    {
                        let dic = NSMutableDictionary()
                        dic.setValue("\(strSection)", forKey: Constants.kHOLE_NUMBER)
                        if(btnPin.backgroundColor == UIColor.green)
                        {
                            dic.setValue(Constants.kRemoved, forKey: Constants.kSCREW_STATUS)
                        }
                        else if(btnPin.backgroundColor == UIColor.red)
                        {
                            dic.setValue(Constants.kPresent, forKey: Constants.kSCREW_STATUS)
                        }
                        else if(btnPin.backgroundColor == UIColor(red: 83.0/255.0, green: 119.0/255.0, blue: 178.0/255.0, alpha: 1.0))
                        {
                            dic.setValue("Other", forKey: Constants.kSCREW_STATUS)
                        }
                        else
                        {
                            dic.setValue("Other", forKey: Constants.kSCREW_STATUS)
                        }
                        dic.setValue("\(btnPin.tag)", forKey: Constants.kTRAY_GROUP)
                    
                        objSelectedImpantVwController.overrideHoles.add(dic)
                        
                    }
                }
                else
                {
                    let searchPredicate = NSPredicate(format: "SELF.HOLE_NUMBER ==[c] %@ AND SELF.TRAY_GROUP ==[c] %@", strSection,"\(btnPin.tag)")
                    
                    var arrAlready = NSArray()
                    if(objSelectedImpantVwController.overrideHoles != nil)
                    {
                        arrAlready = objSelectedImpantVwController.overrideHoles.filtered(using: searchPredicate) as NSArray
                    }
                    
                    if(arrAlready.count != 0)
                    {
                        let dic = NSMutableDictionary()
                        
                        dic.setValue("\(strSection)", forKey: Constants.kHOLE_NUMBER)
                        if(btnPin.backgroundColor == UIColor.green)
                        {
                            dic.setValue(Constants.kPresent, forKey: Constants.kSCREW_STATUS)
                        }
                        else if(btnPin.backgroundColor == UIColor.red)
                        {
                            dic.setValue(Constants.kRemoved, forKey: Constants.kSCREW_STATUS)
                        }
                        else if(btnPin.backgroundColor == UIColor(red: 83.0/255.0, green: 119.0/255.0, blue: 178.0/255.0, alpha: 1.0))
                        {
                            dic.setValue("-", forKey: Constants.kSCREW_STATUS)
                        }
                        else
                        {
                            dic.setValue("Other", forKey: Constants.kSCREW_STATUS)
                        }
                        dic.setValue("\(btnPin.tag)", forKey: Constants.kTRAY_GROUP)
                        
                        objSelectedImpantVwController.overrideHoles.remove(dic)
                    }
                    else
                    {
                        let dic = NSMutableDictionary()
                        dic.setValue("\(strSection)", forKey: Constants.kHOLE_NUMBER)
                       
                        /*------------------------------------------------------
                         Here if the button back ground is yellow then we are sending screwid 0 other wise we are sending the screwid 1
                         ------------------------------------------------------*/
                        if(btnPin.backgroundColor == UIColor.green)
                        {
                            dic.setValue(Constants.kRemoved, forKey: Constants.kSCREW_STATUS)
                        }
                        else if(btnPin.backgroundColor == UIColor.red)
                        {
                            dic.setValue(Constants.kPresent, forKey: Constants.kSCREW_STATUS)
                        }
                        else if(btnPin.backgroundColor == UIColor(red: 83.0/255.0, green: 119.0/255.0, blue: 178.0/255.0, alpha: 1.0))
                        {
                            dic.setValue("Other", forKey: Constants.kSCREW_STATUS)
                        }
                        else
                        {
                            dic.setValue("Other", forKey: Constants.kSCREW_STATUS)
                        }
//
                        dic.setValue("\(btnPin.tag)", forKey: Constants.kTRAY_GROUP)
                        
                        objSelectedImpantVwController.overrideHoles.add(dic)
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
