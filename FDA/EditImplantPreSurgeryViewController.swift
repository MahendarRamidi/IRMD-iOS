//
//  EditImplantPreSurgeryViewController.swift
//  FDA
//
//  Created by Cygnet Infotech on 08/11/17.
//  Copyright © 2017 Aditya. All rights reserved.
//

import UIKit

class EditImplantPreSurgeryViewController: UIViewController {
    
    var trayType : NSString = ""
    var arrTrayType : NSMutableArray = NSMutableArray.init()
    var trayNumber : Int = 0
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var btnGroup1: UIButton!
    @IBOutlet weak var btnGroup2: UIButton!
    @IBOutlet weak var btnGroup3: UIButton!
    
    var isDetectedImageIsAdded:Bool = false
    
    var isEditImplantsVisible:Bool = false
    
    var isFromSerachTray:Bool = false
    
    var decodedimage:UIImage! = nil
    
    
    var dicForImageRecognitionResponse :[String: Any] = [:]
    var dicForsaveTrays :[String: Any] = [:]
    var arrTrayBaseline :[[String: Any]] = [[:]]
    var image : UIImage? = nil
    
    var arrGroup1:[String: Any] = [:]
    var arrGroup2:[String: Any] = [:]
    var arrGroup3:[String: Any] = [:]
    var  overrideHoles:NSMutableArray! = NSMutableArray()
    
    @IBOutlet var assembledTrayLabel: UILabel!
    var value:Any! = nil
    var arrSelectedScrews = NSMutableArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        value = (dicForsaveTrays[Constants.kstrtrayId]! as! [Any])[trayNumber-1]
        
