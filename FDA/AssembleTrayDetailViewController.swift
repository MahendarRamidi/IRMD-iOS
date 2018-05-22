//
//  AssembleTrayDetailViewController.swift
//  FDA
//
//  Created by CYGNET on 30/10/17.
//  Copyright © 2017 Aditya. All rights reserved.
//

import UIKit
import MobileCoreServices

class AssembleTrayDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    var trayNumber : Int = 0
    
    var trayGroup : Int = 0
    
    var arrResponseCloneTray : NSMutableArray = []
    
    let imagePicker = UIImagePickerController.init()
    
    @IBOutlet var tblListing: UITableView!
    
    var  arrGroupA : NSMutableArray = []
    var  arrGroupB : NSMutableArray = []
    var  arrGroupC : NSMutableArray = []
    
    var arrTableViewData : NSMutableArray = []
    
    @IBOutlet var segmentGroup: UISegmentedControl!
    
    var imageData = NSData()
    
    @IBOutlet weak var gotoTrayButton : UIButton!
   
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        /*------------------------------------------------------
         if trayGroup is tray-2 then the segmnet will be hidden as there is only one group
         ------------------------------------------------------*/
        
        if(trayGroup == 2)
        {
            segmentGroup.isHidden = true
        }
        
        /*------------------------------------------------------
         set segment group title and font size
         ------------------------------------------------------*/
        
        let font = UIFont.systemFont(ofSize: 30)
        segmentGroup.setTitleTextAttributes([NSFontAttributeName: font],
                                                for: .normal)
        imagePicker.delegate = self
        self.tblListing.tableFooterView = UIView.init(frame: .zero)
        self.tblListing.backgroundColor = UIColor.clear
        
        /*------------------------------------------------------
         Differentiate the arrGroup based on screw tray group
         ------------------------------------------------------*/
        
        let predicate1 = Constants.kpredicateForGroup1
        arrGroupA = ((arrResponseCloneTray as NSArray).filtered(using: predicate1) as NSArray).mutableCopy() as! NSArray as! NSMutableArray
