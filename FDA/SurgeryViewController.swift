   //
//  SurgeryViewController.swift
//  FDA
//
//  Created by Mahendar on 8/5/17.
//  Copyright © 2017 Mahendar. All rights reserved.
//

import UIKit

class SurgeryViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate, UISearchControllerDelegate, HandlePatientSearch
{
    @IBOutlet weak var patientName: UITextField!
    @IBOutlet weak var surgeonName: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var surgeryType: UITextField!
    var arrTrayType : NSMutableArray = NSMutableArray.init()
    var trayType : NSString = ""
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var trayTableView : UITableView!
    @IBOutlet weak var addTrayView: UIView!
    @IBOutlet weak var selectedTrayView: UIView!
    var surgeryPickerView : UIPickerView!
    var patientPickerView : UIPickerView!
    var doctorPickerView : UIPickerView!
    var datePicker : UIPickerView!
    var typePickerView: UIPickerView = UIPickerView()
    var selectedTray : String?
    var dicionaryForTray :[String: Any] = [:]
    var i = 0
    
    var caseId:Any! = nil
    
    var arrTraydata:[[String:Any]] = [[String:Any]]()
    var arrTraydic:[[String:Any]] = [[String:Any]]()
    
    /*------------------------------------------------------
     Dictionary for the save Tray Request
     ------------------------------------------------------*/
    var dicForsaveTrays :[String: Any] = [:]    
    var surgeryTypesArr:[[String: Any]] = [[:]]
    var patientArr:[[String: Any]] = [[String: Any]]()
    var doctorArr:[String] = []
    var trayArr:[[String: Any]]! = []
    var arrsurgeonDate:[String] = []
    
    var resultSearchController : UISearchController!
    
    let user = User()
    
