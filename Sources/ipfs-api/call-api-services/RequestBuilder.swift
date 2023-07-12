//
//  RequestBuilder.swift
//  
//
//  Created by Debasish Nandi on 16/06/23.
//

import Foundation

enum RequestErrors:Error{
    case RequestArgCountIsZero
    case RequestCannotBeGenerated
}

public class Request {
    var baseURL:URL
    var Method: HTTPMethod = .POST
    var Path:String
    var Args:[String]?
    var Headers: [String: Any]?
    var Options: [String: String]?
    var Body: Data?
    
    public init(url:String, path:String) {
        let urlpath = URL(string: url)
        
        self.baseURL = (urlpath)!
        self.Path = path
    }
    
    public func set(Method:HTTPMethod) -> Request{
        self.Method = Method

        return self
    }
    
    public func set(Args:String...) -> Request{
        self.Args = Args
        
        return self
    }
    
    public func set(Headers: [String: Any]?) -> Request{
        self.Headers = Headers
        
        return self
    }
    
    public func set(Options: [String: String]?) -> Request{
        self.Options = Options
        
        return self
    }
    
    public func set(Body: Data?) -> Request{
        self.Body = Body
        
        return self
    }
    
    public func build() throws -> URLRequest {
        
        var urlComp = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        
        if let arguments = Args {
            if arguments.count == 0 {
                throw RequestErrors.RequestArgCountIsZero
            }
            
            var querryItems:[URLQueryItem]=[]
            
            arguments.forEach { arg in
                querryItems.append(URLQueryItem(name: "arg", value: arg))
            }
            
            urlComp?.queryItems = querryItems
        }
        
        if let options = Options {
            if options.count == 0 {
                throw RequestErrors.RequestArgCountIsZero
            }
            
            var querryItems = urlComp?.queryItems
            
            options.forEach { (key,value) in
                querryItems?.append(URLQueryItem(name: key, value: value))
            }
            
            urlComp?.queryItems = querryItems
        }
        
        guard let finalURL = urlComp?.url else {
            fatalError("Failed to create the final URL")
        }
        
        var newRequest = URLRequest(url:finalURL.appendingPathComponent(self.Path))
        
        newRequest.httpMethod = Method.rawValue
        
        Headers?.forEach({ (key, value) in
            newRequest.addValue(value as! String, forHTTPHeaderField: key)
        })
        
        newRequest.httpBody = self.Body
        
        return newRequest
    }
}

public class LocalRequest : Request {
    let localhost:String = "http://localhost:5001/api/v0/"
    
    public init(path: String) {
        super.init(url: localhost, path: path)
    }
}
