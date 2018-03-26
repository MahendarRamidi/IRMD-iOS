//
//  SessionManager.swift
//  Sesame
//
//  Created by Mahendar on 8/6/17.
//  Copyright © 2017 Mahendar. All rights reserved.
//

import Foundation

class SessionManager {
    
    static let `default`: SessionManager = {
        let configuration = URLSessionConfiguration.default
//        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
        return SessionManager(configuration: configuration)
    }()
        

    let session: URLSession
    
    public init(configuration: URLSessionConfiguration = URLSessionConfiguration.default)
    {
        self.session = URLSession(configuration: configuration)
    }
    
    deinit {
        session.invalidateAndCancel()
    }
}