//        arrGroupA = arrGroupA.filter { ("\(String(describing: $0[Constants.kscrewStatus]!))" as NSString) == "Present"}
//        arrGroupA = arrTrayBaseline!.filter { ("\(String(describing: $0[Constants.kTRAY_GROUP]!))" as NSString).integerValue == 1
        
        let predicate2 = Constants.kpredicateForGroup2
        arrGroupB = ((arrResponseCloneTray as NSArray).filtered(using: predicate2) as NSArray).mutableCopy() as! NSArray as! NSMutableArray
        
        let predicate3 = Constants.kpredicateForGroup3
        arrGroupC = ((arrResponseCloneTray as NSArray).filtered(using: predicate3) as NSArray).mutableCopy() as! NSArray as! NSMutableArray
        
        arrTableViewData = NSMutableArray.init(array: arrGroupA)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return arrTableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellidentifier = "ClonetblTrayDetailCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellidentifier) as! ClonetblTrayDetailCell
        
        let id = ((arrTableViewData.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "id")  as! Int)
        
        cell.lblScrewId.text =  "\(id)"
        
        cell.lblScrewStatus.text = (arrTableViewData.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: Constants.kscrewStatus) as? String
        
        cell.lblScrewLocation.text = (arrTableViewData.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: Constants.kstrholeNumber) as? String
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.getHeightForDevice()
    }
    
    @IBAction func gotoButtonClicked (sender : UIButton){
        
        let btn = sender
        
        let actionsheet = UIAlertController.init(title: "", message: Constants.kAlert_Select_Image, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let cameraButton = UIAlertAction(title: Constants.kCamera, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            
            self.imagePicker.delegate = self

            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.allowsEditing = false
                
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.imagePicker.mediaTypes = [kUTTypeImage as String]
                self.imagePicker.cameraCaptureMode = .photo
                self.imagePicker.modalPresentationStyle = .fullScreen
                
                DispatchQueue.main.async
                {
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
            }
            else 
            {
                let alertVC = UIAlertController(
                    title: Constants.kAlert_No_Camera,
                    message: Constants.kAlert_Sorry_this_device_has_no_camera,
                    preferredStyle: .alert)
                let okAction = UIAlertAction(
                    title: "OK",
                    style:.default,
                    handler: nil)
                alertVC.addAction(okAction)
                
                DispatchQueue.main.async {
                    self.present(alertVC, animated: true, completion: nil)
                }
            }
        })
        
        let gallaryButton = UIAlertAction(title: Constants.kAlert_Choose_from_Gallery, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            
            
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.imagePicker.modalPresentationStyle = .popover
            
            
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
            {
                let popOver = self.imagePicker.popoverPresentationController
                popOver?.sourceView = btn
                popOver?.sourceRect = btn.bounds
                popOver?.permittedArrowDirections = .any
                
                self.present(self.imagePicker, animated: true, completion: {
                    
                })
            }
            else
            {
                DispatchQueue.main.async {
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
            }
            
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
            
            
        })
        
        actionsheet.addAction(cameraButton)
        actionsheet.addAction(gallaryButton)
        actionsheet.addAction(cancelButton)
        
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
        {
            
            let popOver = actionsheet.popoverPresentationController
            popOver?.sourceView = btn
            popOver?.sourceRect = btn.bounds
            popOver?.permittedArrowDirections = .any
            
            DispatchQueue.main.async {
                self.present(actionsheet, animated: true, completion: nil)
            }
        }
        else
        {
            DispatchQueue.main.async {
                self.present(actionsheet, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func openMenu(_ sender: UIButton){
       CommanMethods.openSideMenu(navigationController: navigationController!)
    }
    
    /*------------------------------------------------------
     the below methdo will get called from view did load and after changing the screw tray group using segment and depending on the selected segmnet the arrTableViewData will get change that is use to populate the table view cell and no. of cell.
     ------------------------------------------------------*/
    @IBAction func actionSegmentChange(_ sender: Any) {
        
        let seg = sender as! UISegmentedControl
        
        switch seg.selectedSegmentIndex {
        case 0:
            
            arrTableViewData = NSMutableArray.init(array: arrGroupA)
            
            break
            
        case 1:
          
            arrTableViewData = NSMutableArray.init(array: arrGroupB)
            
            break
            
        case 2:
            
            arrTableViewData = NSMutableArray.init(array: arrGroupC)
            
            break
            
        default:
            print("test")
            
            break
        }
        
        tblListing.reloadData()
        
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let mediaType = info[UIImagePickerControllerMediaType] as? String
        {
            if mediaType  == "public.image"
            {
                let image = info[UIImagePickerControllerOriginalImage] as! UIImage
                
                imageData = (UIImagePNGRepresentation(image) as NSData?)!
                
                picker.dismiss(animated: true, completion: nil)
                
                performSegue(withIdentifier: Constants.kGoToImagePreview, sender: nil)
            }
            else
            {
                picker.dismiss(animated: true, completion: nil)

                CommanMethods.alertView(message: Constants.kAlert_Only_images_allowed as NSString , viewController: self, type: 1)
//                self.showOKAlert(title :Constants.kstrError ,message: Constants.kAlert_Only_images_allowed)
            }
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        
        picker.dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let imgPreviewVC = segue.destination as! AssembleTrayCloneImgPreviewViewController
        imgPreviewVC.trayNumber = trayNumber
        imgPreviewVC.imageData = imageData
    }
    
}
class ClonetblTrayDetailCell: UITableViewCell {
    
    @IBOutlet weak var lblScrewStatus: UILabel!
    @IBOutlet var lblScrewId: UILabel!
    
    @IBOutlet var lblScrewLocation: UILabel!
    
}
