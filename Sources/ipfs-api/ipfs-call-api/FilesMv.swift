//
//  FilesMv.swift
//  
//
//  Created by Debasish Nandi on 23/07/23.
//

import Foundation

@available(macOS 12.0, *)
public func FilesMv(src:String,dst:String, completion: @escaping (Error?) -> Void) async throws{
    let request = try LocalRequest(path: "files/mv")
        .set(Args: src, dst)
        .build()
    
    let uploadTask = URLSession.shared.dataTask(with: request) { (dataOptional, responseOptional, errorOptional) in
        if let error = errorOptional {
            completion(RequestError.InvalidRequest(error))
            return
        }
        
        guard let response = responseOptional as? HTTPURLResponse else {
            completion(RequestError.InvalidURLResponse)
            return
        }
        
        guard response.statusCode == 200 else {
            completion(RequestError.UnExpectedResponseStatus(response.statusCode, ""))
            return
        }
        
        completion(nil)
    }
    
    uploadTask.resume()
}
