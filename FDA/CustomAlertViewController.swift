//
//  CustomAlertViewController.swift
//  FDA
//
//  Created by Cygnet Infotech on 01/12/17.
//  Copyright © 2017 Aditya. All rights reserved.
//

import UIKit

protocol CustomAlertDelegate
{
    func okBtnAction()->Void
}
class CustomAlertViewController: UIViewController {

    @IBOutlet weak var vwAlertBasic: UIView!
    @IBOutlet weak var vwEnterTrayID: UIView!
    @IBOutlet weak var txtTraiID: UITextField!
    @IBOutlet weak var lblMessage: UILabel!
    var delegate: CustomAlertDelegate?
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        /*------------------------------------------------------
         The below code is added to provide both the alert view transition style.
         ------------------------------------------------------*/
        self.vwAlertBasic.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        self.vwEnterTrayID.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.transition(with: self.view, duration: 0.1, options: .showHideTransitionViews , animations: { _ in
            self.vwAlertBasic.transform = CGAffineTransform.identity
            self.vwEnterTrayID.transform = CGAffineTransform.identity
        }, completion: { (finish) in
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestData(completion: ((_ data: String) -> Void))
    {
        // the data was received and parsed to String
        let data = "Data from wherever"
        completion(data)
    }
    
    /*------------------------------------------------------
     #Mark : basic alert view
     ------------------------------------------------------*/
    /*------------------------------------------------------
     Below method will be called when user clicks on the ok button in alert view and the currently VC that is added as subview will be removed from super view
     ------------------------------------------------------*/
    @IBAction func btnOk(_ sender: Any)
    {
        
        self.view.willMove(toSuperview: nil)
        self.view.removeFromSuperview()
        self.delegate?.okBtnAction()
    }
    
    /*------------------------------------------------------
     Below method will be called when user clicks on the cancel button in alert view and the currently VC that is added as subview will be removed from super view
     ------------------------------------------------------*/
    @IBAction func btnCancel(_ sender: Any)
    {
        self.view.willMove(toSuperview: nil)
        self.view.removeFromSuperview()
    }
    
    /*------------------------------------------------------
     #Mark : Alert view with a textbox resides inside
     ------------------------------------------------------*/
    /*------------------------------------------------------
     Below method will be called when user clicks on the save button in alert view and the currently VC that is added as subview will be removed from super view
     ------------------------------------------------------*/
    @IBAction func btnSaveTrayID(_ sender: Any)
    {
        let parent = self.parent as! ScanBarcodeHomeViewController
        parent.getTrayValueFromAlert(trayID: txtTraiID.text as! NSString)
        self.view.willMove(toSuperview: nil)
        self.view.removeFromSuperview()
    }
    
    /*------------------------------------------------------
     Below method will be called when user clicks on the cancel button in alert view and the currently VC that is added as subview will be removed from super view
     ------------------------------------------------------*/
    @IBAction func btnDontSaveTrayID(_ sender: Any)
    {
        self.view.willMove(toSuperview: nil)
        self.view.removeFromSuperview()
    }
}
