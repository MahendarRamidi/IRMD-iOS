//
//  Constants.swift
//  FDA
//
//  Created by on 10/08/17.
//  Copyright © 2017 Aditya. All rights reserved.
//

import UIKit

class Constants: UIViewController {

    // Api constants
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
/*  static let baseApiURL = "http://192.192.7.251:9595/imagerecognitionsample/rest/"
    static let login = "login"
    static let getPatients = "patient/getPatients"
    static let getSurgeons = "surgeon/getSurgeons"
    static let getAllSurgery = "surgeryType/getAllSurgery"
    static let getcasedates = "/getcasedates"
    static let getTrayById = "tray/getTrayById"
    static let getsavetray = "tray/savetray"
    static let getregistration = "registration" */
    
    static let kProjectName = "FDA"
    static let login = "mdiruser/login/"
    static let register = "mdiruser/register/"
    static let getalluserRole = "mdiruser/getalluserRole/"
    static let getUserRoleByToken = "mdiruser/getuserrolebytoken/"
    static let karrGroup1 = NSArray(objects: "10","12","14","16","18","20","22","24","26","28","30","32","34","35","36","38","40","42","44","45","46","48","50","52")
    static let karrGroup2 = NSArray(objects: "6","8","10","12","14","16","18","20","22","24","26","28","30","32","34","36","38","40")
    static let karrGroup3 = NSArray(objects: "6","7","8","9","10","11","12","14","16","18","20","22","24","26","28","30")
    static let karrSection = NSArray(objects: "A","B","C","D","E","F","G","H","I","J")
    
    //phase-1 URL
    /*------------------------------------------------------*/
  //  static let baseApiURL = "http://52.5.157.28:8080/imagerecognition-web/"
    /*------------------------------------------------------*/
    
    //phase-2 URL
    /*------------------------------------------------------
    static let baseApiURL = "http://192.192.8.149:8081/imagerecognition-web/"
     ------------------------------------------------------*/
    
    //Client Common server
    static let baseApiURL = "http://ec2-52-5-157-28.compute-1.amazonaws.com:8080/imagerecognition-web/"
    
    //Developer side common server
  //  static let baseApiURL = "http://192.192.7.154:7171/imagerecognition-web/"
    
    static let getPatients = "patient/getpatients"
    static let getSurgeons = "getSurgeons"
    static let getAllSurgery = "getrelatedsurgerytypes"
    static let getcasedates = "/getcasedates"
    static let getTrayById = "getrelatedassemblies"
    static let getsavetray = "tray/savetray"
    static let getregistration = "registration"
    static let getsearchtraybyid = "searchtraybyid"
    static let saveassembly = "saveassembly"
    static let getscrewsdetailsbyassemblyid = "getscrewsdetailsbyassemblyid"
    static let getscrewsdetailsbyremovestatusbyassemblyid = "getscrewsdetailsbyremovestatusbyassemblyid"
    static let updatepreimagebyassemblyid = "updatepreimagebyassemblyid"
    static let updatepostimagebyassemblyid = "updatepostimagebyassemblyid"
    static let updatedetectedimagebyassemblyid = "updatedetectedimagebyassemblyid"
    static let getpreimagebyassemblyid = "getpreimagebyassemblyid"
    static let getpostimagebyassemblyid = "getpostimagebyassemblyid"
    static let getassignassemblytocase = "assignassemblytocase"
//    static let kvalidatescrewforproduct = "validatescrewforproduct"
    static let ksearchimplantybybarcode = "searchimplantybybarcode"
    static let getsearchtraybybarcode = "searchtraybybarcode"
    static let getassemblyimagebyassemblyid = "getassemblyimagebyassemblyid"
    static let createassemblyclone = "createassemblyclone"
    static let ksearchtraybyidforassigntray = "searchtraybyidforassigntray"
//    http://192.192.7.154:7171/imagerecognition-web/searchtraybynumberforassigntray/aa11
//    http://192.192.7.154:7171/imagerecognition-web/searchtraybytraynumber/aa11
    static let ksearchtraybynumberforassigntray = "searchtraybynumberforassigntray"
    static let ksearchtraybytraynumber = "searchtraybytraynumber"
    static let ksearchtraybybarcodeforassigntray = "searchtraybybarcodeforassigntray"
    static let ksearchtraybybarcodeforassembletray = "searchtraybybarcodeforassembletray"
    //createassemblyclone
    
