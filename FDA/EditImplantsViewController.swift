//
//  EditImplantsViewController.swift
//  FDA
//
//  Created by Mahendar on 8/6/17.
//  Copyright © 2017 Mahendar. All rights reserved.
//

import UIKit

class EditImplantsViewController: UIViewController {
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
        
        /*------------------------------------------------------
         The current tray number will be append to assemble tray after extracting from dicForsaveTrays
         ------------------------------------------------------*/

        value = (dicForsaveTrays[Constants.kstrtrayId]! as! [Any])[trayNumber-1]
        
        assembledTrayLabel.text = "Assembled Tray \(value!)"
    }

    override func viewWillAppear(_ animated: Bool)
    {
          imageView.image = image
        
//        let btn = UIButton(type: .custom)
//        btn.frame = CGRect.init(x: 0, y: 0, width: 100, height: 100)
//        btn.setTitle("", for: .normal)
//        btn.layer.borderColor = UIColor.red.cgColor
//        btn.layer.borderWidth = 0.5
//        btn.addTarget(self, action: #selector(self.btnLayerClicked(_:)), for: .touchUpInside)
//        imageView.addSubview(btn)
//        imageView.isUserInteractionEnabled = true
        
    }
    
    @IBAction func btnLayerClicked(_ sender:Any)
    {
        if(arrTrayType.object(at: trayNumber-1) as! NSString == "tray 1")
        {
            let btnSender = sender as! UIButton
            
            let selectedImplant = self.storyboard?.instantiateViewController(withIdentifier: Constants.kSelectedImplantViewController) as! SelectedImplantViewController
            
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
        else
        {
            let selectedImplant = self.storyboard?.instantiateViewController(withIdentifier: Constants.kSelectImplantTray2ViewController) as! SelectImplantTray2ViewController
            
            selectedImplant.dicForImageRecognitionResponse = dicForImageRecognitionResponse
            
            selectedImplant.value = value
            
            self.navigationController?.pushViewController(selectedImplant, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*------------------------------------------------------
     MARK: - Navigation
     In a storyboard-based application, you will often want to do a little preparation before navigation
     ------------------------------------------------------*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        /*------------------------------------------------------
         Get the new view controller using segue.destinationViewController.
         Pass the selected object to the new view controller.
         ------------------------------------------------------*/
        if(segue.identifier == "backToAcceptTray")
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

    @IBAction func backToEditImplants(for segue: UIStoryboardSegue)
    {
        
    }
    
    /*------------------------------------------------------
     The below method will get called from the button click accept
     ------------------------------------------------------*/
    @IBAction func savePressed(sender : UIButton)
    {
        /*------------------------------------------------------
         If image is not nil then convert arrTrayBaseline to jsonData using JSONSerialization for image recognition api
         ------------------------------------------------------*/
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
                    
                    
                    if let object = json as? [String: Any]
                    {
                        /*------------------------------------------------------
                         json is a dictionary
                         ------------------------------------------------------*/
                        print(object)
                        print(jsonData)
                        
                        let objectData = try? JSONSerialization.data(withJSONObject: overrideHoles, options: JSONSerialization.WritingOptions(rawValue: 0))
                        let objectString = String(data: objectData!, encoding: .utf8)
                        print(objectString)
                        
                        
                    } else if let object = json as? [Any]
                    {
                        /*------------------------------------------------------
                         json is an array
                         ------------------------------------------------------*/
                        print(object)
                        print(json1)
                        
                        let objectData = try? JSONSerialization.data(withJSONObject: overrideHoles, options: JSONSerialization.WritingOptions(rawValue: 0))
                        let objectString = String(data: objectData!, encoding: .utf8)
                        print(objectString)
                        
                        
                    }
                    else
                    {
                        print(Constants.kAlert_JSON_is_invalid)
                    }
                }
                else
                {
                    print("no file")
                }
            }
            catch
            {
                print(error.localizedDescription)
            }
            
            let dataDecoded : Data = Data(base64Encoded: self.dicForImageRecognitionResponse[Constants.kPreImage] as! String, options: .ignoreUnknownCharacters)!
            
            let imgdata = UIImagePNGRepresentation(UIImage(data: dataDecoded)!)
            let strBase64:String = imgdata!.base64EncodedString(options: .init(rawValue: 0))
            
            let dic = [Constants.kpicture:strBase64,Constants.ktrayBaseline:json1, Constants.koverrideHoles :json2] as [String : Any]
            
            /*------------------------------------------------------
             Api call imageRecognition by passing the data of screw details in json data format
             ------------------------------------------------------*/
            
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
                
                if response != nil && response![Constants.kstatusFlag] as! Int == 0
                {
                    let preimage = self.dicForImageRecognitionResponse[Constants.kPreImage] as! String
                    self.dicForImageRecognitionResponse = response!
                    self.dicForImageRecognitionResponse[Constants.kPreImage] = preimage
                    
                    let dataDecoded : Data = Data(base64Encoded: response![Constants.kmarkedImage] as! String, options: .ignoreUnknownCharacters)!
                    self.dicForsaveTrays["\(self.trayNumber - 1)"] = response![Constants.kmarkedImage] as! String
                    
                    self.decodedimage = UIImage(data: dataDecoded)
                    
                    /*------------------------------------------------------
                     call updateDetectedImagebyAssemblyId api to update the detected image using assemblyId
                     ------------------------------------------------------*/
                    DispatchQueue.main.async
                    {
                        self.updateDetectedImagebyAssemblyId(sender: sender)
                    }
                }
                else
                {
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
     The below method will get called from method savePressed
     ------------------------------------------------------*/
    func updateDetectedImagebyAssemblyId(sender : UIButton)
    {
        /*------------------------------------------------------
         If image is available the updatedetectedimagebyassemblyid will get called from assembly id
         ------------------------------------------------------*/
        if(imageView.image != nil)
        {
            let urlString =  Constants.updatedetectedimagebyassemblyid + "/\(value!)"
            
            CommanMethods.addProgrssView(aStrMessage: Constants.kstrLoading, isActivity: true)
            
            updateTrayPictureWebservice().postTrayImage([:], urlString, imageView.image!, { (response, err) in
                
                CommanMethods.removeProgrssView(isActivity: true)
                let actionsheet = UIAlertController.init(title: "", message: "", preferredStyle: UIAlertControllerStyle.alert)
                
                var okButton:UIAlertAction! = nil
                
                /*------------------------------------------------------
                 if response msg is failed then show alert for failed response
                 ------------------------------------------------------*/
                
                if let msg:String = response?[Constants.kstrmessage] as? String
                {
                    if(msg == Constants.kstrFailed)
                    {
                        CommanMethods.removeProgrssView(isActivity: true)
                        CommanMethods.alertView(message: Constants.kstrWrongResponse as NSString , viewController: self, type: 1)
//                        self.showOKAlert(title :Constants.kstrError ,message: Constants.kstrWrongResponse)
                        return
                    }
                }
                
                /*------------------------------------------------------
                 Else display image updated.
                 ------------------------------------------------------*/
                
                if response != nil
                {
                    actionsheet.message = Constants.kAlert_Image_updated
                    okButton = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                        
                        self.isDetectedImageIsAdded = true
                        self.isEditImplantsVisible = true
                        
                        if(self.isFromSerachTray == true)
                        {
                            self.performSegue(withIdentifier: Constants.kbackToAcceptAndFinish, sender: nil)
                        }
                        else
                        {
                            self.performSegue(withIdentifier: "backToAcceptTray", sender: nil)
                        }
                        
                    })
                }
                else
                {
                    actionsheet.message = "Please Try Again"
                    okButton = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                        
                        self.isDetectedImageIsAdded = false
                        self.isEditImplantsVisible = false
                        
                        if(self.isFromSerachTray == true)
                        {
                            self.performSegue(withIdentifier: Constants.kbackToAcceptAndFinish, sender: nil)
                        }
                        else
                        {
                            self.performSegue(withIdentifier: "backToAcceptTray", sender: nil)
                        }
                    })
                }
                
                actionsheet.addAction(okButton)
                
                DispatchQueue.main.async {
                    self.present(actionsheet, animated: true, completion: nil)
                }
            })
        }
        
        if(imageView.image == nil)
        {
            self.performSegue(withIdentifier: "goToStep2", sender: nil)
        }
        
    }
    
    @IBAction func openMenu(_ sender: UIButton)
    {
        CommanMethods.openSideMenu(navigationController: navigationController!)
    }


}
