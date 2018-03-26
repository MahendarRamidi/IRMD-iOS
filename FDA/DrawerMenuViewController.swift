//
//  DrawerMenuViewController.swift
//  FDA
//
//  Created by Innovation Lab on 8/17/17.
//  Copyright © 2017 Aditya. All rights reserved.
//

import UIKit

class DrawerMenuViewController: UIViewController {

    @IBOutlet weak var btnSearchByTray: UIButton!
    @IBOutlet weak var imgLogoutAssemblerFlow: UIImageView!
    @IBOutlet weak var imgSearchBySurgery: UIImageView!
    @IBOutlet weak var imgSearchByTray: UIImageView!
    @IBOutlet weak var btnSearchBySurgery: UIButton!
    @IBOutlet weak var btnLoginSurgeryFlow: UIButton!
    @IBOutlet weak var imgLogoutSurgeryFlow: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        /*------------------------------------------------------
         Below condition added for the work flow assembler and the surgery flow for differentiating the side menu working depending on the roles allocated to the user
         1. if user has the role of assembler only then user will be able to access only home and logout button
         2. else user will be able to access additional search by surgey and search by tray button as well.
         ------------------------------------------------------*/
        if (UserDefaults.standard.value(forKey: "role") as! NSArray).count == 2
        {
            
        }
        else
        {
            if "\((((UserDefaults.standard.value(forKey: "role") as! NSArray).object(at: 0))as! NSDictionary).value(forKey: "id")!)" == "1"
            {
                btnSearchByTray.isHidden = true
                imgSearchBySurgery.isHidden = true
                imgSearchByTray.isHidden = true
                btnSearchBySurgery.isHidden = true
                btnLoginSurgeryFlow.isHidden = true
                imgLogoutSurgeryFlow.isHidden = true
            }
        }
    }
    
    @IBAction func btnLogOutForAssemlerFlow(_ sender: Any)
    {
        self.parent?.navigationController?.popToRootViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func homePressed(_ sender: UIButton) {
        if let parent = self.parent as? KYDrawerController{
            if let navVC = parent.mainViewController as? UINavigationController{
                navVC.popToRootViewController(animated: true)
                parent.setDrawerState(.closed, animated: true)
            }
        }

    }
    
    @IBAction func searchBySurgeryPressed(_ sender: UIButton)
    {
        if let parent = self.parent as? KYDrawerController{
            if let navVC = parent.mainViewController as? UINavigationController{
                    navVC.popToRootViewController(animated: false)
                        if let rootVC = navVC.viewControllers[0] as? ChooseWorkflowViewController{
                            rootVC.surgerySession()
                        }
                    parent.setDrawerState(.closed, animated: true)
            }
        }
    }
    
    @IBAction func searchByTrayPressed(_ sender: UIButton) {
        
        if let parent = self.parent as? KYDrawerController{
            if let navVC = parent.mainViewController as? UINavigationController{
                navVC.popToRootViewController(animated: false)
                if let rootVC = navVC.viewControllers[0] as? ChooseWorkflowViewController{
                    rootVC.scanBarCode()
                }
                parent.setDrawerState(.closed, animated: true)
            }
        }
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        self.parent?.navigationController?.popToRootViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
     */

}
