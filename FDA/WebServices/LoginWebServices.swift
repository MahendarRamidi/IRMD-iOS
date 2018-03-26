//
//  LoginWebServices.swift
//  FDA
//
//  Created by Mahendar on 8/6/17.
//  Copyright © 2017 Mahendar. All rights reserved.
//

import UIKit

class LoginWebServices: BaseOperation {
    
    func getAllUsers(_ completionHandler: @escaping ([String: Any]?, Error?) -> Void ) {
        let urlString = "http://52.5.157.28:8080/imagerecognition-web/mdiruser/login/email/m@m.com/password/123"
        var request: URLRequest?
        if let url = URL(string: urlString) {
            request = URLRequest(url: url)
            request?.httpMethod = "GET"
            request?.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
        self.sendRequest(request: request, onCompletion: { (data, err) -> Void in
            if err == nil,
                let data = data {
                do {
                    if let responseDictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject] {
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
    
    func getUserRoleByToken(_ json : Dictionary<String, Any>, _ completionHandler: @escaping ([String: Any]?, Error?) -> Void ) {
        
        var request: URLRequest?
        if let url = URL(string: Constants.baseApiURL + Constants.getUserRoleByToken + (json["token"]  as! String)) {
            request = URLRequest(url: url)
            request?.httpMethod = "GET"
            request?.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
        
        self.sendRequest(request: request, onCompletion: { (data, err) -> Void in
            if err == nil,
                let data = data {
                do {
                    if let responseDictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject] {
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

    
    
    func loginUser(_ user : User, _ completionHandler: @escaping ([String: Any]?, Error?) -> Void ) {
        
      /*  let json: [String: Any] = ["userName": user.email,
                                       "password": user.password]
            
       let jsonData = try? JSONSerialization.data(withJSONObject: json) */
        
        
        
        var request: URLRequest?
        if let url = URL(string: Constants.baseApiURL + Constants.login + "email" + "/\(user.email!)" + "/password" + "/\(user.password!)") {
            request = URLRequest(url: url)
            request?.httpMethod = "GET"
            request?.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
        
        
        
/*      var request: URLRequest?
        if let url = URL(string: Constants.baseApiURL + Constants.login) {
            request = URLRequest(url: url)
            request?.httpMethod = "POST"
            request?.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request?.httpBody = jsonData
            
        } */
 
        
        self.sendRequest(request: request, onCompletion: { (data, err) -> Void in
            if err == nil,
                let data = data {
                do {
                    if let responseDictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject] {
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
