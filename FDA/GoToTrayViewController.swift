//
//  GoToTrayViewController.swift
//  FDA
//
//  Created by Mahendar on 8/5/17.
//  Copyright © 2017 Mahendar. All rights reserved.
//

import UIKit

class GoToTrayViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    var caseId:Any! = nil
    var trayType : NSString = ""
    var arrTrayType : NSMutableArray = NSMutableArray.init()
    @IBOutlet var imageView: UIImageView!
    var trayNumber : Int = 0
    var totalNumberOfTrays = 0
    @IBOutlet weak var gotoTrayButton : UIButton!
    @IBOutlet weak var assembledTrayLabel : UILabel!
    var dicForImageRecognitionResponse :[String: Any] = [:]
    var dicForsaveTrays :[String: Any] = [:]
    var decodedimage:UIImage! = nil
    var trayArr:[[String: Any]] = [[:]]
    var value:Any! = nil
    var tray:TrayAssembly! = nil
    
    var arrTrayBaseline :[[String: Any]]! = [[String: Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
       // tray = CommanMethods.fetchData(trayId: dicForsaveTrays["trayId"] as! String,dicForsaveTrays: dicForsaveTrays, imageView: imageView)
        
        value = (dicForsaveTrays[Constants.kstrtrayId]! as! [Int])[trayNumber-1]
        
        //gotoTrayButton.setTitle("Go to Tray \(trayNumber + 1)", for: .normal)
        gotoTrayButton.setTitle("Go to next tray", for: .normal)
        
        /*------------------------------------------------------
         If the tray number is equal to total no of trays. ie the current tray is the last tray then the button text go to next tray will be change to Finish and Go To Post Surgery
         ------------------------------------------------------*/
        
        if trayNumber == totalNumberOfTrays
        {
            gotoTrayButton.setTitle(Constants.kFinish_and_Go_To_Post_Surgery, for: .normal)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        let value = (dicForsaveTrays[Constants.kstrtrayId]! as! [Int])[trayNumber-1]

        assembledTrayLabel.text = "Assembled Tray \(value)"
        
        /*------------------------------------------------------
         api calling for the getting Pre Assembly Image
         
         Updated on 11-Dec-2017:- Shifted code on viewWillAppear because data was not updating while coming back from PreSurgeryAccepAndTakePickerVC and goin again in SelectImplantPreSurgeryVC
         ------------------------------------------------------*/
        
        CommanMethods.addProgrssView(aStrMessage: Constants.kstrLoading, isActivity: true)
        
        let dicionaryforGetPreSurgeryImage = [Constants.kstrtrayID:value]
        
        CommanAPIs().getAssemblyImage([Constants.kstrtrayID:value], Constants.getassemblyimagebyassemblyid) { (response,err) in
            
            if let msg:String = response?[Constants.kstrmessage] as? String
            {
                if(msg == Constants.kstrFailed)
                {
                    CommanMethods.alertView(message: Constants.kNo_assembly_image_available as NSString, viewController: self, type: 1)
                    //                    self.showOKAlert(title :Constants.kstrError ,message: Constants.kNo_assembly_image_available )
                    
                    /*------------------------------------------------------
                     call the assembly details api by calling below method
                     ------------------------------------------------------*/
                    self.getAssemblyDetails()
                }
            }
                
            else if response != nil
            {
                let dataDecoded : Data = Data(base64Encoded: response!["data"] as! String, options: .ignoreUnknownCharacters)!
                
                self.imageView.image = UIImage(data: dataDecoded)
                
                /*------------------------------------------------------
                 call the assembly details api by calling below method
                 ------------------------------------------------------*/
                
                self.getAssemblyDetails()
            }
            else
            {
                /*------------------------------------------------------
                 call the assembly details api by calling below method
                 ------------------------------------------------------*/
                
                self.getAssemblyDetails()
                
                CommanMethods.alertView(message: Constants.kstrWrongResponse as NSString, viewController: self, type: 1)
                
                //                self.showOKAlert(title :Constants.kstrError ,message: Constants.kstrWrongResponse)
            }
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    /*------------------------------------------------------
     This method will be called when "gotoPostSurgery" segue is called with performSegue
     ------------------------------------------------------*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == Constants.kgotoPostSurgery
        {
           let destVC = segue.destination as! AcceptTrayStep1ViewController
            destVC.trayNumber = 1
            destVC.totalNumberOfTrays = totalNumberOfTrays
            destVC.trayType = self.trayType
            destVC.arrTrayType = arrTrayType
            destVC.dicForsaveTrays = dicForsaveTrays
        }
        else if segue.identifier == Constants.kgoToAcceptTrayStep2PreSurgeryViewController
        {
            let destVC = segue.destination as! AcceptTrayStep2PreSurgeryViewController
            destVC.trayNumber = trayNumber
            destVC.arrTrayBaseline = self.arrTrayBaseline
            destVC.totalNumberOfTrays = totalNumberOfTrays
            destVC.image = self.decodedimage
            destVC.trayArr = trayArr
            destVC.trayType = trayType
            destVC.arrTrayType = arrTrayType
            destVC.dicForsaveTrays = dicForsaveTrays
            destVC.dicForImageRecognitionResponse = dicForImageRecognitionResponse
        }
        else
        {
            let destVC = segue.destination as! UpdateTrayViewController
            destVC.dicForsaveTrays = dicForsaveTrays
            destVC.trayArr = trayArr
            destVC.trayNumber = trayNumber
        }
    }
    
    /*------------------------------------------------------
     This method is for the Goto button click. that will initiate the same controller again and again with increased trayNumber by 1.
     ------------------------------------------------------*/
    
    @IBAction func gotoButtonClicked (sender : UIButton)
    {
        /*------------------------------------------------------
         If the current tray is not the last tray
         ------------------------------------------------------*/
        if trayNumber < totalNumberOfTrays
        {
            let nextTrayVC = self.storyboard?.instantiateViewController(withIdentifier: Constants.kGoToTrayViewController) as! GoToTrayViewController
            nextTrayVC.totalNumberOfTrays = self.totalNumberOfTrays
            nextTrayVC.trayNumber = self.trayNumber + 1
            nextTrayVC.trayArr = trayArr
            nextTrayVC.dicForsaveTrays = dicForsaveTrays
            nextTrayVC.arrTrayType = arrTrayType
            nextTrayVC.caseId = caseId
            self.navigationController?.pushViewController(nextTrayVC, animated: true)
        }
        /*------------------------------------------------------
         If the current tray is last tray
         ------------------------------------------------------*/
        else
        {
            self.performSegue(withIdentifier: Constants.kgotoPostSurgery, sender: nil)
        }
    }

    @IBAction func actionUpdateTray(_ sender: Any)
    {
        self.performSegue(withIdentifier: Constants.kgoToUpdateTray, sender: nil)
    }
    
    @IBAction func actionUpdateTrayToGoToTray(for segue: UIStoryboardSegue)
    {        
        //self.performSegue(withIdentifier: "goToUpdateTray", sender: nil)
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
     The below method will be called from class PreSurgeryAcceptAndTakePictureVC to unwind the segue and will be updating the dicForsaveTrays value for trayId after updating a new assembly id in controller SelectImplantPreSurgery succussful attempt
     ------------------------------------------------------*/
    
    @IBAction func unwindToGoToTray(segue:UIStoryboardSegue)
    {
        if let sourceViewController = segue.source as? PresurgeryAcceptAndTakePictureViewController
        {
            dicForsaveTrays = sourceViewController.dicForsaveTrays
            
            self.trayType = sourceViewController.trayType
            self.arrTrayType = sourceViewController.arrTrayType
            self.imageView.image = sourceViewController.imageView.image
            self.caseId = sourceViewController.caseId
            self.arrTrayBaseline = NSMutableArray.init() as! [[String : Any]]
            //self.getAssemblyDetails()
        }
        print(Constants.kSuccess)
    }
    
    /*------------------------------------------------------
     The below method will be calling the api getAssemblyDetails
     ------------------------------------------------------*/
    func getAssemblyDetails() -> Void
    {
        let value = (dicForsaveTrays[Constants.kstrtrayId]! as! [Int])[trayNumber-1]
        
        let dicionaryForGettingDetails = [Constants.kstrtrayID:value]
        
        CommanAPIs().getScrewListing(dicionaryForGettingDetails,Constants.getscrewsdetailsbyassemblyid,{(response,err) in
            
            if response != nil
            {
                for i in (0..<response!.count)
                {
                    let tray = response![i]
                    let dic = NSMutableDictionary()
                    dic.setValue("\(tray[Constants.kstrholeNumber]!)", forKey: Constants.kHOLE_NUMBER)
                    if let _ = (tray[Constants.kscrewId] as? [String:Any])
                    {
                        let str = (tray[Constants.kscrewId]! as! [String:Any])["id"]
                        dic.setValue("\(str!)", forKey: Constants.kSCREW_ID)
                    }
                    else
                    {
                        dic.setValue("", forKey: Constants.kSCREW_ID)
                    }
                    dic.setValue((tray[Constants.ktrayGroup]! as! NSString).integerValue, forKey: Constants.kTRAY_GROUP)
                    
                    dic.setValue("\(tray[Constants.kscrewStatus]!)", forKey: Constants.kSCREW_STATUS)
                    if(self.arrTrayBaseline != nil)
                    {
                        self.arrTrayBaseline.append(dic as! [String : Any])                        //
                    }
                        
                    else
                    {
                        self.arrTrayBaseline = [dic as! Dictionary<String, Any>]
                    }
                }
            }
            else
            {
                CommanMethods.alertView(message: Constants.kstrWrongResponse as NSString, viewController: self, type: 1)
//                  self.showOKAlert(title :Constants.kstrError ,message: Constants.kstrWrongResponse)
            }

            CommanMethods.removeProgrssView(isActivity: true)
        })
    }
   
    /*------------------------------------------------------
     when user taps on edit implant button below method will get called. depending on the tray type two different VC will get called for tray-1 and tray-2 the image get by api call getassemblyimagebyassemblyid will be send to corresponding class
     ------------------------------------------------------*/
    
    @IBAction func btnAccept(_ sender: Any)
    {
        let btnSender = sender as! UIButton
        
        if(arrTrayType.object(at: trayNumber-1) as! NSString == "tray 1")
        {
            print(self.trayType)
            
            let selectedImplant = self.storyboard?.instantiateViewController(withIdentifier: Constants.kSelectImplantPreSurgeryViewController) as! SelectImplantPreSurgeryViewController
            
            selectedImplant.dicForImageRecognitionResponse = dicForImageRecognitionResponse
            
            selectedImplant.fullResult = self.arrTrayBaseline
            
            selectedImplant.trayType = self.trayType
            
            selectedImplant.arrTrayType = arrTrayType
            
            selectedImplant.value = (dicForsaveTrays[Constants.kstrtrayId]! as! [Int])[trayNumber-1]
            
            selectedImplant.strBaseClass = Constants.kGoToTrayViewController

            if btnSender.tag == 100
            {
                selectedImplant.iSelectedGroup = 0
            }
            else if btnSender.tag == 101
            {
                selectedImplant.iSelectedGroup = 1
            }
            else
            {
                selectedImplant.iSelectedGroup = 2
            }
            selectedImplant.caseId = self.caseId
            
            selectedImplant.dicForsaveTrays = self.dicForsaveTrays
            
            selectedImplant.trayNumber = self.trayNumber
            
            selectedImplant.decodedimage = self.imageView.image
            
            self.navigationController?.pushViewController(selectedImplant, animated: true)

        }
        else
        {
            print(self.trayType)
            
            let selectedImplant = self.storyboard?.instantiateViewController(withIdentifier: Constants.kSelectImplantPreSurgeryTray2ViewController) as! SelectImplantPreSurgeryTray2ViewController
            
            selectedImplant.arrScrewData = NSMutableArray.init(array: self.arrTrayBaseline!)
            
            selectedImplant.strBaseClass = Constants.kGoToTrayViewController
            
            selectedImplant.caseId = self.caseId
            
            selectedImplant.arrTrayType = arrTrayType
            
            selectedImplant.value = (dicForsaveTrays[Constants.kstrtrayId]! as! [Int])[trayNumber-1]
            
            selectedImplant.trayType = self.trayType

            selectedImplant.dicForsaveTrays = self.dicForsaveTrays

            selectedImplant.trayNumber = self.trayNumber

            selectedImplant.decodedimage = self.imageView.image
            
            self.navigationController?.pushViewController(selectedImplant, animated: true)
        }
    }
}
