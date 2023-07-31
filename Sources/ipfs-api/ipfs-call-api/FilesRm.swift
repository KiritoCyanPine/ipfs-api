//
//  FilesRm.swift
//  
//
//  Created by Debasish Nandi on 24/07/23.
//

import Foundation

@available(macOS 12.0, *)
public func FilesRm(ipfspath:String) async throws {
    
    var opts: [String : String] = [:]
    opts["recursive"] = "true"
    opts["force"] = "true"
    
    let request = try LocalRequest(path: "files/rm")
        .set(Args: ipfspath)
        .set(Options: opts)
        .build()
    
    do {
        let (_ ,response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw RequestError.InvalidURLResponse
        }
        
        guard response.statusCode == 200 else {
            throw RequestError.UnExpectedResponseStatus(response.statusCode, "")
        }
        
    } catch {
        throw error
    }
}

public func FilesRm(ipfspath:String, completion: @escaping (Error?) -> Void) throws {
    
    var opts: [String : String] = [:]
    opts["recursive"] = "true"
    opts["force"] = "true"
    
    let request = try LocalRequest(path: "files/rm")
        .set(Args: ipfspath)
        .set(Options: opts)
        .build()
    
    let task = URLSession.shared.dataTask(with: request) { (dataOptional, responseOptional, errorOptional) in
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
    
    task.resume()
}
