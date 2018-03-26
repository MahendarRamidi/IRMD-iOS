//
//  TrayDetailViewController.swift
//  FDA
//
//  Created by Mahendar on 8/6/17.
//  Copyright © 2017 Mahendar. All rights reserved.
//

import UIKit

class TrayDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var trayNumber : Int = 0
    var totalNumberOfTrays = 0
    var trayType : NSString = ""
    var arrTrayType : NSMutableArray = NSMutableArray.init()
    @IBOutlet var lblTrayId: UILabel!
    @IBOutlet var lblSurgeryType: UILabel!
    @IBOutlet var lbltrayNumber: UILabel!
    
    @IBOutlet weak var btnGroup1: UIButton!
    @IBOutlet weak var lblPatientName: UILabel!
    @IBOutlet var lblSurgeonName: UILabel!
    
    @IBOutlet var lbldate: UILabel!
    
    @IBOutlet var lblLocation1: UILabel!
    
    @IBOutlet var lblLocation2: UILabel!
    
    @IBOutlet var lblLocation3: UILabel!
    
    @IBOutlet var lblLocation4: UILabel!
    
    @IBOutlet var lblLocation5: UILabel!
    
    @IBOutlet var tblListing: UITableView!
    
    var newAssemblyID:Any! = nil
    
    var  arrGroupA:[[String:Any]] = [[String: Any]]()
    var  arrGroupB:[[String:Any]] = [[String: Any]]()
    var  arrGroupC:[[String:Any]] = [[String: Any]]()
    var  ifScanByTrayFlow = 1
    
    @IBOutlet var segmentGroup: UISegmentedControl!
    
    var dicForsaveTrays :[String: Any] = [:]
    
    var arrTrayBaseline :[[String: Any]]! = [[String: Any]]()
    
    @IBOutlet var imageView: UIImageView!
    var image : UIImage? = nil
    
    @IBOutlet weak var gotoTrayButton : UIButton!
    @IBOutlet weak var finishButton : UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //gotoTrayButton.setTitle("See Tray \(trayNumber + 1)", for: .normal)
        gotoTrayButton.setTitle("See next tray",for: .normal)
        
        let arrtray = dicForsaveTrays[Constants.ktrayData] as! [[String:Any]]
        let trayData = arrtray[trayNumber - 1]
        let tray = trayData[Constants.ktrayData] as! [String:Any]
        
