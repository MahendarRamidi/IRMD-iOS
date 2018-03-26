//
//  AssembleTrayScannedImgByBarcodeViewController.swift
//  FDA
//
//  Created by CYGNET on 23/10/17.
//  Copyright © 2017 Aditya. All rights reserved.
//

import UIKit

class AssembleTrayScannedImgByBarcodeViewController: UIViewController,CustomAlertDelegate
{
    func okBtnAction() {
        
    }
    
    var tray :Dictionary <String,Any>! = nil
    
    var alertView = CustomAlertViewController.init()
    var trayType : NSString = ""
    
    @IBOutlet var imageView: UIImageView!
    
    var arrScrewData : NSMutableArray = []

    override func viewDidLoad()
    {
        super.viewDidLoad()
        /*------------------------------------------------------
         Below code if for preparing alert view for presenting as alert box and setting the delegate as current class. that will be helpful in calling the action of okbutton when user taps on ok button in alert view
         ------------------------------------------------------*/
        alertView = self.storyboard?.instantiateViewController(withIdentifier: Constants.kCustomAlertViewController) as! CustomAlertViewController
        
        alertView.delegate = self
        /*------------------------------------------------------*/
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        CommanMethods.addProgrssView(aStrMessage:  Constants.kstrLoading, isActivity: true)
        
        let dicionaryforGetPreSurgeryImage = [Constants.kstrtrayID:tray[Constants.kstrid]!]
        
        /*------------------------------------------------------
         The below api getassemblyimagebyassemblyid will provide the assembly image based on the id we are passing from the previous class(AssembleTrayScanBarCodeViewController)
         ------------------------------------------------------*/
        
        CommanAPIs().getAssemblyImage(dicionaryforGetPreSurgeryImage, Constants.getassemblyimagebyassemblyid) { (response,err) in
            
            CommanMethods.removeProgrssView(isActivity: true)
            
            if let msg:String = response?[Constants.kstrmessage] as? String
            {
                if(msg == Constants.kstrFailed)
                {
                    CommanMethods.alertView(message: "No assembly image available." as NSString , viewController: self, type: 1)
                    return
                }
            }
            
            if response != nil{
                
                let dataDecoded : Data = Data(base64Encoded: response![Constants.kdata] as! String, options: .ignoreUnknownCharacters)!
                self.imageView.image = UIImage(data: dataDecoded)
                
            }
            else
            {
                CommanMethods.alertView(message: Constants.kMsgWrongResponse as NSString , viewController: self, type: 1)
//                self.showOKAlert(title :Constants.kstrError ,message: Constants.kMsgWrongResponse)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        /*------------------------------------------------------
         Based on tray type the controller will push the different controller on the stack . Condition is self explanatory
         ------------------------------------------------------*/        
        
        if trayType as String == Constants.ktray_1 || trayType as String == Constants.kTray_1
        {
            let obj  =  segue.destination as! AssembleTrayEditImplantViewController
            obj.tray = tray
            obj.trayType = trayType
            obj.arrScrewData = arrScrewData
        }
        else if trayType as String == Constants.ktray_2 || trayType as String == Constants.kTray_2
        {
            let obj  =  segue.destination as! AssembleTrayEditImplantTray2ViewController
            obj.tray = tray
            obj.trayType = trayType
            obj.arrScrewData = arrScrewData
        } 
    }

    @IBAction func btnAccept(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnAddImplant(_ sender: Any)
    {
        if trayType as String == Constants.ktray_2 || trayType as String == Constants.kTray_2
        {
            self.performSegue(withIdentifier: Constants.kstrgotoEditImplantTray2, sender: nil)        
        }
        else if trayType as String == Constants.ktray_1 || trayType as String == Constants.kTray_1
        {
            CommanMethods.addProgrssView(aStrMessage: Constants.kstrLoading, isActivity: true)
            
            self.performSegue(withIdentifier: Constants.kstrgotoEditImplant, sender: nil)
        }
        else
        {
            CommanMethods.alertView(message: "Something went wrong" , viewController: self, type: 1)
        }
    }
    @IBAction func openMenu(_ sender: Any)
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
}