    static let getrelatedcasedetails = "getrelatedcasedetails"
    
    static let imageRecognition = "http://ec2-52-22-159-14.compute-1.amazonaws.com:8080/"
    
     // static let imageRecognition = "http://52.22.159.14:8080/"
    // image recognition url for tray 2
   // static let imageRecognitionTray2 = "http://52.22.159.14:8080/tray2"
    static let imageRecognitionTray2 = "http://ec2-52-22-159-14.compute-1.amazonaws.com:8080/tray2"
    
    //Comman constants
    static let kTrayAssembly = "TrayAssembly"
    static let kSTORYBOARD = UIStoryboard(name: "Main", bundle: Bundle.main)
    static let kgoToScanPatientDetail = "goToScanPatientDetail"
    static let ksearchById = "searchById"
    
    // date :- 24 oct 2017¡
    
    static let ktrayDetail = "trayDetail"
    
    // date :- 25 oct 2017
    //Api names
    
    static let kstrUpdatedImage = "Updated image"
    static let kstrAddRemoveMoreImplants = "Add/Remove more implants"
    static let kstrDone = "Done"
    static let kstrScanBarCode = "ScanBarCode"
    static let kstrAssembleTrayScannedImage = "AssembleTrayScannedImage"
    static let kstrgotoEditImplant = "gotoEditImplant"
    static let kstrgotoEditImplantTray2 = "gotoEditImplantTray2"
    static let kcreateassemblyclone = "createassemblyclone"
    static let kcreatepreassemblyclone = "createpreassemblyclone"
    static let kScanBarcodePreSurgeryViewController = "ScanBarcodePreSurgeryViewController"
    static let kGoToTrayViewController = "GoToTrayViewController"
    static let kgoToEditImplantPreSurgeryViewController = "goToEditImplantPreSurgeryViewController"
    static let kgotoPostSurgery = "gotoPostSurgery"
    static let kbackToAcceptAndFinish = "backToAcceptAndFinish"
    static let kSelectImplantPreSurgeryViewController = "SelectImplantPreSurgeryViewController"
    static let kupdateassemblyimagebyassemblyid = "updateassemblyimagebyassemblyid"
    static let ksearchcashidfortrayid = "searchcashidfortrayid"
    
    //Alert view messages
    
    static let kAlert_Please_select_screw = "Please select implant."
    static let kAlert_Choose_from_Gallery = "Choose from Gallery"
    static let kAlert_Sorry_this_device_has_no_camera = "Sorry, this device has no camera"
    static let kGoToScanImplant = "GoToScanImplant"
    static let kAlert_Please_take_picture_again = "Please Retake Picture"
    static let kAlert_No_Camera = "No Camera"
    static let kshowLanding = "showLanding"
    static let kAlert_Select_Image = "Select Image"
    static let kCamera = "Camera"
    static let kGoToImagePreview = "GoToImagePreview"
    static let kAlert_Only_images_allowed = "Only images allowed."
    static let ksuccessfullLogin = "successfullLogin"
    static let kAlert_Wrong_Username_Or_Password = "Wrong Username or Password"
    static let kAlert_Please_enter_First_Name = "Please enter First Name"
    static let kAlert_Please_enter_Last_Name = "Please enter Last Name"
    static let kAlert_Please_Email = "Please Email"
    static let kAlert_Please_select_user_role = "Please select user role"
    static let kAlert_Please_enter_valid_email = "Please enter valid email"
    static let kAlert_Duplicate_Record_situation_with_input_parameters = "Duplicate Record situation with input parameters"
    static let kAlert_Duplicate_Record = "Duplicate Record"
    static let kNo_assembly_image_available = "No assembly image available"
    static let kAlert_case_details_are_not_bind = "This tray has not been associated with any case"
    static let kAlert_Image_updated = "Image updated"
    static let kPost_Surgery_Image_Captured = "Post-Surgery Image Captured"
    static let kPostop_Tray_Configuration_Updated = "Postop Tray Configuration Updated"
    static let kAlert_JSON_is_invalid = "JSON is invalid"
    static let kAlert_This_tray_has_already_been_assigned_to_a_case = "This tray has already been assigned to a case"
    