//        let dic = (tray[Constants.kstrPreAssembly] as! NSArray).firstObject as! NSDictionary
//        let diccaseDetails = dic[Constants.kstrcaseDetails] as! NSDictionary
        
        if let dic1 = tray[Constants.kpatient] as? NSDictionary
        {
            lblPatientName.text = "\(dic1[Constants.kname]!)"
        }
        else
        {
            let dic = (tray[Constants.kstrPreAssembly] as! NSArray).firstObject as! NSDictionary
            let diccaseDetails = dic[Constants.kstrcaseDetails] as! NSDictionary
            let dic2 = diccaseDetails[Constants.kpatient] as! NSDictionary
            lblPatientName.text = "\(dic2[Constants.kname]!)"
        }
        
        lblTrayId.text = " Tray Assembly " + "\((dicForsaveTrays[Constants.kstrtrayId]! as! [Any])[trayNumber-1])"
        
        tblListing.tableFooterView = UIView()
        if let dic1 = tray[Constants.kpatient] as? NSDictionary
        {
            lblSurgeonName.text = tray[Constants.ksurgeonName] as? String
        }
        else
        {
            let dic = (tray[Constants.kstrPreAssembly] as! NSArray).firstObject as! NSDictionary
            let diccaseDetails = dic[Constants.kstrcaseDetails] as! NSDictionary
            lblSurgeonName.text = "\(diccaseDetails[Constants.ksurgeonName]!)"
        }
       
        //lbldate.text = diccaseDetails["caseDate"] as? String
        
        var arrr = NSMutableArray.init()
        
        if let surgeryType = tray[Constants.ksurgeryType] as? [String:Any]
        {
            lblSurgeryType.text = surgeryType[Constants.ksurgeryType] as? String
        }
        else
        {
            let dic = (tray[Constants.kstrPreAssembly] as! NSArray).firstObject as! NSDictionary
            let diccaseDetails = dic[Constants.kstrcaseDetails] as! NSDictionary
            let surgeryType = diccaseDetails[Constants.ksurgeryType]! as? [String:Any]
            lblSurgeryType.text = "\(String(describing: surgeryType!["surgeryType"]!))"
            print("\(String(describing: surgeryType!["surgeryType"]!))")
        }
        if ((tray["caseDate"]) != nil)
        {
            if (tray["caseDate"]! as! String).count > 0
            {
                let str = (tray[Constants.kstrcaseDate]! as? String)
                let df = DateFormatter()
                //df.dateFormat = "MM-dd-yyyy"
                df.dateFormat = "yyyy-MM-dd hh:mm:ss"
                let date = df.date(from: str as! String)
                
                df.dateFormat = "MM-dd-yyyy"
                lbldate.text = df.string(from: date!)
            }
        }
        else
        {
            let dic = (tray[Constants.kstrPreAssembly] as! NSArray).firstObject as! NSDictionary
            let diccaseDetails = dic[Constants.kstrcaseDetails] as! NSDictionary
            let df = DateFormatter()
            //df.dateFormat = "MM-dd-yyyy"
            df.dateFormat = "yyyy-MM-dd hh:mm:ss"
            let date = df.date(from: "\(diccaseDetails[Constants.kstrcaseDate]!)" )
            lbldate.text = df.string(from: date!)
            
            df.dateFormat = "MM-dd-yyyy"
            lbldate.text = df.string(from: date!)
        }
        
        if trayNumber == totalNumberOfTrays
        {
            /*------------------------------------------------------
             Updated on : 18- Dec-2017
             The below button will not required any more. Because we need to hine the scan bar code button as per requirement. So for that the finish button will stay hidden and the other butotn will change the title as "Finish at the end of the tray flow after see next tray and perform the same action as finish buttonm and navigate user to LandingViewController"
             ------------------------------------------------------*/
            //finishButton.isHidden = false
            
            /*------------------------------------------------------
             Updated on : 12-Dec-2017
             Updation reason : as the requirement has changed and from current screen user needs to pop to scanbarcodehomeVC thats why the button title will get changed
             ifScanByTrayFlow is for identifying the flow that if the flow is of scanby tray or surgery flow. ifScanByTrayFlow value will be set to zero in button action goToButtonClick to set that the flow is not scanByTray but of surgery flow
             
             Updated on : 18-Dec-2017, as the button is not needed in surgery flow so the button hidden code will move to below condition and will provide two option to user ie. finish and search for another tray
             ------------------------------------------------------*/
            if(ifScanByTrayFlow == 1)
            {
                finishButton.isHidden = false
                gotoTrayButton.setTitle("Search for another tray", for: .normal)
            }
            else
            {
                gotoTrayButton.setTitle("Finish", for: .normal)
            }
        }
        
        let dicionaryForTray = [Constants.kstrtrayID:(dicForsaveTrays[Constants.knewAssemblyID]! as! [Any])[trayNumber-1]] as Dictionary<String,Any>
                
        /*------------------------------------------------------
         Differentiate the tray type with tray-1 or tray-2
         ------------------------------------------------------*/
        if(arrTrayType.object(at: trayNumber-1) as! NSString == "tray 1")
        {
            segmentGroup.isHidden = false;
            btnGroup1.isHidden = true
        }
        else
        {
            segmentGroup.isHidden = true;
            btnGroup1.isHidden = false
        }
        
        /*------------------------------------------------------
         Call the getscrewsdetailsbyremovestatusbyassemblyidapi for getting the details for removed screws
         ------------------------------------------------------*/
        CommanMethods.addProgrssView(aStrMessage: Constants.kstrLoading, isActivity: true)
        
        /*------------------------------------------------------
         api calling for the tray listing
         ------------------------------------------------------*/
        
        CommanAPIs().getScrewListing(dicionaryForTray, Constants.getscrewsdetailsbyremovestatusbyassemblyid,{(response,err) in
            
            CommanMethods.removeProgrssView(isActivity: true)
            
            /*------------------------------------------------------
            If response not nil then set the data of response in form of screw id, trayGroup, screw status, holenumber in arrTrayBaseline that will be used to populate the table view cell for removed status screws
             ------------------------------------------------------*/
            
            if response != nil
            {
                for i in (0..<response!.count)
                {
                    let tray = response![i]
                    let dic = NSMutableDictionary()
                    dic.setValue("\(tray[Constants.kstrholeNumber]!)", forKey: Constants.kHOLE_NUMBER)
                    dic.setValue("\(tray["id"]!)", forKey: Constants.kSCREW_ID)
                    dic.setValue("\(tray[Constants.ktrayGroup]!)", forKey: Constants.kTRAY_GROUP)
                    dic.setValue("\(tray[Constants.kscrewStatus]!)", forKey: Constants.kSCREW_STATUS)
                  
                    if(self.arrTrayBaseline != nil)
                    {
                        self.arrTrayBaseline.append(dic as! [String : Any])
                    }
                    else
                    {
                        self.arrTrayBaseline = [dic as! Dictionary<String, Any>]
                    }
                }
                
                self.actionSegmentChange(self.segmentGroup)
                self.tblListing.reloadData()
            }
            else
            {
                CommanMethods.alertView(message: Constants.kstrWrongResponse as NSString , viewController: self, type: 1)
//                self.showOKAlert(title :Constants.kstrError ,message: Constants.kstrWrongResponse)
            }
        })
    }

    override func viewDidAppear(_ animated: Bool)
    {
        let dataDecoded : Data = Data(base64Encoded: dicForsaveTrays["\(trayNumber - 1)"] as! String, options: .ignoreUnknownCharacters)!
        imageView.image = UIImage(data: dataDecoded)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*------------------------------------------------------
     According to selected tray group the corresponding array will get populate as no. of rows in the table view
     ------------------------------------------------------*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch segmentGroup.selectedSegmentIndex {
        case 0:
            return arrGroupA.count
            
        case 1:
            return arrGroupB.count
            
        case 2:
            return arrGroupC.count
            
        default:
            return arrTrayBaseline.count
        }
    }
    
    /*------------------------------------------------------
     According to selected tray group the corresponding array will populate the data in the table view for screw number and id
     ------------------------------------------------------*/
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellidentifier = "cell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellidentifier) as! tblTrayDetailCell
        
        var dic:NSDictionary! = nil
        
        
        switch segmentGroup.selectedSegmentIndex
        {
            case 0:
                
                dic = arrGroupA[indexPath.row] as NSDictionary
            
            case 1:

                dic = arrGroupB[indexPath.row] as NSDictionary
            
            case 2:
                
                dic = arrGroupC[indexPath.row] as NSDictionary
            
            default:
                dic = arrGroupC[indexPath.row] as NSDictionary
        }

        cell.lblScrewLocation.text = "Location " +  (dic[Constants.kHOLE_NUMBER]! as! String)
        cell.lblScrewId.text = "Implant ID " + (dic[Constants.kSCREW_ID]! as! String)
        cell.lblScrewId.font = UIFont.systemFont(ofSize: cell.lblScrewId.getFontForDevice())
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return tableView.getHeightForDevice()
        return 90
    }
        
    /*------------------------------------------------------
     The gotoButton will compare the number of tray with total number of tray to get the current status of the tray if the last or not and according to that the screen will navigate further
     ------------------------------------------------------*/
    @IBAction func gotoButtonClicked (sender : UIButton)
    {
        /*------------------------------------------------------
         Navigate to TrayDetailViewController
         ------------------------------------------------------*/
        if trayNumber < totalNumberOfTrays
        {
            let nextTrayVC = self.storyboard?.instantiateViewController(withIdentifier: "TrayDetailViewController") as! TrayDetailViewController
            nextTrayVC.totalNumberOfTrays = self.totalNumberOfTrays
            nextTrayVC.trayNumber = self.trayNumber + 1
            nextTrayVC.arrTrayType = arrTrayType    
            nextTrayVC.dicForsaveTrays = dicForsaveTrays
            /*------------------------------------------------------
             Set that the current flow is not search by tray flow but it is surgery flow
             ------------------------------------------------------*/
            nextTrayVC.ifScanByTrayFlow = 0
            self.navigationController?.pushViewController(nextTrayVC, animated: true)
        }
        /*------------------------------------------------------
         Navigate to ScanBarcodeViewController(currently FALSE)
             Updated on : 15-Dec-2017
             Updation reason : According to requirement the user needs to pop to search by tray screen is ScanBarcodeHomeViewController
         ------------------------------------------------------*/
        else
        {
            var popToVC : UIViewController?
            for vc in (self.navigationController?.viewControllers)!
            {
                if vc is ScanBarcodeHomeViewController
                {
                    popToVC = vc
                    var popToVC1 : ScanBarcodeHomeViewController?
                    popToVC1 = vc as? ScanBarcodeHomeViewController
                    popToVC1?.isForAddTray = false
                }
            }
            if let vc = popToVC
            {
                self.navigationController?.popToViewController(vc, animated: true)
            }
            else
            {
                /*-----------  -------------------------------------------
                 Updated on : 18- Dec-2017
                 The below code is modified to navigate user to landingVC instead of scan bar code VC as the button title has changed from scan bar code to finish and that will be performing the same action as finish button.
                 ------------------------------------------------------*/
                var popToVC : UIViewController?
                for vc in (self.navigationController?.viewControllers)!
                {
                    if vc is LandingViewController
                    {
                        popToVC = vc
                    }
                }
                if let vc = popToVC
                {
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            }
        }
    }
    
    /*------------------------------------------------------
     When user clicks on finish button then the user will navigate to landingViewController by unwinding the segue
     ------------------------------------------------------*/
    @IBAction func finishPressed (sender : UIButton)
    {
        var popToVC : UIViewController?
        for vc in (self.navigationController?.viewControllers)!
        {
            if vc is LandingViewController
            {
                popToVC = vc                
            }
        }
        if let vc = popToVC
        {
            self.navigationController?.popToViewController(vc, animated: true)
        }
    }
    
    @IBAction func openMenu(_ sender: UIButton)
    {
       CommanMethods.openSideMenu(navigationController: navigationController!)
    }
    
    /*------------------------------------------------------
     The below method is written for showing image in different controller for making it viewable to user by pushing it in different controller where user can zoom it and see the image clearly . the method is being called by the tap gesture on the image
     ------------------------------------------------------*/
    
    @IBAction func tapAction(_ sender: Any)
    {
        CommanMethods.showImage(imageView: imageView, viewController: self)
    }
    
    /*------------------------------------------------------
     the below method will separate the screws depending on the tray group and will be populating the table view according to that
     ------------------------------------------------------*/
    @IBAction func actionSegmentChange(_ sender: Any)
    {
        let seg = sender as! UISegmentedControl
 
        switch seg.selectedSegmentIndex
        {
            case 0:
                
                arrGroupA = arrTrayBaseline!.filter { ("\(String(describing: $0[Constants.kTRAY_GROUP]!))" as NSString).integerValue == 1}
                arrGroupA = arrGroupA.sorted { ($0[Constants.kHOLE_NUMBER] as? String)! < ($1[Constants.kHOLE_NUMBER] as? String)! }
          
            case 1:
                
                arrGroupB = arrTrayBaseline!.filter { ("\(String(describing: $0[Constants.kTRAY_GROUP]!))" as NSString).integerValue == 2}
                arrGroupB = arrGroupB.sorted { ($0[Constants.kHOLE_NUMBER] as? String)! < ($1[Constants.kHOLE_NUMBER] as? String)! }
            
            case 2:
                
                arrGroupC = arrTrayBaseline!.filter { ("\(String(describing: $0[Constants.kTRAY_GROUP]!))" as NSString).integerValue == 3}
                arrGroupC = arrGroupC.sorted { ($0[Constants.kHOLE_NUMBER] as? String)! < ($1[Constants.kHOLE_NUMBER] as? String)! }
            
            default:
                
                print("test")
        }
        
        tblListing.reloadData()
    }
}


class tblTrayDetailCell: UITableViewCell
{
    @IBOutlet var lblScrewId: UILabel!
    
    @IBOutlet var lblScrewLocation: UILabel!
    
}


