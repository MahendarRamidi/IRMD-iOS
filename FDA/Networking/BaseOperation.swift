//
//  BaseOperation.swift
//  Sesame
//
//  Created by Mahendar on 8/6/17.
//  Copyright © 2017 Mahendar. All rights reserved.
//
import UIKit

public typealias OperationCompletionHandler = (Data?, Error?) -> Void
enum BaseOperationError: Error {
    case error(reason: String)
    case missingServerConfig
}

class BaseOperation: NSObject {
    
    var completionHandler : OperationCompletionHandler!

    func sendRequest(request : URLRequest? ,onCompletion compHandler : @escaping OperationCompletionHandler){
        completionHandler = compHandler

        // Dummy JSON Mode : Just pass the request nil and add a dummy JSON and
        // override getDummyJsonName method returning name of the JSON
        // else it sends an actual request
        if request == nil{
            let file = Bundle.main.path(forResource: self.getDummyJsonName(), ofType: Constants.kjson)
            let url = URL(fileURLWithPath: file!)
            let data = try? Data(contentsOf: url)
            self.completionHandler(data,nil)
        }
        else {
		if let error = self.reachabilityCheck() {
                    DispatchQueue.main.async {
                        self.completionHandler(nil, error)
                    }
                    return
                }
            let task1 = SessionManager.default.session.dataTask(with: request! as URLRequest) {
                data, response, error in
                if error == nil {
                    if let unwrappedData = data, let responseString = String(data: unwrappedData, encoding: String.Encoding.utf8){
                        print("BaseOperation: sendRequest: responseString: " + responseString)
                        do {
                            let json = try JSONSerialization.jsonObject(with: unwrappedData, options: JSONSerialization.ReadingOptions()) as? [String: AnyObject]
                            if json?["status"] as? NSNumber == 400 {
                                let message = json?["message"] as? String
                                let error = NSError(domain: "APPLEVEL", code: 400, userInfo: [NSLocalizedDescriptionKey: message ?? "Invalid session Id"])
                                DispatchQueue.main.async {
                                    self.completionHandler(nil, error as Error)
                                    return
                                }
                            }
                            
                        } catch { }
                        
                        
                        
                        
                        
                        DispatchQueue.main.async {
                            self.completionHandler(data, nil)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.completionHandler(nil, error)
                    }
                }

                }
            task1.resume()
        }
    }
    
    func sendDownloadRequest(request : URLRequest? ,onCompletion compHandler : @escaping OperationCompletionHandler){
        completionHandler = compHandler
        
        // Dummy JSON Mode : Just pass the request nil and add a dummy JSON and
        // override getDummyJsonName method returning name of the JSON
        // else it sends an actual request
        if request == nil{
            let file = Bundle.main.path(forResource: self.getDummyJsonName(), ofType: Constants.kjson)
            let url = URL(fileURLWithPath: file!)
            let data = try? Data(contentsOf: url)
            self.completionHandler(data,nil)
        }
        else{
		if let error = self.reachabilityCheck() {
                    DispatchQueue.main.async {
                        self.completionHandler(nil, error)
                    }
                    return
                }
            let task1 = SessionManager.default.session.downloadTask(with: request!, completionHandler: {dataURL, response, error in
                if error == nil{
                    do{
                        let data : NSData = try NSData(contentsOf:dataURL!)
                        DispatchQueue.main.async {
                        self.completionHandler(data as Data,nil)
                        }
			return
                    }
                    catch{
                        print(error)
                    }
                }
                else{
			
                        DispatchQueue.main.async {
                            self.completionHandler(nil, error)
                        }
                        return                    
                }
            })
            
            task1.resume()
            
        }
    }
    
    
    func sendUploadRequest(request : URLRequest?, data:Data? ,onCompletion compHandler : @escaping OperationCompletionHandler){
        completionHandler = compHandler
        
        // Dummy JSON Mode : Just pass the request nil and add a dummy JSON and
        // override getDummyJsonName method returning name of the JSON
        // else it sends an actual request
        if request == nil{
            let file = Bundle.main.path(forResource: self.getDummyJsonName(), ofType: Constants.kjson)
            let url = URL(fileURLWithPath: file!)
            let data = try? Data(contentsOf: url)
            self.completionHandler(data,nil)
        }
        else{
		if let error = self.reachabilityCheck() {
                    DispatchQueue.main.async {
                        self.completionHandler(nil, error)
                    }
                    return
                }
            let task1 = SessionManager.default.session.uploadTask(with: request!, from: data,  completionHandler: {data, response, error in
                if error == nil{
                    DispatchQueue.main.async {
                        self.completionHandler(data,nil)
                    }
                }
                else{
                        DispatchQueue.main.async {
                            self.completionHandler(nil, error)
                        }
                        return
                    }
            })
            
            task1.resume()
            
        }
    }
private func reachabilityCheck() -> Error? {
            let reachability = Reachability.reachabilityForInternetConnection()
            let isReachable = Reachability.isReachable(reachability)
            if !isReachable() {
            }
            return nil
        }


    

    func getDummyJsonName() -> String{
        return ""
    }
    
}
