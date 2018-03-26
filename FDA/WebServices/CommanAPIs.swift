//
//  CommanAPIs.swift
//  FDA
//
//  Created by Kaustubh on 24/08/17.
//  Copyright © 2017 Aditya. All rights reserved.
//

import UIKit

class CommanAPIs: BaseOperation {

    func getScrewListing(_ json : Dictionary<String, Any>,_ urlString : String, _ completionHandler: @escaping ( [[String:Any]]?, Error?) -> Void ) {
        
        /* let json: [String: Any] = ["UserID": user.UserID]
         
         let jsonData = try? JSONSerialization.data(withJSONObject: json) */
        
        
        var str:String! = nil
        switch urlString {
        case Constants.getSurgeons:
            
            str = Constants.getSurgeons + "/\(json[Constants.kpatientId] as! String)"
            break
            
        case Constants.getcasedates:
            
            str = Constants.getcasedates + "/\(json[Constants.kpatientId]  as! String)" + "/\(json[Constants.ksurgeonName] as! String)"
            break
            
        case Constants.getAllSurgery:
            
            str = Constants.getAllSurgery + "/surgeonId" + "/\(json["surgeonId"]  as! String)"
            break
            
        case Constants.getscrewsdetailsbyassemblyid:
            
            str = Constants.getscrewsdetailsbyassemblyid + "/\(json[Constants.kstrtrayID]!)"
            break
            
        case Constants.getscrewsdetailsbyremovestatusbyassemblyid:
            
            str = Constants.getscrewsdetailsbyremovestatusbyassemblyid + "/\(json[Constants.kstrtrayID]!)"
            break

            
        default:
            str = ""
        }
        
        
        
        var request: URLRequest?
        if let url = URL(string: Constants.baseApiURL + str) {
            request = URLRequest(url: url)
            request?.httpMethod = "GET"
        }
        
        /*  var request: URLRequest?
         if let url = URL(string: Constants.baseApiURL + urlString) {
         request = URLRequest(url: url)
         request?.httpMethod = "POST"
         request?.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
         request?.httpBody = jsonData
         } */
        self.sendRequest(request: request, onCompletion: { (data, err) -> Void in
            if err == nil,
                let data = data {
                do {
                    if let responseDictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String:Any]] {
                        completionHandler(responseDictionary, nil)
                    }
                } catch {
                    completionHandler(nil, error)
                }
            } else {
                completionHandler(nil, err)
            }
        })
    }
    
    
    func getAssemblyImage(_ json : Dictionary<String, Any>,_ urlString : String, _ completionHandler: @escaping ( [String:Any]?, Error?) -> Void ) {
        
        /* let json: [String: Any] = ["UserID": user.UserID]
         
         let jsonData = try? JSONSerialization.data(withJSONObject: json) */
        
        
        var str:String! = nil
        switch urlString {
        case Constants.getpreimagebyassemblyid:
            
            str = Constants.getpreimagebyassemblyid + "/\(json[Constants.kstrtrayID]!)"
            break
            
        case Constants.getpostimagebyassemblyid:
            
            str = Constants.getpostimagebyassemblyid + "/\(json[Constants.kstrtrayID]!)"
            
            break
            
        case Constants.getassemblyimagebyassemblyid:
            
            str = Constants.getassemblyimagebyassemblyid + "/\(json[Constants.kstrtrayID]!)"
            
            break
            
            
        default:
            str = ""
        }
        
        
        
        var request: URLRequest?
        if let url = URL(string: Constants.baseApiURL + str) {
            request = URLRequest(url: url)
            request?.httpMethod = "GET"
        }
        
        /*  var request: URLRequest?
         if let url = URL(string: Constants.baseApiURL + urlString) {
         request = URLRequest(url: url) 
         request?.httpMethod = "POST"
         request?.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
         request?.httpBody = jsonData
         } */
        self.sendRequest(request: request, onCompletion: { (data, err) -> Void in
            if err == nil,
                let data = data {
                do {
                    
                    if let responseDictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] {
                        completionHandler(responseDictionary, nil)
                    }
                    
                } catch {
                    completionHandler(nil, error)
                }
            } else {
                completionHandler(nil, err)
            }
        })
    }
    
    func getRequest(_ json : Dictionary<String, Any>,_ urlString : String, _ completionHandler: @escaping ( [String:Any]?, Error?) -> Void ) {
        
        /* let json: [String: Any] = ["UserID": user.UserID]
         
         let jsonData = try? JSONSerialization.data(withJSONObject: json) */
        
        
        var str:String! = nil
        switch urlString {
            
        case Constants.getassignassemblytocase:
            
            str = Constants.getassignassemblytocase + "/\(json[Constants.kstrtrayID]!)" + "/\(json[Constants.kcaseID]!)"
            
            break
            
        default:
            str = ""
        }
        
        
        
        var request: URLRequest?
        if let url = URL(string: Constants.baseApiURL + str) {
            request = URLRequest(url: url)
            request?.httpMethod = "GET"
        }
        
        /*  var request: URLRequest?
         if let url = URL(string: Constants.baseApiURL + urlString) {
         request = URLRequest(url: url)
         request?.httpMethod = "POST"
         request?.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
         request?.httpBody = jsonData
         } */
        self.sendRequest(request: request, onCompletion: { (data, err) -> Void in
            if err == nil,
                let data = data {
                do {
                    
                    if let responseDictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] {
                        completionHandler(responseDictionary, nil)
                    }
                    
                } catch {
                    completionHandler(nil, error)
                }
            } else {
                completionHandler(nil, err)
            }
        })
    }
    
    func saveassembly(_ json : Dictionary<String, Any>,_ urlString : String, _ completionHandler: @escaping ([String: Any]?, Error?) -> Void ) {
        
        /* let json: [String: Any] = ["UserID": user.UserID] */
         
        //
        
        var json1 :Any! = nil
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            json1 = try JSONSerialization.jsonObject(with: jsonData, options: [])
            
        } catch {
            print(error.localizedDescription)
        }

        let jsonData = try? JSONSerialization.data(withJSONObject: json1!)
        
        /*
        var request: URLRequest?
        if let url = URL(string: Constants.baseApiURL + str) {
            request = URLRequest(url: url)
            request?.httpMethod = "GET"
        }*/
        var request: URLRequest?
        if let url = URL(string: Constants.baseApiURL + urlString) {
            request = URLRequest(url: url)
            request?.httpMethod = "POST"
            request?.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request?.addValue((UserDefaults.standard.value(forKey: "latestSettings")! as! NSDictionary).value(forKey: "token")! as! String, forHTTPHeaderField: "Authorization")
            request?.httpBody = jsonData
        }
        
        
        self.sendRequest(request: request, onCompletion: { (data, err) -> Void in
            if err == nil,
                let data = data {
                do {
                    if let responseDictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        completionHandler(responseDictionary, nil)
                    }
                } catch {
                    completionHandler(nil, error)
                }
            } else {
                completionHandler(nil, err)
            }
        })
    }
}
