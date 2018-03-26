//
//  AcceptTrayStep2PreSurgeryViewController.swift
//  FDA
//
//  Created by Cygnet Infotech on 08/11/17.
//  Copyright © 2017 Aditya. All rights reserved.
//

import UIKit

class AcceptTrayStep2PreSurgeryViewController: UIViewController {

    var image : UIImage? = nil
    var trayType : NSString = ""
    var arrTrayType : NSMutableArray = NSMutableArray.init()
    var dicForsaveTrays :[String: Any] = [:]
    var trayNumber : Int = 0
    var totalNumberOfTrays = 0
    var arrTrayBaseline :[[String: Any]] = [[:]]
    var dicForImageRecognitionResponse :[String: Any] = [:]
    @IBOutlet var btnEditImplants: UIButton!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var gotoTrayButton : UIButton!
    var trayArr:[[String: Any]] = [[:]]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        imageView.image = image
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "trayDetail"
        {
            let destVC = segue.destination as! TrayDetailViewController
            destVC.trayNumber = 1
            destVC.totalNumberOfTrays = totalNumberOfTrays
            destVC.trayType = trayType
            destVC.arrTrayType = arrTrayType  
            destVC.dicForsaveTrays = dicForsaveTrays
            //destVC.image = image
//            destVC.newAssemblyID = newAssemblyID
        }
        else if segue.identifier == Constants.kgoToEditImplantPreSurgeryViewController
        {
            let destVC = segue.destination as! EditImplantPreSurgeryViewController
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
     The below method is written for showing image in different controller for making it viewable to user by pushing it in different controller where user can zoom it and see the image clearly . the method is being called by the tap gesture on the image
     ------------------------------------------------------*/    
    @IBAction func tapAction(_ sender: Any)
    {        
        CommanMethods.showImage(imageView: imageView, viewController: self)
    }
    
    @IBAction func btnEditImplant(_ sender: Any)
    {
        performSegue(withIdentifier: Constants.kgoToEditImplantPreSurgeryViewController, sender: nil)
    }
    @IBAction func btnScceptAndGoToNextTray(_ sender: Any)
    {
    }
}
