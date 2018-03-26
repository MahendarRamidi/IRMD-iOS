//
//  CommanMethods.swift
//  FDA
//
//  Created by on 10/08/17.
//  Copyright © 2017 Aditya. All rights reserved.
//

import UIKit
import CoreData

class CommanMethods: UIViewController,UINavigationControllerDelegate{    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    static func convertStringToDictionary (text:String) -> [[String: Any]] {
        
        let data :NSData = text.data(using: String.Encoding.utf8)! as NSData
       
        do {
            let json = try JSONSerialization.jsonObject(with: data as Data) as! [[String: Any]]
            return json
            
        } catch let err {
            print(err)
        }
        
        return [[:]]
    }

    
    static func fetchData(trayId:String,dicForsaveTrays : [String:Any],imageView:UIImageView) -> TrayAssembly? {
        
        let fetchreq = NSFetchRequest<NSFetchRequestResult>.init(entityName: "TrayAssembly")
        
        fetchreq.predicate = NSPredicate.init(format: "trayId == %@", argumentArray: [dicForsaveTrays[Constants.kstrtrayId]!])
        var tray : TrayAssembly! = nil
        if #available(iOS 10.0, *) {
            do {
                
                let arrTrayAssembly = try Constants.appDelegate.persistentContainer.viewContext.fetch(fetchreq) as! [TrayAssembly]
                
                if(arrTrayAssembly.count > 0)
                {
                    tray = arrTrayAssembly.first
                    imageView.image = UIImage(data: tray!.image! as Data)
                }
            }
            catch let error {
                print(error)
            }
        }
        else {
            // Fallback on earlier versions
        }
        
        return tray
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   static func nsStringIsValidEmail(_ checkString: String) -> Bool {
        //let stricterFilter: Bool = false
        let stricterFilterString: String = "^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$"
        //let laxString: String = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        //let emailRegex: String = laxString
        let emailTest = NSPredicate(format: "SELF MATCHES %@", stricterFilterString)
        return emailTest.evaluate(with: checkString)
    }
    
    //MARK: Show Progress View
   static func addProgrssView(aStrMessage:String?,isActivity:Bool)
    {
        if(isActivity == true)
        {
            var config : SwiftLoader.Config = SwiftLoader.Config()
            config.size = 120
            config.backgroundColor = UIColor(red: 59.0/255.0, green: 175.0/255.0, blue: 218.0/255.0, alpha: 0.5)
            config.spinnerColor = UIColor.white
            config.titleTextColor = UIColor.white
            config.spinnerLineWidth = 2.0
            config.foregroundColor = UIColor.black
            config.foregroundAlpha = 0.5
            SwiftLoader.setConfig(config: config)
            SwiftLoader.show(title: aStrMessage!, animated: true)
            
        }
        else
        {
            SwiftLoader.show(animated: true)
        }
    }
   
    static func removeProgrssView(isActivity:Bool)
    {
        if(isActivity == true)
        {
            SwiftLoader.hide()
        }
        else
        {
        }
    }

    /*------------------------------------------------------
     The below method will be called from every where we need to display the alert box.
     The controller CustomALertViewController consists of two views inside so as the controller is common the alert view need to distinguish by the value if "type" in method parameter following is the definition of the "type" field
     1. if type = 1, display basic alert
     2. else if type = 2, display alert with textbox inside
     ------------------------------------------------------*/
    static func alertView(message : NSString, viewController : UIViewController, type : Int) -> Void
    {
        let alertView =  viewController.storyboard?.instantiateViewController(withIdentifier: Constants.kCustomAlertViewController) as! CustomAlertViewController
        
        viewController.addChildViewController(alertView)
        alertView.view.bounds = viewController.view.bounds
        
        viewController.view.addSubview(alertView.view)
                
        alertView.didMove(toParentViewController: viewController)
        
        if(type == 1)
        {
            alertView.vwAlertBasic.isHidden = false
            alertView.vwEnterTrayID.isHidden = true
        }
        else
        {
            alertView.vwAlertBasic.isHidden = true
            alertView.vwEnterTrayID.isHidden = false
        }
        alertView.lblMessage.text = message as String
    }
    
    /*------------------------------------------------------
     The Below method is required if any action is to be taken on the click of ok or cancel button. The alert view instance will get created in the caller class with delegate self and that instance will be sent here so to call the delegate method of ok button in respective caller class
     1. if type = 1, display basic alert
     2. else if type = 2, display alert with textbox inside
     ------------------------------------------------------*/
    static func alertView(alertView : CustomAlertViewController, message : NSString, viewController : UIViewController, type : Int) -> Void
    {        
        viewController.addChildViewController(alertView)
        alertView.view.bounds = viewController.view.bounds
        
        viewController.view.addSubview(alertView.view)
        
        alertView.didMove(toParentViewController: viewController)
        
        if(type == 1)
        {
            alertView.vwAlertBasic.isHidden = false
            alertView.vwEnterTrayID.isHidden = true
        }
        else
        {
            alertView.vwAlertBasic.isHidden = true
            alertView.vwEnterTrayID.isHidden = false
        }
        alertView.lblMessage.text = message as String
    }
    
    /*------------------------------------------------------
     The Below method is required if any action is to be taken on the click of ok or cancel button. The alert view instance will get created in the caller class with delegate self and that instance will be sent here so to call the delegate method of ok button in respective caller class
     1. if type = 1, display basic alert
     2. else if type = 2, display alert with textbox inside
     ------------------------------------------------------*/
    static func alertViewForPostSurgery(alertView : CustomAlertViewController, message : NSAttributedString , viewController : UIViewController, type : Int) -> Void
    {
        viewController.addChildViewController(alertView)
        alertView.view.bounds = viewController.view.bounds
        
        viewController.view.addSubview(alertView.view)
        
        alertView.didMove(toParentViewController: viewController)
        
        if(type == 1)
        {
            alertView.vwAlertBasic.isHidden = false
            alertView.vwEnterTrayID.isHidden = true
        }
        else
        {
            alertView.vwAlertBasic.isHidden = true
            alertView.vwEnterTrayID.isHidden = false
        }
        alertView.lblMessage.attributedText = message
    }
    /*------------------------------------------------------
     The below method will be called from below classes
     -> AddTrayController
     -> GoToTrayVC
     -> AccepttrayStep1VC
     -> AcceptTrayStep2VC
     -> TrayDetailVC
     -> ScanBarCodeAcceptFinalVC
     -> ScanBarCodePreSurgeryVC
     -> SelectImplantPreSurgeryVC(Tray-1 and Tray-2)
     -> AssemblerTrayScannedImgVC
     -> AssembleTrayCloneImgPreview
     these classex will be passing the image view and the self controller to the below function. These parameters will be used to send the data in imageViewer class
     ------------------------------------------------------*/
    static func showImage(imageView : UIImageView, viewController : UIViewController)
    {
        if imageView.image != nil
        {
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "imageViewer") as! imageViewer
            vc.image1 = imageView.image!
            viewController.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    /*------------------------------------------------------
     The below method is used to open the side menu from every controller class we are using in FDA, so below method will be called from those classes where we need to open the side menu by passing the navigation controller
     ------------------------------------------------------*/
    static func openSideMenu(navigationController : UINavigationController)
    {
        let drawer = navigationController.parent
        if let drawer = drawer as? KYDrawerController{
            drawer.setDrawerState(.opened, animated: true)
        }
    }
}