    @IBAction func next(_ sender: UIButton)
    {
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        date.text = "";
        
        /*------------------------------------------------------
         the below code will be adding the input view function call for the text field of surgeryType, surgeryName, patientName and date
         ------------------------------------------------------*/
        
        surgeryType.inputView = getSurgerTypePickerView()
        surgeonName.inputView = getDoctorPickerView()
        patientName.inputView = getPatientPickerView()
        date.inputView = getDateView()
        
        /*------------------------------------------------------
         getAllSurgery api call for textfield surgeryType
         ------------------------------------------------------*/
        
        apiCalling()
        
        /*------------------------------------------------------
         Untill the user selects the patient name the user interaction of surgeonName, type and date will be disable
         ------------------------------------------------------*/
        
        surgeonName.isUserInteractionEnabled = false
        date.isUserInteractionEnabled = false
        surgeryType.isUserInteractionEnabled = false
        
        trayTableView.tableFooterView = UIView()
        
        var popToVC : LandingViewController?
        var popToVC1 : ChooseWorkflowViewController?
        for vc in (self.navigationController?.viewControllers)!
        {
            if vc is LandingViewController
            {
                popToVC = vc as? LandingViewController
         
                popToVC?.callerClass = ""
            }
            else if vc is ChooseWorkflowViewController
            {
                popToVC1 = vc as? ChooseWorkflowViewController
                
                popToVC1?.callerClass = ""
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        trayTableView.reloadData()        
    }
    
    /*------------------------------------------------------
     The below method will get initialize when the api call response get true of getAllSurgery that is being called from view did load
     ------------------------------------------------------*/
    
    func initializePatientSearch()
    {
        let patientSearchVC = storyboard!.instantiateViewController(withIdentifier: "PatientSearchViewController") as! PatientSearchViewController
        patientSearchVC.patientArr = patientArr
        patientSearchVC.handleSearchDelegate = self
        resultSearchController = UISearchController(searchResultsController: patientSearchVC)
        resultSearchController.searchResultsUpdater = patientSearchVC
        resultSearchController.delegate = self
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
    }
    
    /*------------------------------------------------------
     The below method is being called from class DrawerMenuVC to perform side menu functionality to land on current page
     ------------------------------------------------------*/
    func searchBySurgery()
    {
        self.performSegue(withIdentifier: "searchBySurgery", sender: nil)
    }
    
    /*------------------------------------------------------
     The below method will be initializing the resultSearchController that is being initialized when user taps on patient name field and filling up the data from getAllSurgery api
     ------------------------------------------------------*/
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == patientName
        {
            patientName.isHidden = true
            let searchBar = resultSearchController!.searchBar
            searchBar.frame = CGRect(x:0,y:100,width:300,height:40)
            searchBar.placeholder = "Search for patient"
            navigationItem.titleView = searchBar
            resultSearchController.searchBar.becomeFirstResponder()
            return false
        }
        return true
    }

    /*------------------------------------------------------
     MARK: - apiCalling for getPatients Method
     ------------------------------------------------------*/
    
    func apiCalling()
    {
        CommanMethods.addProgrssView(aStrMessage: "", isActivity: false)
        
        let dicSettings = UserDefaults.standard.value(forKey: "latestSettings") as? Dictionary<String,Any>
        
        user.UserID = dicSettings?[Constants.kUserID] as? String
        
        let arrUrl = [Constants.getPatients,Constants.getSurgeons,Constants.getAllSurgery]
        
        /*------------------------------------------------------
         Below api will get all the patient names and call initializePatientSearch method for setting up tha data for controller resultSearchController
         ------------------------------------------------------*/
        
        SurgeryViewWebservises().getListing(user,arrUrl[i],{(response,err) in
            CommanMethods.removeProgrssView(isActivity: true)
            
            if response != nil
            {
                self.patientArr = response!
                self.initializePatientSearch()
            }
            else
            {
                CommanMethods.alertView(message: Constants.kstrWrongResponse as NSString, viewController: self, type: 1)
            }
            
        })
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    /*------------------------------------------------------
     The below method will be differentiating the button action for pre surgery flow and post surgery flow
     ------------------------------------------------------*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "proceedToPreSurgery"
        {
            let destVC = segue.destination as! GoToTrayViewController
            destVC.totalNumberOfTrays = trayArr.count
            destVC.trayNumber = 1
            destVC.arrTrayType = self.arrTrayType
            destVC.caseId = self.caseId
            destVC.dicForsaveTrays = dicForsaveTrays
            destVC.trayArr = trayArr
        }
        if segue.identifier == Constants.kgotoPostSurgery
        {
            let destVC = segue.destination as! AcceptTrayStep1ViewController
            destVC.dicForsaveTrays = dicForsaveTrays
            destVC.arrTrayType = self.arrTrayType
            destVC.totalNumberOfTrays = trayArr.count
            destVC.trayNumber = 1
        }
    }
    
    /*------------------------------------------------------
     The below method will be setting the surgeryPickerView at viewDidLoad
     ------------------------------------------------------*/
    func getSurgerTypePickerView() -> UIView
    {
        surgeryPickerView  = UIPickerView(frame: CGRect(x:0,y:0,width:view.frame.size.width,height:250))
        surgeryPickerView.dataSource = self
        surgeryPickerView.delegate = self
        surgeryPickerView.translatesAutoresizingMaskIntoConstraints = false
        return surgeryPickerView
    }
    
    /*------------------------------------------------------
     The below method will be setting the PatientPickerView at viewDidLoad
     ------------------------------------------------------*/
    
    func getPatientPickerView() -> UIView
    {
        patientPickerView  = UIPickerView(frame: CGRect(x:0,y:0,width:view.frame.size.width,height:250))
        patientPickerView.dataSource = self
        patientPickerView.delegate = self
        patientPickerView.translatesAutoresizingMaskIntoConstraints = false
        return patientPickerView
    }
    
     /*------------------------------------------------------
     The below method will be setting the DoctorPickerView at viewDidLoad
     ------------------------------------------------------*/
    
    func getDoctorPickerView() -> UIView
    {
        doctorPickerView  = UIPickerView(frame: CGRect(x:0,y:0,width:view.frame.size.width,height:250))
        doctorPickerView.dataSource = self
        doctorPickerView.delegate = self
        doctorPickerView.translatesAutoresizingMaskIntoConstraints = false
        return doctorPickerView
    }
    
    /*------------------------------------------------------
     The below method will be setting the DateView at viewDidLoad
     ------------------------------------------------------*/
    
    func getDateView() -> UIView
    {
        
        datePicker  = UIPickerView(frame: CGRect(x:0,y:0,width:view.frame.size.width,height:250))
        datePicker.dataSource = self
        datePicker.delegate = self
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }
    
    func dateChanged(datePicker: UIDatePicker)
    {
        let df = DateFormatter()
        df.dateFormat = "MM-dd-YYYY"
        date.text = df.string(from: datePicker.date)
        dicForsaveTrays["date"] = df.string(from: datePicker.date)
    }
    
    /*------------------------------------------------------
     MARK: - UITextField View Delegate Methods
     ------------------------------------------------------*/
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        let picker = textField.inputView as! UIPickerView
        let index = picker.selectedRow(inComponent: 0)
        
        self .pickerView(picker, didSelectRow: index, inComponent: 0)
    }
    
    /*------------------------------------------------------
      MARK: - Picker View Delegate Methods
     ------------------------------------------------------*/
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    /*------------------------------------------------------
     The below method will be returning the data for the correspoding picker view that is being selected from the response of api calls. rest of the information is being available in method pickerView->didSelect method
     ------------------------------------------------------*/
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        switch pickerView
        {
            case surgeryPickerView:
                
                return surgeryTypesArr.count
            case doctorPickerView:
                
                return doctorArr.count
            
            case patientPickerView:
                return patientArr.count
            
            case datePicker:
                
                return arrsurgeonDate.count
            
            default:
                return 0
        }
    }
    
