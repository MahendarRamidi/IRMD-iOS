//
//  updateTrayPictureWebservice.swift
//  FDA
//
//  Created by Kaustubh on 18/08/17.
//  Copyright © 2017 Aditya. All rights reserved.
//

import UIKit

class updateTrayPictureWebservice: BaseOperation {

    
    func postTrayImage(_ json : Dictionary<String, Any>,_ urlString : String,_ chosenImage : UIImage, _ completionHandler: @escaping ([String: Any]?, Error?) -> Void ) {
        
        //let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var request: URLRequest?
         if let url = URL(string: Constants.baseApiURL + urlString) {
            
            request = URLRequest(url: url)
            request?.httpMethod = "POST"
            
            let boundary = "Boundary-\(UUID().uuidString)"
            request?.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            let data = createBody(parameters: json as! [String : String],
                       boundary: boundary,
                       data: UIImageJPEGRepresentation(chosenImage, 0.7)!,
                       mimeType: "image/jpg",
                       filename: "file1.jpg")
            
            request?.httpBody = data
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
    
    
    func processImage(_ json : Dictionary<String, Any>,_ urlString : String, _ completionHandler: @escaping ([String:Any]?, Error?) -> Void ) {
        
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var request: URLRequest?
        if let url = URL(string: urlString) {
            request = URLRequest(url: url)
            request?.httpMethod = "POST"
            request?.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request?.httpBody = jsonData!
            request?.cachePolicy = .useProtocolCachePolicy
            request?.timeoutInterval = 10.0
        }
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


    
    
    func createBody(parameters: [String: String],
                    boundary: String,
                    data: Data,
                    mimeType: String,
                    filename: String) -> Data {
        let body = NSMutableData()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"file1\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        
        return body as Data
    }

}

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