    static let kstrtrayId = "trayId"
    static let kexample = "example"
    static let kjson = "json"
    static let kimageViewer = "imageViewer"
    static let kSelectImplantPreSurgeryTray2ViewController = "SelectImplantPreSurgeryTray2ViewController"
    static let kgoToAcceptTrayStep2PreSurgeryViewController = "goToAcceptTrayStep2PreSurgeryViewController"
    static let kgoToUpdateTray = "goToUpdateTray"
    static let ktrayGroup = "trayGroup"
    static let kSelectImplantTray2ViewController = "SelectImplantTray2ViewController"
    static let kSelectedImplantViewController = "SelectedImplantViewController"
    static let kScanBarcodeHomeViewController = "ScanBarcodeHomeViewController"
    static let kdrawerClassSurgerySession = "drawerClassSurgerySession"
    static let kstrtrayID = "trayID"
    static let kcaseID  = "caseID"
    static let ktrayBaseline = "trayBaseline"
    static let kstrtrayGroup = "trayGroup"
    static let kstrholeNumber = "holeNumber"
    static let kstrLoading = "Loading"
    static let kstrmessage = "message"
    static let kstrFailed = "Failed"
    static let kscrewID = "screwID"
    static let kstrError = "Error"
    static let kSuccess = "Success"
    static let kPicture_has_been_uploaded = "Assembly Image Uploaded"
    static let kPre_Surgery_Image_Updated = "Pre-Surgery Image Updated"
    static let kstrWrongResponse = "Please Try Again"
    static let kmsgNoRecord = "No Record Found"
    static let kstrid = "id"
    static let kUserID = "UserID"
    static let kAlertPlease_enter_email = "Please Enter Email"
    static let kAlert_Please_enter_Password = "Please Enter Password"
    static let kstrPreAssembly = "preAssembly"
    static let kstrrefAssembly = "refAssembly"
    static let kstrcaseDetails = "caseDetails"
    static let kDateFormat = "yyyy-MM-dd HH:mm:ss"//surgeonName
    static let ksurgeonName = "surgeonName"
    static let kstrcaseDate = "caseDate"
    static let kTestProductCode = "prod1"
    static let kTestBarCode = "bar1"
    static let kproduct = "product"
    static let kdescription = "description"
    static let kMsgRecordNotFound = "Cannot Record"
    static let kMsgWrongResponse = "Please Try Again"
    static let kOk = "Ok"
    static let kassemblyDetails = "assemblyDetails"
    static let kscrewStatus = "screwStatus"
    static let ktrayData = "trayData"
    static let kscrewId = "screwId"//surgeryType
    static let kpatient = "patient"
    static let kname = "name"
    static let ksurgeryType = "surgeryType"
    static let ksurgeryTypeId = "surgeryTypeId"
    static let krole = "role"
    static let kchooseVC = "chooseVC"
    static let kfirstName = "firstName"
    static let klastName = "lastName"
    static let kemailID = "emailID"
    static let kuserName = "userName"
    static let kpassword = "password"
    static let kdata = "data"
    static let kscanImplant = "scanImplant"
    static let kcellWithLabel1 = "cellWithLabel1"
    static let kPresent = "Present"
    static let kRemoved = "Removed"
    static let kpatientId = "patientId"
    static let kSelected = "Selected"
    static let kDeselected = "Deselected"
    static let kother = "other"
    static let kHOLE_NUMBER = "HOLE_NUMBER"
    static let kTRAY_GROUP = "TRAY_GROUP"
    static let kSCREW_ID = "SCREW_ID"
    static let kSCREW_STATUS = "SCREW_STATUS"
    static let ktray_1 = "tray 1"
    static let kTray_1 = "Tray 1"
    static let kTray_2 = "Tray 2"
    static let ktray_2 = "tray 2"
    static let knewAssemblyID = "newAssemblyID"
    static let ktrayDetailFromScanBarcode = "trayDetailFromScanBarcode"
    static let kGoToAssembleTrayDetailTray2 = "GoToAssembleTrayDetailTray2"
    static let kFinish_and_Go_To_Post_Surgery = "Finish and Go To Post Surgery"
    static let kGoToAssembleTrayDetail = "GoToAssembleTrayDetail"
    static let kmsgTrayHasBennCloned = "Tray has been cloned."
    static let kTray_Assembly_Has_Been_Edited = "Tray Assembly Edited"
    static let kPresurgeryAcceptAndTakePictureViewController =  "PresurgeryAcceptAndTakePictureViewController"
    static let knew_Assigned_ID = "new_Assigned_ID"
    static let kbackToEditImplants = "backToEditImplants"
    static let kpredicateHoleNumberAndTrayGroup = "SELF.HOLE_NUMBER ==[c] %@ AND SELF.TRAY_GROUP = %d"
    static let kgotoEditImplant2 = "gotoEditImplant2"
    static let kaddTrayToTrayDetail = "addTrayToTrayDetail"
    static let kUnwindToGotoTray = "UnwindToGotoTray"
    static let kstatusFlag = "statusFlag"
    static let kmarkedImage = "markedImage"
    static let kPreImage = "PreImage"
    static let koverrideHoles = "overrideHoles"
    static let kpicture = "picture"
    static let kCustomAlertViewController = "CustomAlertViewController"
    static let kunwindToGoToScanBarCodePreSurgeryWithSegue = "unwindToGoToScanBarCodePreSurgeryWithSegue"
    static let kGoToTray = "GoToTray"
    
