//
//  RegistrationWebServices.swift
//  FDA
//
//  Created by Kaustubh on 11/08/17.
//  Copyright © 2017 Aditya. All rights reserved.
//

import UIKit

class RegistrationWebServices: BaseOperation {
    
     func registerUser(_ json : Dictionary<String, Any>,_ urlString : String, _ completionHandler: @escaping ([String: Any]?, Error?) -> Void ) {
        
        /* let json: [String: Any] = ["UserID": user.UserID]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json) */
      
        //let dicionaryForTray = ["firstName":txtFirstname.text!,"lastName":txtLastname.text!,"emailID":txtEmail.text!,"userName":"","password":txtPassword.text!] as Dictionary<String,Any>
        
   
        
//        http://192.192.7.251:6565/imagerecognition-web/mdiruser/register/firstname/asd/lastname/asd/email/asd@asd.com/userName/ads/password/test
        
        var request: URLRequest?
        if let url = URL(string: Constants.baseApiURL
            + Constants.register
            + "email" + "/\(json["emailID"] as! String)"
            + "/password" + "/\(json["password"]  as! String)"
            + "/firstname" + "/\(json["firstName"] as! String)"
            + "/lastname" + "/\(json["lastName"]  as! String)"
            + "/role" + "/\(json["role"]  as! String)")
        {
            request = URLRequest(url: url)
            request?.httpMethod = "GET"
            request?.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
        
        
        /*var request: URLRequest?
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
    
    func getAllUserRole(_ urlString : String, _ completionHandler: @escaping ( [[String: AnyObject]]?, Error?) -> Void )
    {
        //        http://192.192.7.251:6565/imagerecognition-web/mdiruser/register/firstname/asd/lastname/asd/email/asd@asd.com/userName/ads/password/test
        
        var request: URLRequest?
        if let url = URL(string: Constants.baseApiURL
            + Constants.getalluserRole)
        {
            request = URLRequest(url: url)
            request?.httpMethod = "GET"
            request?.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
        
        self.sendRequest(request: request, onCompletion: { (data, err) -> Void in
            if err == nil,
                let data = data {
                do {
                    if let responseDictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: AnyObject]]
                    {
                        completionHandler(responseDictionary, nil)
                    }
                }
                catch
                {
                    completionHandler(nil, error)
                }
            } else {
                completionHandler(nil, err)
            }
        })
    }

}
