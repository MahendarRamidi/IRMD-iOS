//
//  AppDelegate.swift
//  Sample
//  Purpose :- The current class is being called from class ChooseWorkdFLow VC as surgery session flow
//  Created by Mahendar on 8/5/17.
//  Copyright © 2017 Mahendar. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController
{
    var username : String!
    var callerClass : NSString = ""
    var caseId:Any! = nil
    var tray :Dictionary <String,Any>! = nil
    @IBOutlet weak var nameLabel : UILabel!
    var goToScan : Bool = false
    var isForAddTray : Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.parent?.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        /*------------------------------------------------------
         The below variable is being set true from class SurgeryViewController and ScanBarCodeAcceptFinalVC to skip the current controller to differentiate the flow
         ------------------------------------------------------*/
        if goToScan
        {
            DispatchQueue.main.async
            {
                self.performSegue(withIdentifier: "scanBarCode", sender: nil)
                self.goToScan = false
            }
        }
        if callerClass as String == Constants.kdrawerClassSurgerySession
        {
            self.searchBySurgery()
        }
        else if callerClass == "drawerClassScanBarCode"
        {
            self.searchByScan()            
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func openMenu(_ sender: UIButton)
    {
        let drawer = navigationController?.parent
        
        if let drawer = drawer as? KYDrawerController
        {
//            drawer.drawerWidth = self.view.frame.size.width * 0.5
            drawer.setDrawerState(.opened, animated: true)
        }
    }
    
    /*------------------------------------------------------
     The below method will get called when the user will click the surgery buttom adn navigate user to surgeryViewController
     ------------------------------------------------------*/
    func searchBySurgery()
    {
        self.performSegue(withIdentifier: "searchBySurgery", sender: nil)
    }
    
    func chooseViewContoller()
    {
        self.performSegue(withIdentifier: "SurgerySession", sender: nil)
    }
    
    /*------------------------------------------------------
     The below method will get called when the user will click the scan bar code buttom and navigate user to scanBarCodeHomeViewController
     ------------------------------------------------------*/    
    func searchByScan()
    {
        self.performSegue(withIdentifier: "scanBarCode", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    { 
        if(segue.identifier == "scanBarCode")
        {
            let obj =  segue.destination as! ScanBarcodeHomeViewController
            obj.isForAddTray = isForAddTray
            obj.caseId = caseId
            isForAddTray = false
        }
    }
}
