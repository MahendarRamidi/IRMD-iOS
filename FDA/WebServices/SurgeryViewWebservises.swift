//
//  SurgeryViewWebservises.swift
//  FDA
//
//  Created by on 10/08/17.
//  Copyright © 2017 Aditya. All rights reserved.
//

import UIKit

class SurgeryViewWebservises: BaseOperation {
    
    func getListing(_ user : User,_ urlString : String, _ completionHandler: @escaping ([[String: Any]]?, Error?) -> Void ) {
        
        //let json: [String: Any] = ["UserID": user.UserID]
        
        //let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var request: URLRequest?
        if let url = URL(string: Constants.baseApiURL + urlString) {
            request = URLRequest(url: url)
            request?.httpMethod = "GET"
            //request?.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            //request?.httpBody = jsonData
        }
        self.sendRequest(request: request, onCompletion: { (data, err) -> Void in
            if err == nil,
                let data = data {
                do {
                    if let responseDictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] {
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
    
    
    func getTrayListing(_ json : Dictionary<String, Any>,_ urlString : String, _ completionHandler: @escaping ([[String: Any]]?, Error?) -> Void ) {
        
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
            
//            str = Constants.getcasedates + "/\(json[Constants.kpatientId]  as! String)" + "/\(json[Constants.ksurgeonName] as! String)" + "/\(dateString.substring(to: endIndex))"
            
            let dateString = (json["date"] as! String).replacingOccurrences(of: " ", with: "%20")
            
            
            
            str = Constants.getAllSurgery +  "/\(json[Constants.kpatientId]  as! String)" + "/\(json[Constants.ksurgeonName] as! String)" + "/\(dateString)"
            
            break
            
            
        case Constants.getrelatedcasedetails:
            
            let dateString = (json["date"] as! String).replacingOccurrences(of: " ", with: "%20")
            
            
            
            str = Constants.getrelatedcasedetails +  "/\(json[Constants.kpatientId]  as! String)" + "/\(json[Constants.ksurgeonName] as! String)" + "/\(dateString)" + "/\(json[Constants.ksurgeryTypeId] as! String)"
            
            break
            
            
        case Constants.getTrayById:
            
            let dateString = (json["date"] as! String).replacingOccurrences(of: " ", with: "%20")
            
            
            str = Constants.getTrayById + "/\(json[Constants.kpatientId]  as! String)" + "/\(json[Constants.ksurgeonName] as! String)" + "/\(dateString)" + "/\(json[Constants.ksurgeryTypeId] as! String)"
            break
            
        case Constants.getsearchtraybyid:
            
            str = Constants.getsearchtraybyid + "/\(json[Constants.kstrtrayId]  as! String)"
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
                    if let responseDictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] {
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

    
    func getSurgeonsListing(_ json : Dictionary<String, Any>,_ urlString : String, _ completionHandler: @escaping ([String]?, Error?) -> Void ) {
        
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
            
            str = Constants.getAllSurgery + "/surgeonId" + "\(json["surgeonId"]  as! String)"
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
                    if let responseDictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String] {
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
    
    
    
    func getScanPatient(_ json : Dictionary<String, Any>,_ urlString : String, _ completionHandler: @escaping ([String: Any]?, Error?) -> Void ) {
        
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
            
            //            str = Constants.getcasedates + "/\(json[Constants.kpatientId]  as! String)" + "/\(json[Constants.ksurgeonName] as! String)" + "/\(dateString.substring(to: endIndex))"
            
            let dateString = (json["date"] as! String).replacingOccurrences(of: " ", with: "%20")
            let endIndex = dateString.index(dateString.endIndex, offsetBy: -2)
            
            str = Constants.getAllSurgery +  "/\(json[Constants.kpatientId]  as! String)" + "/\(json[Constants.ksurgeonName] as! String)" + "/\(dateString.substring(to: endIndex))"
            
            break
            
        case Constants.getTrayById:
            
            let dateString = (json["date"] as! String).replacingOccurrences(of: " ", with: "%20")
            let endIndex = dateString.index(dateString.endIndex, offsetBy: -2)
            
            str = Constants.getTrayById + "/\(json[Constants.kpatientId]  as! String)" + "/\(json[Constants.ksurgeonName] as! String)" + "/\(dateString.substring(to: endIndex))" + "/\(json[Constants.ksurgeryTypeId] as! String)"
            break
            
        case Constants.getsearchtraybyid:
            
            str = Constants.getsearchtraybyid + "/\(json[Constants.kstrtrayId]!)"
            break
            
        case Constants.ksearchtraybytraynumber:
            
            str = Constants.ksearchtraybytraynumber + "/\(json[Constants.kstrtrayId]!)"
            break
            
        case Constants.ksearchtraybynumberforassigntray:
            
            str = Constants.ksearchtraybynumberforassigntray + "/\(json[Constants.kstrtrayId]!)"
            break
            
        case Constants.getsearchtraybybarcode:
            
            str = Constants.getsearchtraybybarcode + "/\(json[Constants.kstrtrayId]!)"
            break

        case Constants.ksearchtraybybarcodeforassembletray:
            
            str = Constants.ksearchtraybybarcodeforassembletray + "/\(json[Constants.kstrtrayId]!)"
            break

        case Constants.ksearchtraybybarcodeforassigntray:
            
            str = Constants.ksearchtraybybarcodeforassigntray + "/\(json[Constants.kstrtrayId]!)"
            break
            
        case Constants.getscrewsdetailsbyassemblyid:
            
            str = Constants.getscrewsdetailsbyassemblyid + "/\(json[Constants.kstrtrayId]!)"
            break
        
        case Constants.ksearchcashidfortrayid:
            
            str = Constants.ksearchcashidfortrayid + "/\(json[Constants.kstrtrayId]!)"
            break
            
        case Constants.ksearchimplantybybarcode:
            
            let trayType = "/\(json["type"]!)".replacingOccurrences(of: " ", with: "%20")
            str = Constants.ksearchimplantybybarcode + "/\(json[Constants.kstrtrayId]!)" + trayType
            break
            
        default:
            str = ""
        }
        
        
        
        var request: URLRequest?
        if let url = URL(string: Constants.baseApiURL + str)
        {
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

    func getCaseDetails(_ json : Dictionary<String, Any>,_ urlString : String, _ completionHandler: @escaping ([String: Any]?, Error?) -> Void ) {
        
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
            
            //            str = Constants.getcasedates + "/\(json[Constants.kpatientId]  as! String)" + "/\(json[Constants.ksurgeonName] as! String)" + "/\(dateString.substring(to: endIndex))"
            
            let dateString = (json["date"] as! String).replacingOccurrences(of: " ", with: "%20")
            
            
            
            str = Constants.getAllSurgery +  "/\(json[Constants.kpatientId]  as! String)" + "/\(json[Constants.ksurgeonName] as! String)" + "/\(dateString)"
            
            break
            
            
        case Constants.getrelatedcasedetails:
            
            let dateString = (json["date"] as! String).replacingOccurrences(of: " ", with: "%20")
            
            
            
            str = Constants.getrelatedcasedetails +  "/\(json[Constants.kpatientId]  as! String)" + "/\(json[Constants.ksurgeonName] as! String)" + "/\(dateString)" + "/\(json[Constants.ksurgeryTypeId] as! String)"
            
            break
            
            
        case Constants.getTrayById:
            
            let dateString = (json["date"] as! String).replacingOccurrences(of: " ", with: "%20")
            
            
            str = Constants.getTrayById + "/\(json[Constants.kpatientId]  as! String)" + "/\(json[Constants.ksurgeonName] as! String)" + "/\(dateString)" + "/\(json[Constants.ksurgeryTypeId] as! String)"
            break
            
        case Constants.getsearchtraybyid:
            
            str = Constants.getsearchtraybyid + "/\(json[Constants.kstrtrayId]  as! String)"
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
