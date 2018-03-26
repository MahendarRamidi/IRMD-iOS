//
//  PatientSearchViewController.swift
//  FDA
//
//  Created by aditya on 21/08/17.
//  Copyright © 2017 Aditya. All rights reserved.
//

import UIKit

protocol HandlePatientSearch: class {
    func patientSelected(_ patientDict: [String:Any])
}


class PatientSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var patientArr : [[String:Any]] = []
    var searchedpatientArr : [[String:Any]] = []
    weak var handleSearchDelegate: HandlePatientSearch?
    @IBOutlet weak var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchedpatientArr.removeAll()
        searchedpatientArr.append(contentsOf: patientArr)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PatientSearchViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchBarText = searchController.searchBar.text else {
            return
        }
        
        searchedpatientArr.removeAll()
        if searchBarText.characters.count == 0{
            searchedpatientArr.append(contentsOf: patientArr)
        }
        else{
            for obj in patientArr{
                let str = obj[Constants.kname] as! String
                if str.lowercased().contains(searchBarText.lowercased()){
                    searchedpatientArr.append(obj)
                }
            }
        }
        tableView.reloadData()
    }
    
}

extension PatientSearchViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedpatientArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "patientCell")!
        let patientName = searchedpatientArr[indexPath.row]
        cell.textLabel?.text = patientName[Constants.kname] as? String
        cell.textLabel?.font = UIFont.systemFont(ofSize: (cell.textLabel?.getFontForDevice())!)
        return cell
    }
    
}

extension PatientSearchViewController {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let patientName = searchedpatientArr[indexPath.row]
        handleSearchDelegate?.patientSelected(patientName)
        dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.getHeightForDevice()
    }
}