    /*------------------------------------------------------
     The below method will be setting the text of particular picker view the data for that is being set in method pickerView->didSelect method and will be populated here
     ------------------------------------------------------*/
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let label = UILabel(frame: CGRect(x:0,y:0,width:pickerView.frame.size.width,height:40))
        
        label.textAlignment = .center
        
        var text = ""
        
        switch pickerView
        {
            case surgeryPickerView:
                
                let dic = surgeryTypesArr[row]
                text = dic[Constants.ksurgeryType] as! String
            
            case doctorPickerView:
                
                text = doctorArr[row]
            
            case patientPickerView:
            
            if(patientArr.count == 0)
            {
                break
            }
            
            let dic = patientArr[row]
            
            text = dic[Constants.kname] as! String
            
            case datePicker:
                
                text = arrsurgeonDate[row]
            
            default:
                text = ""
        }
        
        label.text = text
        
        label.font = UIFont.systemFont(ofSize: label.getFontForDevice())
        
        return label
    }
    
    /*------------------------------------------------------
     The below method will set the picker view height depending on current device height
     ------------------------------------------------------*/
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
    {
        return pickerView.getHeightForDevice()
    }
    
    /*------------------------------------------------------
     The below method will be called when user selects any item from picker view
     ------------------------------------------------------*/
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView
        {
            /*------------------------------------------------------
             When user selects the surgery type text field at last after filling up details for patients, surgeon name, date
             ------------------------------------------------------*/
            
            case surgeryPickerView:
                
                if(surgeryTypesArr.count == 0)
                {
                    return
                }
                
                let dic = surgeryTypesArr[row]
                
                surgeryType.text = dic[Constants.ksurgeryType] as? String
                
                dicForsaveTrays[Constants.ksurgeryTypeId] = "\(dic["id"]!)"
                
                surgeryType.resignFirstResponder()
                
                /*------------------------------------------------------
                 below elements will be hidden
                 ------------------------------------------------------*/
                
                addTrayView.isHidden = false
                trayTableView.isHidden = false
                nextButton.isHidden = true
                selectedTrayView.isHidden = true
                
                /*------------------------------------------------------
                 will prepare the dictionary using patientId, surgeonName, surgeryTypeId and date
                 ------------------------------------------------------*/
                
                dicionaryForTray = [Constants.kpatientId:dicForsaveTrays[Constants.kpatientId] as! String,Constants.ksurgeonName:dicForsaveTrays[Constants.ksurgeonName]  as! String,Constants.ksurgeryTypeId:dicForsaveTrays[Constants.ksurgeryTypeId]  as! String,"date":dicForsaveTrays["date"]  as! String] as Dictionary<String,Any>
                
                CommanMethods.addProgrssView(aStrMessage: "", isActivity: false)
                
                /*------------------------------------------------------
                 api calling for the tray listing
                 ------------------------------------------------------*/
                  
                SurgeryViewWebservises().getTrayListing(dicionaryForTray, Constants.getTrayById,{(response,err) in
                    
                    if response != nil
                    {
                        self.trayArr = response!
                        self.dicForsaveTrays["PreSurgery"] = response!
                        self.trayTableView.reloadData()
                        
                        /*------------------------------------------------------
                          Calling method caseDetailsApiCall for getting the case details using parameter   dicionaryForTray consisting of patientId, surgeonName, surgeryTypeId and date
                         ------------------------------------------------------*/
                        let dictTemp = NSMutableDictionary.init(dictionary: self.dicForsaveTrays)
                        
                        self.caseDetailsApiCall(dicionaryForTray: self.dicionaryForTray)
                        
                        CommanMethods.removeProgrssView(isActivity: true)
                        
                        self.arrTrayType = NSMutableArray.init()
                        
                        for i in 0 ..< (((dictTemp.value(forKey: "PreSurgery") as! NSArray).value(forKey: "product")) as! NSArray).count
                        {
                             self.trayType = ((((((dictTemp.value(forKey: "PreSurgery") as! NSArray).value(forKey: "product")) as! NSArray).object(at: i)) as! NSMutableDictionary).value(forKey: "type") as AnyObject) as! NSString
                            
                            self.arrTrayType.add(self.trayType)
                        }
                    }
                    else
                    {
                        CommanMethods.removeProgrssView(isActivity: true)
                        CommanMethods.alertView(message: Constants.kstrWrongResponse as NSString, viewController: self, type: 1)
                    }
                })
            
            /*------------------------------------------------------
             When user selects the surgeonName field after selecting patient name
             ------------------------------------------------------*/
            
            case doctorPickerView:
                
                if(doctorArr.count == 0)
                {
                    
                    return
                }
                
                surgeonName.text = doctorArr[row]
                
                dicForsaveTrays[Constants.ksurgeonName] = surgeonName.text
                
                /*------------------------------------------------------
                 will prepare the dictionary using patientId, surgeonName for api getcasedates
                 ------------------------------------------------------*/
                
                let dicionaryForGettingSurgeonDate = [Constants.kpatientId:dicForsaveTrays[Constants.kpatientId] as! String, Constants.ksurgeonName:dicForsaveTrays[Constants.ksurgeonName]  as! String] as Dictionary<String,Any>
                
                CommanMethods.addProgrssView(aStrMessage: "", isActivity: false)
                
                /*------------------------------------------------------
                 api calling for the surgeon listing
                 ------------------------------------------------------*/
                
                SurgeryViewWebservises().getSurgeonsListing(dicionaryForGettingSurgeonDate, Constants.getcasedates,{(response,err) in
                    
                    CommanMethods.removeProgrssView(isActivity: true)
                    if response != nil
                    {
                        self.arrsurgeonDate = response!
                    }
                    else
                    {
                        CommanMethods.alertView(message: Constants.kstrWrongResponse as NSString, viewController: self, type: 1)
                    }
                })
                
                surgeonName.resignFirstResponder()
                
                date.text = ""
                surgeryType.text = ""
                
                dicForsaveTrays["date"] = nil
                dicForsaveTrays[Constants.ksurgeryTypeId] = nil
                trayArr.removeAll()
                
                /*------------------------------------------------------
                 below elements user interaction will be disable
                 ------------------------------------------------------*/                
                
                surgeonName.isUserInteractionEnabled = true
                date.isUserInteractionEnabled = true
                surgeryType.isUserInteractionEnabled = false
            
            /*------------------------------------------------------
             When user taps on patient field
             ------------------------------------------------------*/
            
            case patientPickerView:
                
                if(patientArr.count == 0)
                {
                    
                    return
                }
                
                let dic = patientArr[row]
                
                patientName.text = dic[Constants.kname] as? String
                
                /*------------------------------------------------------
                 will prepare the dictionary using patientId for api getSurgeons
                 ------------------------------------------------------*/
                
                dicForsaveTrays[Constants.kpatientId] = "\(dic["id"]!)"
                
                /*------------------------------------------------------
                 api calling for the patient listing
                 ------------------------------------------------------*/
                
                let dicionaryForGettingSurgeon = [Constants.kpatientId:dicForsaveTrays[Constants.kpatientId] as! String] as Dictionary<String,Any>
                
                CommanMethods.addProgrssView(aStrMessage: "", isActivity: false)
                SurgeryViewWebservises().getSurgeonsListing(dicionaryForGettingSurgeon, Constants.getSurgeons,{(response,err) in
                    
                    CommanMethods.removeProgrssView(isActivity: true)
                    if response != nil{
                        
                        self.doctorArr = response!
                    }
                    else
                    {
                        CommanMethods.alertView(message: Constants.kstrWrongResponse as NSString, viewController: self, type: 1)
                    }
                })
                
                patientName.resignFirstResponder()
                
                
                surgeonName.text = ""
                date.text = ""
                surgeryType.text = ""
                
                dicForsaveTrays["surgeonId"] = nil
                dicForsaveTrays["date"] = nil
                dicForsaveTrays[Constants.ksurgeryTypeId] = nil
                
                trayArr.removeAll()
                
                surgeonName.isUserInteractionEnabled = true
                date.isUserInteractionEnabled = false
                surgeryType.isUserInteractionEnabled = false
            
            /*------------------------------------------------------
             When user selects date field
             ------------------------------------------------------*/
            
            case datePicker:
                
                if(arrsurgeonDate.count == 0)
                {
                    
                    return
                }
                
                date.text = arrsurgeonDate[row]
                dicForsaveTrays["date"] = arrsurgeonDate[row]
                
                /*------------------------------------------------------
                 will prepare the dictionary using patientId, surgeonName and date for api getSurgeons
                 ------------------------------------------------------*/
                
                let dicionaryForTray = [Constants.kpatientId:dicForsaveTrays[Constants.kpatientId] as! String,Constants.ksurgeonName:dicForsaveTrays[Constants.ksurgeonName]  as! String,"date":dicForsaveTrays["date"]  as! String] as Dictionary<String,Any>
                
                CommanMethods.addProgrssView(aStrMessage: "", isActivity: false)
                
                /*------------------------------------------------------
                 api calling for the tray listing
                 ------------------------------------------------------*/
                
                SurgeryViewWebservises().getTrayListing(dicionaryForTray, Constants.getAllSurgery,{(response,err) in
                    
                    CommanMethods.removeProgrssView(isActivity: true)
                    if response != nil{
                        
                        self.surgeryTypesArr = response!
                    }
                    else
                    {
                        CommanMethods.alertView(message: Constants.kstrWrongResponse as NSString, viewController: self, type: 1)
                    }
                })
                
                date .resignFirstResponder()
                
                surgeryType.text = ""
                
                dicForsaveTrays[Constants.ksurgeryTypeId] = nil
                trayArr.removeAll()
                
                surgeonName.isUserInteractionEnabled = true
                date.isUserInteractionEnabled = true
                surgeryType.isUserInteractionEnabled = true
            
            default:
                return
        }
        
        
        self.trayTableView.reloadData()
    }
    
    /*------------------------------------------------------
     The below method will get called from delegate method of pickerView->didSelect method and fetch the case details by passing parameter patientId, surgeonName, surgeryTypeId and date
     ------------------------------------------------------*/

    func caseDetailsApiCall(dicionaryForTray:Dictionary<String,Any>)
    {
        /*------------------------------------------------------
         api calling for the tray listing
         ------------------------------------------------------*/
        
        let dictTemp = NSMutableDictionary.init(dictionary: self.dicForsaveTrays)
        SurgeryViewWebservises().getCaseDetails(dicionaryForTray, Constants.getrelatedcasedetails,{(response,err) in
            
            CommanMethods.removeProgrssView(isActivity: true)
            if response != nil
            {
                self.caseId = response
            }
            else
            {
                CommanMethods.alertView(message: Constants.kstrWrongResponse as NSString, viewController: self, type: 1)
            }
        })
    }
    
    /*------------------------------------------------------
     MARK: - tableViewDelagate Methods
     ------------------------------------------------------*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (trayArr != nil)
        {
            
            return trayArr.count
        }
        
        return 0
    }
    
    /*------------------------------------------------------
     the below method will be populating the tray assembly id in table view that is being fetched from api getTrayById respose
     ------------------------------------------------------*/
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.textAlignment = .center
        
        let dic = trayArr[indexPath.row]
        cell.textLabel?.text = "Tray " + "Assembly " + "\(dic["id"]!)"
        cell.textLabel?.font = UIFont.systemFont(ofSize: (cell.textLabel?.getFontForDevice())!)
        cell.selectionStyle = .gray
        return cell
    }
    
    /*------------------------------------------------------
     The below table view delegate method will get called when user selects the tray assemble id and will call api  caseIdApiCall to fetch the case details related to the corresponding assembly id
     ------------------------------------------------------*/
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        /*------------------------------------------------------
         Below code is for rearrangement of the tray that is being selected. the logic is below
         Eg. if user has selected tray at index 3
         then until index 2 all tray will be saved in selectedRange var.
         then trayArr data will be removed until index 2 and that removed data that is saved in selectedRange will be added to trayArr later the last index.
         ------------------------------------------------------*/
        let selectedRange = trayArr[0..<indexPath.row]
        trayArr.removeSubrange(0..<indexPath.row)
        trayArr = trayArr + selectedRange
        
        let dic = trayArr.first!
        selectedTray = dic["trayName"] as? String
        
        dicForsaveTrays[Constants.kstrtrayId] = trayArr.flatMap { $0["id"] }
        
        i = 0
        arrTraydic.removeAll()
        arrTraydata.removeAll()
        for obj in trayArr
        {
            /*------------------------------------------------------
             below code wont be needed.
             ------------------------------------------------------*/
            arrTraydic.append([Constants.kstrtrayId:obj["trayNumber"]!] as Dictionary<String,Any>)
        }
        
        /*------------------------------------------------------
         Updated on : 11 Jan 2018 12:16 PM
         
         Updation reason : The below code is moved from caseIdApiCall method to here after updation in trayArr data
         
         The below code will fill the array of tray type that will save the tray type according to selected type of tray and then this array will get compare will tray type in every screen where we need to display the edit implant screen
         ------------------------------------------------------*/
        let arrTemp = NSMutableArray.init(array: self.trayArr)
        
        self.arrTrayType = NSMutableArray.init()
        
        for i in 0 ..< self.trayArr.count
        {
            self.arrTrayType.add(((arrTemp.object(at: i) as! NSDictionary).value(forKey: "product") as! NSDictionary).value(forKey: "type") as! NSString)
        }
        
        CommanMethods.addProgrssView(aStrMessage: Constants.kstrLoading, isActivity: true)
        
        /*------------------------------------------------------
         Calling the method for getting caseId
         ------------------------------------------------------*/
        
        caseIdApiCall()
        
        addTrayView.isHidden = true
        selectedTrayView.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return tableView.getHeightForDevice()
    }
    
    /*------------------------------------------------------
     The below methdo will be calld from table view delgate method didSelectRow and will be fetching the caseId for particular selected tray assembly id
     ------------------------------------------------------*/
    
    func caseIdApiCall()
    {
        /*------------------------------------------------------
         api calling for the tray listing
         
         Updated on       : 11-Jan-2018
         Updation purpose : The api getasseblydetailsbyid api has been removed so for fetching casedetails and preparign dictionary dicForsaveTrays we are using getrelatedcasedetails api and data that we get in response we insert in trayData key in dicForsaveTrays dictionary.
         ------------------------------------------------------*/
        let dictTemp = NSMutableDictionary.init(dictionary: self.dicForsaveTrays)
        SurgeryViewWebservises().getCaseDetails(dicionaryForTray, Constants.getrelatedcasedetails,{(response,err) in
            
            if response != nil
            {
                self.caseId = response
                let dic = response
                
                self.arrTraydata.append([Constants.kcaseID : dic!["id"]!,Constants.ktrayData:response as Any])
                
                if(self.i < self.trayArr.count - 1)
                {
                    self.i += 1
                    self.caseIdApiCall()
                }
                else
                {
                    self.dicForsaveTrays[Constants.ktrayData] = self.arrTraydata
                    CommanMethods.removeProgrssView(isActivity: true)
                }
            }
            else
            {
                CommanMethods.alertView(message: Constants.kstrWrongResponse as NSString, viewController: self, type: 1)
            }
        })        
    }
    
    /*------------------------------------------------------
     The below method will get called when the user clicks on go to pre surgery flow
     ------------------------------------------------------*/
    @IBAction func gotoPreSurgeryClicked(sender : UIButton)
    {
        
        self.performSegue(withIdentifier: "proceedToPreSurgery", sender: nil)
    }
    
    /*------------------------------------------------------
     The below method will get called when the user clicks on go to post surgery flow
     ------------------------------------------------------*/
    
    @IBAction func gotoPostSurgeryClicked(sender : UIButton)
    {
        self.performSegue(withIdentifier: Constants.kgotoPostSurgery, sender: nil)
    }
    
    /*------------------------------------------------------
     The below method will get called when the user clicks on add tray flow and will be sending the case details and navigate to the VC :- LandingViewController where user binds tha assembly id to case id
     ------------------------------------------------------*/
    
    @IBAction func addTrayPressed (sender : UIButton)
    {
//        var popToVC : LandingViewController?
//        for vc in (self.navigationController?.viewControllers)!
//        {
//            if vc is LandingViewController
//            {
//                popToVC = vc as? LandingViewController
//                popToVC?.goToScan = true
//                popToVC?.callerClass = ""
//                popToVC?.isForAddTray = true
//                popToVC?.caseId = self.caseId
//            }
//        }
//        if let vc = popToVC
//        {
//            self.navigationController?.popToViewController(vc, animated: false)
//        }
        let scanTrayVC = self.storyboard?.instantiateViewController(withIdentifier: Constants.kScanBarcodeHomeViewController) as! ScanBarcodeHomeViewController
        
        scanTrayVC.caseId = self.caseId
        
        scanTrayVC.isForAddTray = true
        
        self.navigationController?.pushViewController(scanTrayVC, animated: true)
    }
    
    @IBAction func openMenu(_ sender: UIButton)
    {
        let drawer = navigationController?.parent
        if let drawer = drawer as? KYDrawerController
        {
            drawer.setDrawerState(.opened, animated: true)
        }
    }
    
    /*------------------------------------------------------
     The below method will be calling the api getSurgeons to get the listing of patient 
     ------------------------------------------------------*/
    func patientSelected(_ patientDict: [String:Any])
    {
        dicForsaveTrays[Constants.kpatientId] = "\(patientDict["id"]!)"
        
        /*------------------------------------------------------
         api calling for the patient listing
         ------------------------------------------------------*/
        
        let dicionaryForGettingSurgeon = [Constants.kpatientId:dicForsaveTrays[Constants.kpatientId] as! String] as Dictionary<String,Any>
        
        CommanMethods.addProgrssView(aStrMessage: "", isActivity: false)
        SurgeryViewWebservises().getSurgeonsListing(dicionaryForGettingSurgeon, Constants.getSurgeons,{(response,err) in
            
            CommanMethods.removeProgrssView(isActivity: true)
            if response != nil
            {
                self.doctorArr = response!
                self.surgeonName.isUserInteractionEnabled = true
                self.date.isUserInteractionEnabled = false
                self.surgeryType.isUserInteractionEnabled = false
            }
            else
            {
                CommanMethods.alertView(message: Constants.kstrWrongResponse as NSString, viewController: self, type: 1)
            }
        })
        
        patientName.isHidden = false
        navigationItem.titleView = nil
        patientName.text = patientDict[Constants.kname] as? String
    }
    
    func willPresentSearchController(_ searchController: UISearchController)
    {
        searchController.searchResultsController?.view.isHidden = false
    }
    
    func didPresentSearchController(_ searchController: UISearchController)
    {
        searchController.searchResultsController?.view.isHidden = false
    }
}
