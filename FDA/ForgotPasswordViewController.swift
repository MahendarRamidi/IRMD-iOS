//
//  ForgotPasswordViewController.swift
//  FDA
//
//  Created by Mahendar on 8/6/17.
//  Copyright © 2017 Mahendar. All rights reserved.
//
import UIKit

class ForgotPasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func returnPressed(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }

}