    //Predicates used
    
    static let kpredicateForGroup1 =  NSPredicate(format: "trayGroup ==[c] '1'");
    static let kpredicateForGroup2 =  NSPredicate(format: "trayGroup ==[c] '2'");
    static let kpredicateForGroup3 =  NSPredicate(format: "trayGroup ==[c] '3'");
    
    static let karrBackGroundColorImplantPlain = NSArray(objects: "A1-clear","A2-clear","A3-clear","A4-clear","A5-clear","B8-clear","B7-clear","B6-clear","B5-clear","B4-clear","B3-clear","B2-clear","B1-clear","C6_Clear","C5_Clear","C4_Clear","C3_Clear","C2_Clear","C1_Clear","MDIR-plane_small1","MDIR-plane1","MDIR-plane","MDIR-plane_small","E1-clear","E2-clear","E3-clear","E4-clear","E5-clear")
    
    static let karrBackGroundColorImplantSelected = NSArray(objects: "A1-Yellow","A2-Yellow","A3-Yellow","A4-Yellow","A5-Yellow","B8-Yellow","B7-Yellow","B6-Yellow","B5-Yellow","B4-Yellow","B3-Yellow","B2-Yellow","B1-Yellow","C6_Yellow","C5_Yellow","C4_Yellow","C3_Yellow","C2_Yellow","C1_Yellow","MDIR-yellow_small1","MDIR-yellow1","MDIR-yellow","MDIR-yellow_small","E1-Yellow","E2-Yellow","E3-Yellow","E4-Yellow","E5-Yellow")
    
    static let karrBackGroundColorImplantPresent = NSArray(objects: "A1-Green","A2-Green","A3-Green","A4-Green","A5-Green","B8-Green","B7-Green","B6-Green","B5-Green","B4-Green","B3-Green","B2-Green","B1-Green","C6_Green","C5_Green","C4_Green","C3_Green","C2_Green","C1_Green","MDIR-green_small1","MDIR-green1","MDIR-green","MDIR-green_small","E1-Green","E2-Green","E3-Green","E4-Green","E5-Green")
    
    static let karrBackGroundColorImplantRemoved = NSArray(objects: "A1-Red","A2-Red","A3-Red","A4-Red","A5-Red","B8-Red","B7-Red","B6-Red","B5-Red","B4-Red","B3-Red","B2-Red","B1-Red","C6_Red","C5_Red","C4_Red","C3_Red","C2_Red","C1_Red","MDIR-red_small1","MDIR-red1","MDIR-red","MDIR-red_small","E1-Red","E2-Red","E3-Red","E4-Red","E5-Red")
    
    static let karrayHoleNumber = NSArray(objects: "A1","A2","A3","A4","A5","B1","B2","B3","B4","B5","B6","B7","B8","C1","C2","C3","C4","C5","C6","D1","D2","D3","D4","E1","E2","E3","E4","E5")
    
    
    //Present
}
