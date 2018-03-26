//
//  AssembleTrayCloneImgPreviewViewController.swift
//  FDA
//  purpose :- this class has been called from edit implant tray 2 and tray 1 VC phase 2. and will be providing the facility to user to update the assembly image here
//  Created by CYGNET on 31/10/17.
//  Copyright © 2017 Aditya. All rights reserved.
//

import UIKit

class AssembleTrayCloneImgPreviewViewController: UIViewController,CustomAlertDelegate {
    
    @IBOutlet weak var imgPreview: UIImageView!
    
    var imageData = NSData()
    var alertView = CustomAlertViewController.init()
    var trayNumber : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        imgPreview.image = UIImage.init(data: imageData as Data)
        
        /*------------------------------------------------------
         Below code if for preparing alert view for presenting as alert box and setting the delegate as current class. that will be helpful in calling the action of okbutton when user taps on ok button in alert view
         ------------------------------------------------------*/
        alertView = self.storyboard?.instantiateViewController(withIdentifier: Constants.kCustomAlertViewController) as! CustomAlertViewController
        
        alertView.delegate = self
        /*------------------------------------------------------*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        CommanMethods.showImage(imageView: imgPreview, viewController: self)
    }
   
    /*------------------------------------------------------
     The below if the action call of the button of alertView that is customis a delegate method of CustomAlertDelegate. The alertview is same but the actions are different that is being set while calling the alertView custom
     ------------------------------------------------------*/
    func okBtnAction()
    {
        self.performSegue(withIdentifier: Constants.kGoToScanImplant, sender: nil)
    }
    
    /*------------------------------------------------------
     this method will get called when user uploads the image and clicks on accept button. Api updateAssemblyImage for current trayNumber will get updated using this api. and after succussful attemp the user will navigate to scanBarVC phase - 2
     ------------------------------------------------------*/
    @IBAction func btnAccept(_ sender: Any)
    {
        if(imgPreview.image != nil)
        {
            //let imgdata = UIImagePNGRepresentation(self.imgPreview.image!)
            CommanMethods.addProgrssView(aStrMessage: Constants.kstrLoading, isActivity: true)

            let url = "\(Constants.kupdateassemblyimagebyassemblyid)/" + "\(trayNumber)"
            
            updateTrayPictureWebservice().postTrayImage([:], url, imgPreview.image!, { (response, err) in
                
                CommanMethods.removeProgrssView(isActivity: true)
                
                if let msg:String = response?[Constants.kstrmessage] as? String
                {
                    if (msg == Constants.kSuccess)
                    {
                         CommanMethods.alertView(alertView: self.alertView, message: Constants.kPicture_has_been_uploaded as NSString, viewController: self, type: 1)
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
    }
}
