//
//  AssembleTrayEditImplantViewController.swift
//  FDA
//
//  Created by CYGNET on 24/10/17.
//  Copyright © 2017 Aditya. All rights reserved.
//

import UIKit

class AssembleTrayEditImplantViewController: UIViewController
    ,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, AssembleTrayScanBarCodeViewControllerDelegate, CustomAlertDelegate
{
    var differentiateAlertViewAction = 0
    var trayType : NSString = ""
    @IBOutlet weak var btnRemovedL: UIButton!
    @IBOutlet weak var btnPresentL: UIButton!
    @IBOutlet weak var btnRemovedP: UIButton!
    @IBOutlet weak var btnPresentP: UIButton!
    @IBOutlet weak var lblScrewRemovedL: UILabel!
    @IBOutlet weak var lblScrewPresentL: UILabel!
    @IBOutlet weak var lblScrewRemovedP: UILabel!
    @IBOutlet weak var lblScrewPresentP: UILabel!
    var screwID : NSString = ""
    var identifyVC : NSString = ""
    var tray :Dictionary <String,Any>! = nil
    @IBOutlet weak var btnScanImplant: UIButton!
    @IBOutlet weak var collectionViewGrpB: UICollectionView!
    @IBOutlet weak var btnRemoveImplant: UIButton!
    @IBOutlet weak var collectionViewGrpC: UICollectionView!
    @IBOutlet weak var lblSelectLocation: UILabel!
    var responseCloneTray : NSMutableDictionary = [:]
    @IBOutlet weak var screwsCollectionVw:UICollectionView!
    var dicForImageRecognitionResponse :[String: Any] = [:]
    var arrScrewData : NSMutableArray = []
    var value:Any! = nil
    var iSelectedGroup = 0
    var arrGroup1 = Constants.karrGroup1
    var arrGroup2 = Constants.karrGroup2
    var arrGroup3 = NSArray(objects: "6","7","8","9","10","11","12","14","16","18","20","22","24","26","28","30")
    var arrSections = NSArray(objects: "A","B","C","D","E","F","G","H","I","J","k","L","M","N","O","P","Q","R","S","T","U","V","X","Y","Z")
    var arrSelectedScrews = NSMutableArray()
    var  arrGroupA:[[String:Any]] = [[:]]
    var  arrGroupB:[[String:Any]] = [[:]]
    var  arrGroupC:[[String:Any]] = [[:]]
    var  arrGroupATemp : NSMutableArray = []
    var  arrGroupBTemp :NSMutableArray = []
    var  arrGroupCTemp : NSMutableArray = []
    var  overrideHoles:NSMutableArray! = NSMutableArray()
     var alertView = CustomAlertViewController.init()
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
        
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            
            let orient = UIApplication.shared.statusBarOrientation
            
            switch orient {
            case .portrait:
                self.screwsCollectionVw.reloadData()
                self.collectionViewGrpB.reloadData()
                self.collectionViewGrpC.reloadData()
                print("Portrait")
                
                break
        
            default:
                self.screwsCollectionVw.reloadData()
                self.collectionViewGrpB.reloadData()
                self.collectionViewGrpC.reloadData()
                print("LandScape")
                
                break
            }
        }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            print("rotation completed")
        })
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func viewDidLoad()
    {
        /*------------------------------------------------------
         The data arrScrewData is being created in class AssembleTrayScanBarCodeViewController from api response getsearchtraybybarcode
         ------------------------------------------------------*/
        
        let fullResult = arrScrewData
        
        /*------------------------------------------------------
         Below code will be differentiating the array group according to the tray group and all the editing will be done on the temp array and at the time of the calling api for creating the clone the data is being rendered in tha main array
         ------------------------------------------------------*/
        
        let predicate1 = Constants.kpredicateForGroup1
        let predicate2 = Constants.kpredicateForGroup2
        let predicate3 = Constants.kpredicateForGroup3
        
        arrGroupA = (fullResult as NSArray).filtered(using: predicate1) as! [[String : Any]]
        arrGroupB = (fullResult as NSArray).filtered(using: predicate2) as! [[String : Any]]
        arrGroupC = (fullResult as NSArray).filtered(using: predicate3) as! [[String : Any]]
        
        if(arrGroupA.count > 0)
        {
            arrGroupA = arrGroupA.filter { ("\(String(describing: $0[Constants.kscrewStatus]!))" as NSString) == "Present"}
            arrGroupATemp = NSMutableArray.init(array: arrGroupA)
        }
        
        if(arrGroupB.count > 0)
        {
            arrGroupB = arrGroupB.filter { ("\(String(describing: $0[Constants.kscrewStatus]!))" as NSString) == "Present"}
            arrGroupBTemp = NSMutableArray.init(array: arrGroupB)
        }
        
        if(arrGroupC.count > 0)
        {
            arrGroupC = arrGroupC.filter { ("\(String(describing: $0[Constants.kscrewStatus]!))" as NSString) == "Present"}
            arrGroupCTemp = NSMutableArray.init(array: arrGroupC)
        }
       
        if identifyVC as String == Constants.kstrScanBarCode
        {
            lblSelectLocation.text = Constants.kstrUpdatedImage
            
            btnScanImplant.setTitle(Constants.kstrAddRemoveMoreImplants, for: UIControlState.normal)
            
            btnRemoveImplant.setTitle(Constants.kstrDone, for: UIControlState.normal)
        }
        CommanMethods.removeProgrssView(isActivity: true)
        
        /*------------------------------------------------------
         Below code if for preparing alert view for presenting as alert box and setting the delegate as current class. that will be helpful in calling the action of okbutton when user taps on ok button in alert view
         ------------------------------------------------------*/
        alertView = self.storyboard?.instantiateViewController(withIdentifier: Constants.kCustomAlertViewController) as! CustomAlertViewController
        
        alertView.delegate = self
        /*------------------------------------------------------*/
    }
    
    /*------------------------------------------------------
     Below method will get called from view did load and will be converting the json response of screw details in array form
     ------------------------------------------------------*/
    func convertToArr(text: String) -> [[String: Any]]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    /*------------------------------------------------------
     In viewWillAppear we are setting the buttons hidden and visible acording to the orientation of th device.
     ------------------------------------------------------*/
    override func viewWillAppear(_ animated: Bool)
    {
        let orient = UIApplication.shared.statusBarOrientation
        
        if orient.isPortrait
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
        else if orient.isLandscape
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
        
        //assembledTrayLabel.text = "Assembled Tray \(value!)"
    }
    
    /*------------------------------------------------------
     On the click of the accept button the data of arrSelectedScrews will be send to scan implant screen where the selected implant will get validtate using bar code scan functionality
     ------------------------------------------------------*/
    
    @IBAction func actionAccept(_ sender: Any) {
        
        var strFinal = ""
        for iCount in 0..<arrSelectedScrews.count {
            strFinal = strFinal + (arrSelectedScrews.object(at: iCount) as! String)
            
            if iCount !=  arrSelectedScrews.count-1 {
                strFinal = strFinal + ","
            }
        }
        
        if (arrSelectedScrews.count > 0)
        {
            differentiateAlertViewAction = 2
            
            CommanMethods.alertView(alertView: self.alertView, message: strFinal as NSString, viewController: self, type: 1)
            
//            let alert : UIAlertController = UIAlertController(title: "Selected Values", message: strFinal, preferredStyle:.alert)
//            let alertAction = UIAlertAction (title: "Ok", style: .default,handler: {(action) in
//                self.dismiss(animated: true, completion: nil)
//                self.performSegue(withIdentifier: Constants.kbackToEditImplants, sender: nil)
//            })
//            alert.addAction(alertAction)
//            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            self.performSegue(withIdentifier: Constants.kbackToEditImplants , sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == Constants.kscanImplant )
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
            
            trayDetail.trayGroup = 1
            trayDetail.arrResponseCloneTray = responseCloneTray.value(forKey: Constants.kassemblyDetails) as! NSMutableArray
            trayDetail.trayNumber = responseCloneTray.value(forKey: "id") as! Int
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
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.kcellWithLabel1, for: indexPath) as? collectionCell1
        
        let orient = UIApplication.shared.statusBarOrientation
        
        /*------------------------------------------------------
         Based on the device orientation the screws size(btnPis) will get change
         ------------------------------------------------------*/
        if orient.isPortrait
        {
            if collectionView == screwsCollectionVw
            {
                cell?.btnPin.frame = CGRect(x: 5, y: 3, width: 18, height: 18)
            }
            else
            {
                cell?.btnPin.frame = CGRect(x: 0, y: 5, width: 15, height: 15)
            }
        }
        else if orient.isLandscape
        {
            if collectionView == screwsCollectionVw
            {
                cell?.btnPin.frame = CGRect(x: 10, y: 3, width: 14, height: 14)
            }
            else
            {
                cell?.btnPin.frame = CGRect(x: 10, y: 0, width: 13, height: 13)
            }
        }
        else
        {
            if collectionView == screwsCollectionVw
            {
                cell?.btnPin.frame = CGRect(x: 5, y: 3, width: 18, height: 18)
            }
            else
            {
                cell?.btnPin.frame = CGRect(x: 0, y: 5, width: 15, height: 15)
            }
        }
        
        if indexPath.section == 0
        {
            //cell?.lblText.isHidden = false
            if collectionView == screwsCollectionVw
            {
                cell?.lblText.text = arrGroup1.object(at: indexPath.row) as? String
            }
            else if collectionView == collectionViewGrpB
            {
                cell?.lblText.text = arrGroup2.object(at: indexPath.row) as? String
            }
            else
            {
                cell?.lblText.text = arrGroup3.object(at: indexPath.row) as? String
            }
        }
        else
        {
            cell?.lblText.isHidden = true
        }
        
        var strSection:String = arrSections.object(at: indexPath.section) as! String
        
        strSection = strSection+"\(indexPath.row+1)"
        
        var arr:[[String:Any]] = [[:]]
        
        if collectionView == screwsCollectionVw
        {
            let predicate1 = NSPredicate(format: "SELF.holeNumber like '\(strSection)'");
            arr = arrGroupATemp.filter { predicate1.evaluate(with: $0) } as! [[String : Any]];
        }
        else if collectionView == collectionViewGrpB
        {
            let predicate1 = NSPredicate(format: "SELF.holeNumber like '\(strSection)'");
            arr = arrGroupBTemp.filter { predicate1.evaluate(with: $0) } as! [[String : Any]];
        }
        else
        {
            let predicate1 = NSPredicate(format: "SELF.holeNumber like '\(strSection)'");
            arr = arrGroupCTemp.filter { predicate1.evaluate(with: $0)} as! [[String : Any]];
        }
        
        if(arr.count > 0)
        {
            let dic = arr[0] as [String:Any]
            if((dic[Constants.kscrewStatus] as! String) == Constants.kPresent)
            {
                cell?.btnPin.backgroundColor = UIColor.green
            }
            else if((dic[Constants.kscrewStatus] as! String) == Constants.kother)
            {
                cell?.btnPin.backgroundColor = UIColor.yellow
            }
            else if((dic[Constants.kscrewStatus] as! String) == Constants.kRemoved)
            {
                cell?.btnPin.backgroundColor = UIColor.red
            }
        }
        else
        {
            cell?.btnPin.backgroundColor = UIColor(red: 83.0/255.0, green: 119.0/255.0, blue: 178.0/255.0, alpha: 1.0)
        }
        if collectionView == screwsCollectionVw
        {
            cell?.btnPin.tag = 1
        }
        else if collectionView == collectionViewGrpB
        {
            cell?.btnPin.tag = 2
        }
        else
        {
            cell?.btnPin.tag = 3
        }
        
        cell?.objSelectedImpantVwController1 = self
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView == screwsCollectionVw
        {
            print(Constants.kSuccess)
        }
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
    
    /*------------------------------------------------------
     On the click of the accept button the data of arrSelectedScrews will be send to scan implant screen where the selected implant will get validtate using bar code scan functionality
     ------------------------------------------------------*/
    
    @IBAction func btnScanImplants(_ sender: Any)
    {
        if(overrideHoles.count > 0)
        {
            let msg = "Selected Implant : " + "\nTray Position \((overrideHoles.object(at: 0) as! NSDictionary).value(forKey: Constants.kstrholeNumber) as AnyObject)" + " from Group " + "\((overrideHoles.object(at: 0) as! NSDictionary).value(forKey: Constants.kstrtrayGroup)  as AnyObject)"
         
            differentiateAlertViewAction = 0
            
            CommanMethods.alertView(alertView: self.alertView, message: msg as NSString, viewController: self, type: 1)
        }
        else
        {
            CommanMethods.alertView(message: Constants.kAlert_Please_select_screw as NSString , viewController: self, type: 1)
        }
    }
    
    /*------------------------------------------------------
     The below method will ge called when user clicks on done button. the method name is different as the requirement get change after that. The user can send the screw details which user wants to clone in form of array in  createassemblyclone web service api parameter
     ------------------------------------------------------*/
    
    @IBAction func btnRemoveImplant(_ sender: Any)
    {
        CommanMethods.addProgrssView(aStrMessage: Constants.kstrLoading, isActivity: true)
        
        /*------------------------------------------------------
         The below code will be checking that if the status of any current data is being change from present to remove and vice versa and will be setting that data in the main array
         ------------------------------------------------------*/
        
        /*------------------------------------------------------
         for removed status
         ------------------------------------------------------*/
        
        var predicate = NSPredicate(format: "SELF.screwStatus like 'Removed'");
        var temparrRemovedStatusFromMain = NSArray()
        var temparrGroupFromMain = NSMutableArray.init(array:arrGroupA).mutableCopy()
        var temparrRemovedStatusFromTemp = NSArray()
        
        temparrRemovedStatusFromMain = ((temparrGroupFromMain as AnyObject).filtered(using: predicate) as NSArray).mutableCopy() as! NSArray
        temparrRemovedStatusFromTemp = (arrGroupATemp.filtered(using: predicate) as NSArray).mutableCopy() as! NSArray
        
        if(temparrRemovedStatusFromMain.count < temparrRemovedStatusFromTemp.count)
        {
            for iCount in 0..<temparrRemovedStatusFromTemp.count
            {
                let index = arrGroupATemp.index(of: temparrRemovedStatusFromTemp[iCount])
                
                arrGroupA[index] = temparrRemovedStatusFromTemp[iCount] as! [String : Any]
            }
        }
        temparrGroupFromMain = NSMutableArray.init(array:arrGroupB)
        temparrRemovedStatusFromMain = ((temparrGroupFromMain as AnyObject).filtered(using: predicate) as NSArray).mutableCopy() as! NSArray
        temparrRemovedStatusFromTemp = (arrGroupBTemp.filtered(using: predicate) as NSArray).mutableCopy() as! NSArray
        if(temparrRemovedStatusFromMain.count < temparrRemovedStatusFromTemp.count)
        {
            for iCount in 0..<temparrRemovedStatusFromTemp.count
            {
                let index = arrGroupBTemp.index(of: temparrRemovedStatusFromTemp[iCount])
                
                arrGroupB[index] = temparrRemovedStatusFromTemp[iCount] as! [String : Any]
            }
        }
        temparrGroupFromMain = NSMutableArray.init(array:arrGroupC)
        temparrRemovedStatusFromMain = ((temparrGroupFromMain as AnyObject).filtered(using: predicate) as NSArray).mutableCopy() as! NSArray
        temparrRemovedStatusFromTemp = (arrGroupCTemp.filtered(using: predicate) as NSArray).mutableCopy() as! NSArray
        if(temparrRemovedStatusFromMain.count < temparrRemovedStatusFromTemp.count)
        {
            for iCount in 0..<temparrRemovedStatusFromTemp.count
            {
                let index = arrGroupCTemp.index(of: temparrRemovedStatusFromTemp[iCount])
                
                arrGroupC[index] = temparrRemovedStatusFromTemp[iCount] as! [String : Any]
            }
        }
        
        /*------------------------------------------------------
          for present status
         ------------------------------------------------------*/
        
        predicate = NSPredicate(format: "SELF.screwStatus like 'Present'");
        temparrRemovedStatusFromMain = NSArray()
        temparrGroupFromMain = NSMutableArray.init(array:arrGroupA).mutableCopy()
        temparrRemovedStatusFromTemp = NSArray()
        
        temparrRemovedStatusFromMain = ((temparrGroupFromMain as AnyObject).filtered(using: predicate) as NSArray).mutableCopy() as! NSArray
        temparrRemovedStatusFromTemp = (arrGroupATemp.filtered(using: predicate) as NSArray).mutableCopy() as! NSArray
        
        if(temparrRemovedStatusFromMain.count < temparrRemovedStatusFromTemp.count)
        {
            for iCount in 0..<temparrRemovedStatusFromTemp.count
            {
                let index = arrGroupATemp.index(of: temparrRemovedStatusFromTemp[iCount])
                
                arrGroupA[index] = temparrRemovedStatusFromTemp[iCount] as! [String : Any]
            }
        }
        temparrGroupFromMain = NSMutableArray.init(array:arrGroupB)
        temparrRemovedStatusFromMain = ((temparrGroupFromMain as AnyObject).filtered(using: predicate) as NSArray).mutableCopy() as! NSArray
        temparrRemovedStatusFromTemp = (arrGroupBTemp.filtered(using: predicate) as NSArray).mutableCopy() as! NSArray
        if(temparrRemovedStatusFromMain.count < temparrRemovedStatusFromTemp.count)
        {
            for iCount in 0..<temparrRemovedStatusFromTemp.count
            {
                let index = arrGroupBTemp.index(of: temparrRemovedStatusFromTemp[iCount])
                
                arrGroupB[index] = temparrRemovedStatusFromTemp[iCount] as! [String : Any]
            }
        }
        temparrGroupFromMain = NSMutableArray.init(array:arrGroupC)
        temparrRemovedStatusFromMain = ((temparrGroupFromMain as AnyObject).filtered(using: predicate) as NSArray).mutableCopy() as! NSArray
        temparrRemovedStatusFromTemp = (arrGroupCTemp.filtered(using: predicate) as NSArray).mutableCopy() as! NSArray
        if(temparrRemovedStatusFromMain.count < temparrRemovedStatusFromTemp.count)
        {
            for iCount in 0..<temparrRemovedStatusFromTemp.count
            {
                let index = arrGroupCTemp.index(of: temparrRemovedStatusFromTemp[iCount])
                
                arrGroupC[index] = temparrRemovedStatusFromTemp[iCount] as! [String : Any]
            }
        }
        let arrData = NSMutableArray.init(array: arrGroupA + arrGroupB + arrGroupC)
        let dicionaryForTray = [Constants.kstrtrayID :"\((tray["id"]!))",Constants.ktrayBaseline:arrData] as Dictionary<String,Any>
        
        /*------------------------------------------------------
         Below api call will be sending the screw details to server for creating a clone of current tray using the screw details after alteration
         ------------------------------------------------------*/
        
        print(dicionaryForTray)
        
        CommanAPIs().saveassembly(dicionaryForTray, Constants.kcreateassemblyclone, { (response,err) in
            
            CommanMethods.removeProgrssView(isActivity: true)
            
            if response != nil
            {
                self.responseCloneTray = NSMutableDictionary.init(dictionary: response!)
                
                self.differentiateAlertViewAction = 1;
                
                CommanMethods.alertView(alertView: self.alertView, message: Constants.kTray_Assembly_Has_Been_Edited as NSString, viewController: self, type: 1)
            }
            else
            {
                CommanMethods.alertView(message: Constants.kstrWrongResponse as NSString , viewController: self, type: 1)
            }
        })
    }
    
    @IBAction func openMenu(_ sender: Any)
    {
       CommanMethods.openSideMenu(navigationController: navigationController!)
    }
    
    /*------------------------------------------------------
     The below method is delegate method of AssembleTrayScanBarCodeViewController class when user will be poping the controller from AssembleTrayScanBarCodeViewController class after scanning the prod bar code and if the response if successful then that particular array will be set in the main array
     ------------------------------------------------------*/
    func validateScrewForProductApiResponse(response : Bool)->Void
    {
        if(response)
        {
            let dic = NSMutableDictionary.init()
            dic.setValue("\(String(describing: (overrideHoles.object(at: 0) as! NSDictionary).value(forKey: Constants.ktrayGroup)!))", forKey: Constants.ktrayGroup)
            dic.setValue(Constants.kPresent, forKey: Constants.kscrewStatus)
            dic.setValue((overrideHoles.object(at: 0) as! NSDictionary).value(forKey: Constants.kstrholeNumber), forKey: Constants.kstrholeNumber)
            
            /*------------------------------------------------------
             Updated on 19-Jan-2018 12:23 PM
             
             The below code is used to distinguish between the old screws and the newly added screws. as we need to add screwID parameter in newly added screws and keep the old ones the same with three paramters as tray group, hole number, status while calling the createassemblyclone api
             ------------------------------------------------------*/
            dic.setValue(screwID, forKey: Constants.kscrewID)
            
            if(arrGroupATemp.count > arrGroupA.count)
            {
                arrGroupATemp.removeLastObject()
                arrGroupATemp.add(dic)
                arrGroupA = arrGroupATemp as! [[String : Any]]
            }
            else if(arrGroupBTemp.count > arrGroupB.count)
            {
                arrGroupBTemp.removeLastObject()
                arrGroupBTemp.add(dic)
                arrGroupB = arrGroupBTemp as! [[String : Any]]
            }
            else if(arrGroupCTemp.count > arrGroupC.count)
            {
                arrGroupCTemp.removeLastObject()
                arrGroupCTemp.add(dic)
                arrGroupC = arrGroupCTemp as! [[String : Any]]
                
            }
        }
        else
        {
            if(arrGroupATemp.count > arrGroupA.count)
            {
                arrGroupATemp.removeLastObject()
            }
            else if(arrGroupBTemp.count > arrGroupB.count)
            {
                arrGroupBTemp.removeLastObject()
            }
            else if(arrGroupCTemp.count > arrGroupC.count)
            {
                arrGroupCTemp.removeLastObject()
            }
        }
        overrideHoles.removeAllObjects()
        screwsCollectionVw.reloadData()
        collectionViewGrpB.reloadData()
        collectionViewGrpC.reloadData()
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
     The below if the action call of the button of alertView that is customis a delegate method of CustomAlertDelegate. The alertview is same but the actions are different that is being set while calling the alertView custom
     ------------------------------------------------------*/
    func okBtnAction()
    {
        if(differentiateAlertViewAction == 0)
        {
            self.performSegue(withIdentifier: Constants.kscanImplant , sender: nil)
        }
        else if differentiateAlertViewAction == 1
        {
            self.performSegue(withIdentifier: Constants.kGoToAssembleTrayDetail, sender: nil)
        }
        else
        {
            self.performSegue(withIdentifier: Constants.kbackToEditImplants, sender: nil)
        }
    }
}

class collectionCell1:UICollectionViewCell {
    @IBOutlet weak var btnPin:UIButton!
    @IBOutlet weak var lblText:UILabel!
    var objSelectedImpantVwController1:AssembleTrayEditImplantViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnPin.layer.cornerRadius = btnPin.frame.size.width/2
    }
    
    @IBAction func btnPinClicked(_ sender:Any)
    {
        btnPin.isUserInteractionEnabled = false;
        
        let indexPath:IndexPath?
        
        if(btnPin.tag == 1)
        {
            indexPath = objSelectedImpantVwController1.screwsCollectionVw.indexPath(for: self)
        }
        else if (btnPin.tag == 2)
        {
            indexPath = objSelectedImpantVwController1.collectionViewGrpB.indexPath(for: self)
        }
        else
        {
            indexPath = objSelectedImpantVwController1.collectionViewGrpC.indexPath(for: self)
        }
        
        if btnPin.isSelected {
            if indexPath != nil {
                var strSection = objSelectedImpantVwController1.arrSections.object(at: indexPath!.section) as! String
                strSection = strSection+"\(indexPath!.row+1)"
                
                var arr:[[String:Any]] = [[:]]
                if btnPin.tag == 1 {
                    
                    let predicate1 = NSPredicate(format: "SELF.holeNumber like '\(strSection)'");
                    
                    arr = objSelectedImpantVwController1.arrGroupATemp.filter { predicate1.evaluate(with: $0) } as! [[String : Any]];
                    
                } else if btnPin.tag == 2 {
                    
                    let predicate1 = NSPredicate(format: "SELF.holeNumber like '\(strSection)'");
                    arr = objSelectedImpantVwController1.arrGroupBTemp.filter { predicate1.evaluate(with: $0) } as! [[String : Any]];
                    
                } else {
                    
                    let predicate1 = NSPredicate(format: "SELF.holeNumber like '\(strSection)'");
                    arr = objSelectedImpantVwController1.arrGroupCTemp.filter { predicate1.evaluate(with: $0) } as! [[String : Any]];
                }
                
                
                if(arr.count == 0)
                {
                    //var dicForoverrideHoles:[String:Any] = [:]
                    
                    /*------------------------------------------------------
                     Here we are checking that if the same dictionary is already added in the overrideHoles array or not
                     if it is added then we are taking the same and updating the dictionary
                     ------------------------------------------------------*/
                    
                    let searchPredicate = NSPredicate(format: "SELF.holeNumber ==[c] %@ AND SELF.trayGroup ==[c] %@", strSection,"\(btnPin.tag + 2)")
                    
                    var arrAlready = NSArray()
                    
                    if(objSelectedImpantVwController1.overrideHoles != nil)
                    {
                        arrAlready = objSelectedImpantVwController1.overrideHoles.filtered(using: searchPredicate) as NSArray
                    }
                    
                    if(arrAlready.count != 0)
                    {
                        let dic = arrAlready[0] as! NSMutableDictionary
                        
                        dic.setValue("\(strSection)", forKey: Constants.kstrholeNumber)
                        
                        dic.setValue("\(btnPin.tag + 2)", forKey: Constants.ktrayGroup)
                        
                        if(btnPin.tag == 1)
                        {
                            objSelectedImpantVwController1.arrGroupATemp.removeLastObject()
                        }
                        else if(btnPin.tag == 2)
                        {
                            objSelectedImpantVwController1.arrGroupBTemp.removeLastObject()
                        }
                        else
                        {
                            objSelectedImpantVwController1.arrGroupCTemp.removeLastObject()
                        }
                        
                        objSelectedImpantVwController1.overrideHoles.removeAllObjects()
                    }
                    else
                    {
                        let searchPredicate1 = NSPredicate(format: "SELF.holeNumber ==[c] %@", strSection)
                        
                        if(btnPin.tag == 1)
                        {
                            arrAlready = objSelectedImpantVwController1.arrGroupATemp.filtered(using: searchPredicate1) as NSArray
                        }
                        else if(btnPin.tag == 2)
                        {
                            arrAlready = objSelectedImpantVwController1.arrGroupBTemp.filtered(using: searchPredicate1) as NSArray
                        }
                        else
                        {
                            arrAlready = objSelectedImpantVwController1.arrGroupCTemp.filtered(using: searchPredicate1) as NSArray
                        }
                        if(arrAlready.count != 0)
                        {
                            let dic = NSMutableDictionary.init()
                            dic["holeNumber"] = "\(strSection)"
                            
                            /*------------------------------------------------------
                             Here if the button back ground is yellow then we are sending screwid 0 other wise we are sending the screwid 1
                             ------------------------------------------------------*/
                            
                            if(btnPin.backgroundColor == UIColor.yellow || btnPin.backgroundColor == UIColor.green)
                            {
                                //dic["SCREW_ID"] = 0
                            }
                            else
                            {
                                // dic["SCREW_ID"] = 1
                            }
                            
                            dic["trayGroup"] = "\(btnPin.tag)"
                            let arrTemp = NSMutableArray.init(array: arrAlready)
                            if((arrTemp.object(at: 0) as! [String : Any])[Constants.kscrewStatus] as! NSString) as String == Constants.kRemoved
                            {
                                dic[Constants.kscrewStatus] = Constants.kPresent
                            }
                            else
                            {
                                dic[Constants.kscrewStatus] = Constants.kRemoved
                            }
                            if(btnPin.tag == 1)
                            {
                                let index = objSelectedImpantVwController1.arrGroupATemp.index(of:arrAlready.object(at: 0))
                                objSelectedImpantVwController1.arrGroupATemp.replaceObject(at: index, with: dic)
                            }
                            else if(btnPin.tag == 2)
                            {
                                let index = objSelectedImpantVwController1.arrGroupBTemp.index(of:arrAlready.object(at: 0))
                                objSelectedImpantVwController1.arrGroupBTemp.replaceObject(at: index, with: dic)
                            }
                            else
                            {
                                let index = objSelectedImpantVwController1.arrGroupCTemp.index(of:arrAlready.object(at: 0))
                                objSelectedImpantVwController1.arrGroupCTemp.replaceObject(at: index, with: dic)
                            }
                        }
                        else
                        {
                            let dic = NSMutableDictionary()
                            dic.setValue("\(strSection)", forKey: Constants.kstrholeNumber)
                            
                            if(btnPin.tag == 1)
                            {
                                dic.setValue("\(btnPin.tag )" , forKey: Constants.ktrayGroup)
                            }
                            else if(btnPin.tag == 2)
                            {
                                dic.setValue("\(btnPin.tag )" , forKey: Constants.ktrayGroup)
                            }
                            else
                            {
                                dic.setValue("\(btnPin.tag )" , forKey: Constants.ktrayGroup)
                            }
                            
                            objSelectedImpantVwController1.overrideHoles.removeAllObjects()
                            dic[Constants.kscrewStatus] = Constants.kother
                            if(objSelectedImpantVwController1.overrideHoles.count > 0)
                            {
                                if(objSelectedImpantVwController1.arrGroupATemp.count > objSelectedImpantVwController1.arrGroupA.count)
                                {
                                    objSelectedImpantVwController1.arrGroupATemp.removeLastObject()
                                }
                                else if(objSelectedImpantVwController1.arrGroupBTemp.count > objSelectedImpantVwController1.arrGroupB.count)
                                {
                                    objSelectedImpantVwController1.arrGroupBTemp.removeLastObject()
                                }
                                else if(objSelectedImpantVwController1.arrGroupCTemp.count > objSelectedImpantVwController1.arrGroupC.count)
                                {
                                    objSelectedImpantVwController1.arrGroupCTemp.removeLastObject()
                                }
                            }
                            
                            if(btnPin.tag == 1)
                            {
                                
                                objSelectedImpantVwController1.arrGroupATemp.add(dic)
                            }
                            else if (btnPin.tag == 2)
                            {
                                objSelectedImpantVwController1.arrGroupBTemp.add(dic)
                                
                            }
                            else
                            {
                                objSelectedImpantVwController1.arrGroupCTemp.add(dic)
                                
                            }
                            objSelectedImpantVwController1.overrideHoles.add(dic as! [String : Any])
                        }
                    }
                }
                else
                {
                    
                    let searchPredicate = NSPredicate(format: "SELF.holeNumber ==[c] %@ AND SELF.trayGroup ==[c] %@", strSection,"\(btnPin.tag + 2)")
                    
                    var arrAlready = NSArray()
                    if(objSelectedImpantVwController1.overrideHoles != nil)
                    {
                        arrAlready = objSelectedImpantVwController1.overrideHoles.filtered(using: searchPredicate) as NSArray
                    }
                    
                    if(arrAlready.count != 0)
                    {
                        let dic = NSMutableDictionary.init()
                        dic["holeNumber"] = "\(strSection)"
                        //dic["SCREW_ID"] = 0
                        dic["trayGroup"] = "\(btnPin.tag)"
                        if(btnPin.tag == 1)
                        {
                            objSelectedImpantVwController1.arrGroupATemp.removeLastObject()
                        }
                        else if(btnPin.tag == 2)
                        {
                            objSelectedImpantVwController1.arrGroupBTemp.removeLastObject()
                        }
                        else
                        {
                            objSelectedImpantVwController1.arrGroupCTemp.removeLastObject()
                        }
                        
                        objSelectedImpantVwController1.overrideHoles.removeAllObjects()
                    }
                    else
                    {
                        let searchPredicate1 = NSPredicate(format: "SELF.holeNumber ==[c] %@", strSection)
                        
                        if(btnPin.tag == 1)
                        {
                            arrAlready = objSelectedImpantVwController1.arrGroupATemp.filtered(using: searchPredicate1) as NSArray
                        }
                        else if(btnPin.tag == 2)
                        {
                            arrAlready = objSelectedImpantVwController1.arrGroupBTemp.filtered(using: searchPredicate1) as NSArray
                        }
                        else
                        {
                            arrAlready = objSelectedImpantVwController1.arrGroupCTemp.filtered(using: searchPredicate1) as NSArray
                        }
                        if(arrAlready.count != 0)
                        {
                            let dic = NSMutableDictionary.init()
                            let arrTemp = NSMutableArray.init(array: arrAlready)
                            dic["holeNumber"] = "\(strSection)"
                            
                            /*------------------------------------------------------
                             Here if the button back ground is yellow then we are sending screwid 0 other wise we are sending the screwid 1
                             ------------------------------------------------------*/
                            
                            if(btnPin.backgroundColor == UIColor.yellow || btnPin.backgroundColor == UIColor.green)
                            {
                                //dic["SCREW_ID"] = 0
                            }
                            else
                            {
                                // dic["SCREW_ID"] = 1
                            }
                            
                            dic["trayGroup"] = "\(btnPin.tag)"
                            
                            if((arrTemp.object(at: 0) as! [String : Any])[Constants.kscrewStatus] as! NSString) as String == Constants.kRemoved
                            {
                                dic[Constants.kscrewStatus] = Constants.kPresent
                            }
                            else
                            {
                                dic[Constants.kscrewStatus] = Constants.kRemoved
                            }
                            
                            if(btnPin.tag == 1)
                            {
                                let index = objSelectedImpantVwController1.arrGroupATemp.index(of:arrAlready.object(at: 0))
                                objSelectedImpantVwController1.arrGroupATemp.replaceObject(at: index, with: dic)
                            }
                            else if(btnPin.tag == 2)
                            {
                                let index = objSelectedImpantVwController1.arrGroupBTemp.index(of:arrAlready.object(at: 0))
                                objSelectedImpantVwController1.arrGroupBTemp.replaceObject(at: index, with: dic)
                            }
                            else
                            {
                                let index = objSelectedImpantVwController1.arrGroupCTemp.index(of:arrAlready.object(at: 0))
                                objSelectedImpantVwController1.arrGroupCTemp.replaceObject(at: index, with: dic)
                            }
                        }
                        else
                        {
                            var dic = arr[0] as [NSString:Any]
                            dic["holeNumber"] = "\(strSection)"
                            //dic["SCREW_ID"] = 0
                            dic["trayGroup"] = "\(btnPin.tag)"
                            dic["screwStatus"] = Constants.kother
                            
                            objSelectedImpantVwController1.overrideHoles.removeAllObjects()
                            if(objSelectedImpantVwController1.overrideHoles.count > 0)
                            {
                                if(objSelectedImpantVwController1.arrGroupATemp.count > objSelectedImpantVwController1.arrGroupA.count)
                                {
                                    objSelectedImpantVwController1.arrGroupATemp.removeLastObject()
                                }
                                else if(objSelectedImpantVwController1.arrGroupBTemp.count > objSelectedImpantVwController1.arrGroupB.count)
                                {
                                    objSelectedImpantVwController1.arrGroupBTemp.removeLastObject()
                                }
                                else if(objSelectedImpantVwController1.arrGroupCTemp.count > objSelectedImpantVwController1.arrGroupC.count)
                                {
                                    objSelectedImpantVwController1.arrGroupCTemp.removeLastObject()
                                }
                            }
                            
                            if(btnPin.tag == 1)
                            {
                                objSelectedImpantVwController1.arrGroupATemp.add(dic)
                            }
                            else if (btnPin.tag == 2)
                            {
                                objSelectedImpantVwController1.arrGroupBTemp.add(dic)
                                
                            }
                            else
                            {
                                objSelectedImpantVwController1.arrGroupCTemp.add(dic)
                                
                            }
                            objSelectedImpantVwController1.overrideHoles.add(dic)
                        }
                    }
                }
                
                if objSelectedImpantVwController1.arrSelectedScrews.contains(strSection) {
                    objSelectedImpantVwController1.arrSelectedScrews.remove(strSection)
                }
            }
            btnPin.isSelected = false
        } else {
            if indexPath != nil {
                var strSection = objSelectedImpantVwController1.arrSections.object(at: indexPath!.section) as! String
                strSection = strSection+"\(indexPath!.row+1)"
                
                var arr:[[String:Any]] = [[:]]
                if btnPin.tag == 1 {
                    
                    let predicate1 = NSPredicate(format: "SELF.holeNumber like '\(strSection)'");
                    
                    arr = objSelectedImpantVwController1.arrGroupATemp.filter { predicate1.evaluate(with: $0) } as! [[String : Any]];
                    
                } else if btnPin.tag == 2 {
                    
                    let predicate1 = NSPredicate(format: "SELF.holeNumber like '\(strSection)'");
                    arr = objSelectedImpantVwController1.arrGroupBTemp.filter { predicate1.evaluate(with: $0) } as! [[String : Any]];
                    
                } else {
                    
                    let predicate1 = NSPredicate(format: "SELF.holeNumber like '\(strSection)'");
                    arr = objSelectedImpantVwController1.arrGroupCTemp.filter { predicate1.evaluate(with: $0) } as! [[String : Any]];
                }
                
                
                if(arr.count == 0)
                {
                    //var dicForoverrideHoles = NSMutableDictionary()
                    /*------------------------------------------------------
                     Here we are checking that if the same dictionary is already added in the overrideHoles array or not
                     if it is added then we are taking the same and updating the dictionary
                     ------------------------------------------------------*/
                    
                    let searchPredicate = NSPredicate(format: "SELF.holeNumber ==[c] %@ AND SELF.trayGroup ==[c] %@", strSection,"\(btnPin.tag)")
                    
                    var arrAlready = NSArray()
                    if(objSelectedImpantVwController1.overrideHoles != nil)
                    {
                        arrAlready = objSelectedImpantVwController1.overrideHoles.filtered(using: searchPredicate) as NSArray
                        
                    }
                    
                    if(arrAlready.count != 0)
                    {
                        let dic = arrAlready[0] as! NSMutableDictionary
                        dic.setValue("\(strSection)", forKey: Constants.kstrholeNumber)
                        //dic.setValue(1, forKey: "SCREW_ID")
                        dic.setValue("\(btnPin.tag)", forKey: "trayGroup")
                        if(btnPin.tag == 1)
                        {
                            objSelectedImpantVwController1.arrGroupATemp.removeLastObject()
                        }
                        else if(btnPin.tag == 2)
                        {
                            objSelectedImpantVwController1.arrGroupBTemp.removeLastObject()
                        }
                        else
                        {
                            objSelectedImpantVwController1.arrGroupCTemp.removeLastObject()
                        }
                        
                        objSelectedImpantVwController1.overrideHoles.removeAllObjects()
                    }
                    else
                    {
                        let searchPredicate1 = NSPredicate(format: "SELF.holeNumber ==[c] %@", strSection)
                        
                        if(btnPin.tag == 1)
                        {
                            arrAlready = objSelectedImpantVwController1.arrGroupATemp.filtered(using: searchPredicate1) as NSArray
                        }
                        else if(btnPin.tag == 2)
                        {
                            arrAlready = objSelectedImpantVwController1.arrGroupBTemp.filtered(using: searchPredicate1) as NSArray
                        }
                        else
                        {
                            arrAlready = objSelectedImpantVwController1.arrGroupCTemp.filtered(using: searchPredicate1) as NSArray
                        }
                        if(arrAlready.count != 0)
                        {
                            let dic = NSMutableDictionary.init()
                            dic["holeNumber"] = "\(strSection)"
                            
                            /*------------------------------------------------------
                             Here if the button back ground is yellow then we are sending screwid 0 other wise we are sending the screwid 1
                             ------------------------------------------------------*/
                            
                            if(btnPin.backgroundColor == UIColor.yellow || btnPin.backgroundColor == UIColor.green)
                            {
                                //dic["SCREW_ID"] = 0
                            }
                            else
                            {
                                // dic["SCREW_ID"] = 1
                            }
                            
                            dic["trayGroup"] = "\(btnPin.tag)"
                            let arrTemp = NSMutableArray.init(array: arrAlready)
                            if((arrTemp.object(at: 0) as! [String : Any])[Constants.kscrewStatus] as! NSString) as String == Constants.kRemoved
                            {
                                dic[Constants.kscrewStatus] = Constants.kPresent
                            }
                            else
                            {
                                dic[Constants.kscrewStatus] = Constants.kRemoved
                            }
                            
                            if(btnPin.tag == 1)
                            {
                                let index = objSelectedImpantVwController1.arrGroupATemp.index(of:arrAlready.object(at: 0))
                                objSelectedImpantVwController1.arrGroupATemp.replaceObject(at: index, with: dic)
                            }
                            else if(btnPin.tag == 2)
                            {
                                let index = objSelectedImpantVwController1.arrGroupBTemp.index(of:arrAlready.object(at: 0))
                                objSelectedImpantVwController1.arrGroupBTemp.replaceObject(at: index, with: dic)
                            }
                            else
                            {
                                let index = objSelectedImpantVwController1.arrGroupCTemp.index(of:arrAlready.object(at: 0))
                                objSelectedImpantVwController1.arrGroupCTemp.replaceObject(at: index, with: dic)
                            }
                        }
                        else
                        {
                            let dic = NSMutableDictionary()
                            dic.setValue("\(strSection)", forKey: Constants.kstrholeNumber)
                            //dic.setValue(1, forKey: "SCREW_ID")
                            dic.setValue("\(btnPin.tag)", forKey: "trayGroup")
                            dic["screwStatus"] = Constants.kother
                            if(objSelectedImpantVwController1.overrideHoles.count > 0)
                            {
                                if(objSelectedImpantVwController1.arrGroupATemp.count > objSelectedImpantVwController1.arrGroupA.count)
                                {
                                    objSelectedImpantVwController1.arrGroupATemp.removeLastObject()
                                }
                                else if(objSelectedImpantVwController1.arrGroupBTemp.count > objSelectedImpantVwController1.arrGroupB.count)
                                {
                                    objSelectedImpantVwController1.arrGroupBTemp.removeLastObject()
                                }
                                else if(objSelectedImpantVwController1.arrGroupCTemp.count > objSelectedImpantVwController1.arrGroupC.count)
                                {
                                    objSelectedImpantVwController1.arrGroupCTemp.removeLastObject()
                                }
                            }
                            
                            if(btnPin.tag == 1)
                            {
                                objSelectedImpantVwController1.arrGroupATemp.add(dic)
                            }
                            else if (btnPin.tag == 2)
                            {
                                objSelectedImpantVwController1.arrGroupBTemp.add(dic)
                            }
                            else
                            {
                                objSelectedImpantVwController1.arrGroupCTemp.add(dic)
                                
                            }
                            objSelectedImpantVwController1.overrideHoles.removeAllObjects()
                            objSelectedImpantVwController1.overrideHoles.add(dic)
                            
                        }
                    }
                }
                else
                {
                    let searchPredicate = NSPredicate(format: "SELF.holeNumber ==[c] %@ AND SELF.trayGroup ==[c] %@", strSection,"\(btnPin.tag)")
                    
                    var arrAlready = NSArray()
                    if(objSelectedImpantVwController1.overrideHoles != nil)
                    {
                        arrAlready = objSelectedImpantVwController1.overrideHoles.filtered(using: searchPredicate) as NSArray
                    }
                    
                    if(arrAlready.count != 0)
                    {
                        let dic = NSMutableDictionary.init()
                        dic["holeNumber"] = "\(strSection)"
                        //dic["SCREW_ID"] = 1
                        
                        dic["trayGroup"] = "\(btnPin.tag)"
                        
                        if(btnPin.tag == 1)
                        {
                            objSelectedImpantVwController1.arrGroupATemp.removeLastObject()
                        }
                        else if(btnPin.tag == 2)
                        {
                            objSelectedImpantVwController1.arrGroupBTemp.removeLastObject()
                        }
                        else
                        {
                            objSelectedImpantVwController1.arrGroupCTemp.removeLastObject()
                        }
                        objSelectedImpantVwController1.overrideHoles.removeAllObjects()
                    }
                    else
                    {
                        let searchPredicate1 = NSPredicate(format: "SELF.holeNumber ==[c] %@", strSection)
                        
                        if(btnPin.tag == 1)
                        {
                            arrAlready = objSelectedImpantVwController1.arrGroupATemp.filtered(using: searchPredicate1) as NSArray
                        }
                        else if(btnPin.tag == 2)
                        {
                            arrAlready = objSelectedImpantVwController1.arrGroupBTemp.filtered(using: searchPredicate1) as NSArray
                        }
                        else
                        {
                            arrAlready = objSelectedImpantVwController1.arrGroupCTemp.filtered(using: searchPredicate1) as NSArray
                        }
                        if(arrAlready.count != 0)
                        {
                            let dic = NSMutableDictionary.init()
                            dic["holeNumber"] = "\(strSection)"
                            
                            /*------------------------------------------------------
                             Here if the button back ground is yellow then we are sending screwid 0 other wise we are sending the screwid 1
                             ------------------------------------------------------*/
                            
                            if(btnPin.backgroundColor == UIColor.yellow || btnPin.backgroundColor == UIColor.green)
                            {
                                //dic["SCREW_ID"] = 0
                            }
                            else
                            {
                                // dic["SCREW_ID"] = 1
                            }
                            
                            dic["trayGroup"] = "\(btnPin.tag)"
                            
                            let arrTemp = NSMutableArray.init(array: arrAlready)
                            
                            if((arrTemp.object(at: 0) as! [String : Any])["screwStatus"] as! NSString) as String == Constants.kRemoved
                            {
                                dic["screwStatus"] = Constants.kPresent
                            }
                            else
                            {
                                dic["screwStatus"] = Constants.kRemoved
                            }
                            
                            if(btnPin.tag == 1)
                            {
                                let index = objSelectedImpantVwController1.arrGroupATemp.index(of:arrAlready.object(at: 0))
                                
                                objSelectedImpantVwController1.arrGroupATemp.replaceObject(at: index, with: dic)
                            }
                            else if(btnPin.tag == 2)
                            {
                                let index = objSelectedImpantVwController1.arrGroupBTemp.index(of:arrAlready.object(at: 0))
                                objSelectedImpantVwController1.arrGroupBTemp.replaceObject(at: index, with: dic)
                            }
                            else
                            {
                                let index = objSelectedImpantVwController1.arrGroupCTemp.index(of:arrAlready.object(at: 0))
                                objSelectedImpantVwController1.arrGroupCTemp.replaceObject(at: index, with: dic)
                            }
                        }
                        else if(arrAlready.count == 0)
                        {
                            var dic = arr[0] as [NSString:Any]
                            dic["holeNumber"] = "\(strSection)"
                            
                            /*------------------------------------------------------
                             Here if the button back ground is yellow then we are sending screwid 0 other wise we are sending the screwid 1
                             ------------------------------------------------------*/
                            
                            if(btnPin.backgroundColor == UIColor.yellow || btnPin.backgroundColor == UIColor.green)
                            {
                                //dic["SCREW_ID"] = 0
                            }
                            else
                            {
                                // dic["SCREW_ID"] = 1
                            }
                            
                            dic["trayGroup"] = "\(btnPin.tag)"
                            dic["screwStatus"] = Constants.kother
                            if(objSelectedImpantVwController1.overrideHoles.count > 0)
                            {
                                if(objSelectedImpantVwController1.arrGroupATemp.count > objSelectedImpantVwController1.arrGroupA.count)
                                {
                                    objSelectedImpantVwController1.arrGroupATemp.removeLastObject()
                                }
                                else if(objSelectedImpantVwController1.arrGroupBTemp.count > objSelectedImpantVwController1.arrGroupB.count)
                                {
                                    objSelectedImpantVwController1.arrGroupBTemp.removeLastObject()
                                }
                                else if(objSelectedImpantVwController1.arrGroupCTemp.count > objSelectedImpantVwController1.arrGroupC.count)
                                {
                                    objSelectedImpantVwController1.arrGroupCTemp.removeLastObject()
                                }
                            }
                            
                            if(btnPin.tag == 1)
                            {
                                objSelectedImpantVwController1.arrGroupATemp.add(dic)
                            }
                            else if (btnPin.tag == 2)
                            {
                                objSelectedImpantVwController1.arrGroupBTemp.add(dic)
                            }
                            else
                            {
                                objSelectedImpantVwController1.arrGroupCTemp.add(dic)
                            }
                            objSelectedImpantVwController1.overrideHoles.removeAllObjects()
                            objSelectedImpantVwController1.overrideHoles.add(dic)
                        }
                    }
                    
                }
                objSelectedImpantVwController1.arrSelectedScrews.add(strSection)
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
        DispatchQueue.main.async
            {
                self.objSelectedImpantVwController1.screwsCollectionVw.reloadData()
                self.objSelectedImpantVwController1.collectionViewGrpB.reloadData()
                self.objSelectedImpantVwController1.collectionViewGrpC.reloadData()
                
        }
        self.btnPin.isUserInteractionEnabled = true;
    }
}