        assembledTrayLabel.text = "Assembled Tray \(value!)"
    }
    
    override func viewWillAppear(_ animated: Bool)
    {        
        imageView.image = image
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnLayerClicked(_ sender:Any)
    {
        if("\(self.trayType as AnyObject )" == Constants.ktray_1)
        {
            print(self.trayType)
        }
        else
        {
            print(self.trayType)
        }
        let btnSender = sender as! UIButton
        
        let selectedImplant = self.storyboard?.instantiateViewController(withIdentifier: Constants.kSelectImplantPreSurgeryViewController) as! SelectImplantPreSurgeryViewController
        selectedImplant.value = value
        selectedImplant.dicForImageRecognitionResponse = dicForImageRecognitionResponse
        
        if btnSender.tag == 100 {
            selectedImplant.iSelectedGroup = 0
        } else if btnSender.tag == 101 {
            selectedImplant.iSelectedGroup = 1
        } else {
            selectedImplant.iSelectedGroup = 2
        }
        
        self.navigationController?.pushViewController(selectedImplant, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == Constants.kgoToEditImplantPreSurgeryViewController)
        {
            let obj = segue.destination as! AcceptTrayStep2ViewController
            obj.arrSelectedScrews = arrSelectedScrews
            
            if(overrideHoles.count > 0)
            {
                obj.overrideHoles = overrideHoles!
            }
            obj.image = decodedimage
            obj.dicForsaveTrays = dicForsaveTrays
            obj.isDetectedImageIsAdded = isDetectedImageIsAdded
            obj.isEditImplantsVisible = isEditImplantsVisible
            obj.dicForImageRecognitionResponse = dicForImageRecognitionResponse
        }
        
        if(segue.identifier == Constants.kbackToAcceptAndFinish)
        {
            let obj = segue.destination as! ScanBarcodeAcceptFinalViewController
            obj.arrSelectedScrews = arrSelectedScrews
            if(overrideHoles.count > 0)
            {
                obj.overrideHoles = overrideHoles!
            }
            obj.decodedimage = decodedimage
            obj.dicForsaveTrays = dicForsaveTrays
            obj.isDetectedImageIsAdded = isDetectedImageIsAdded
            obj.isEditImplantsVisible = isEditImplantsVisible
            obj.dicForImageRecognitionResponse = dicForImageRecognitionResponse
        }
    }

    @IBAction func btnAccept(_ sender: UIButton)
    {
        if(imageView.image != nil)
        {
            var json :Any! = nil
            var json1 :Any! = nil
            var json2 :Any! = nil
            
            do {
                if let file = Bundle.main.url(forResource: Constants.kexample, withExtension: Constants.kjson) {
                    let data = try Data(contentsOf: file)
                    
                    let jsonData = try JSONSerialization.data(withJSONObject: arrTrayBaseline, options: JSONSerialization.WritingOptions.prettyPrinted)
                    
                    let jsonData1 = try JSONSerialization.data(withJSONObject: overrideHoles, options: JSONSerialization.WritingOptions.prettyPrinted)
                    
                    json = try JSONSerialization.jsonObject(with: data, options: [])
                    
                    json1 = try JSONSerialization.jsonObject(with: jsonData, options: [])
                    
                    json2 = try JSONSerialization.jsonObject(with: jsonData1, options: [])
                    
                    
                    if let object = json as? [String: Any] {
                        // json is a dictionary
                        print(object)
                        print(jsonData)
                        
                        let objectData = try? JSONSerialization.data(withJSONObject: overrideHoles, options: JSONSerialization.WritingOptions(rawValue: 0))
                        let objectString = String(data: objectData!, encoding: .utf8)
                        print(objectString)
                        
                        
                    } else if let object = json as? [Any] {
                        // json is an array
                        print(object)
                        print(json1)
                        
                        let objectData = try? JSONSerialization.data(withJSONObject: overrideHoles, options: JSONSerialization.WritingOptions(rawValue: 0))
                        let objectString = String(data: objectData!, encoding: .utf8)
                        print(objectString)
                        
                        
                    } else {
                        print(Constants.kAlert_JSON_is_invalid)
                    }
                } else {
                    print("no file")
                }
            } catch {
                print(error.localizedDescription)
            }
            
            
            let dataDecoded : Data = Data(base64Encoded: self.dicForImageRecognitionResponse[Constants.kPreImage] as! String, options: .ignoreUnknownCharacters)!
            
            let imgdata = UIImagePNGRepresentation(UIImage(data: dataDecoded)!)
            let strBase64:String = imgdata!.base64EncodedString(options: .init(rawValue: 0))
            
            
            let dic = [Constants.kpicture:strBase64,Constants.ktrayBaseline:json1,Constants.koverrideHoles :json2] as [String : Any]
            
            CommanMethods.addProgrssView(aStrMessage: Constants.kstrLoading, isActivity: true)
            updateTrayPictureWebservice().processImage(dic, Constants.imageRecognition, { (response, err) in
                
                if let msg:Int = response?[Constants.kstrmessage] as? Int
                {
                    if(msg == 1)
                    {
                        CommanMethods.removeProgrssView(isActivity: true)
                        CommanMethods.alertView(message: Constants.kstrWrongResponse as NSString , viewController: self, type: 1)
//                        self.showOKAlert(title :Constants.kstrError ,message: Constants.kstrWrongResponse)
                        return
                    }
                }
                
                if response != nil && response![Constants.kstatusFlag] as! Int != 1{
                    
                    let preimage = self.dicForImageRecognitionResponse[Constants.kPreImage] as! String
                    self.dicForImageRecognitionResponse = response!
                    self.dicForImageRecognitionResponse[Constants.kPreImage] = preimage
                    
                    let dataDecoded : Data = Data(base64Encoded: response![Constants.kmarkedImage] as! String, options: .ignoreUnknownCharacters)!
                    self.dicForsaveTrays["\(self.trayNumber - 1)"] = response![Constants.kmarkedImage] as! String
                    
                    self.decodedimage = UIImage(data: dataDecoded)
                    
                    CommanMethods.removeProgrssView(isActivity: true)
                    
                    let alertController = UIAlertController(title: Constants.kProjectName, message: Constants.kAlert_Image_updated, preferredStyle: .alert)
                    
                    let btnOk = UIAlertAction(title: Constants.kOk, style: .default, handler:
                    {(action : UIAlertAction!) -> Void in
                        self.navigationController?.popViewController(animated: true)
                    });
                    
                    alertController.addAction(btnOk)
                    
                    self.present(alertController, animated: true, completion: nil)
                   
                }
                else{
                    CommanMethods.alertView(message: Constants.kAlert_Please_take_picture_again as NSString , viewController: self, type: 1)
//                    self.showOKAlert(title :Constants.kstrError ,message: Constants.kAlert_Please_take_picture_again)
                    
                    DispatchQueue.main.async {
                        CommanMethods.removeProgrssView(isActivity: true)
                    }
                }
            })
        }
    }
 
    /*------------------------------------------------------
     The below method is written for showing image in different controller for making it viewable to user by pushing it in different controller where user can zoom it and see the image clearly . the method is being called by the tap gesture on the image
     ------------------------------------------------------*/
    
    @IBAction func tapAction(_ sender: Any)
    {
        CommanMethods.showImage(imageView: imageView, viewController: self)
    }
    
    @IBAction func openMenu(_ sender: UIButton)
    {
      CommanMethods.openSideMenu(navigationController: navigationController!)
    }
    
    @IBAction func backToEditImplantsPreSurgery(for segue: UIStoryboardSegue)
    {
        
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
