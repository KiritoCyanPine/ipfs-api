//
//  File.swift
//  
//
//  Created by Debasish Nandi on 31/07/23.
//

import Foundation

@available(macOS 12.0, *)
public func FilesLswsh(filepath: String = "") async throws -> FileInfoWSh {
    let req = try LocalRequest(path: "files/lswsh")
        .set(Method: .POST)
        .set(Args: filepath)
        .set(Options: ["l": "true"])
        .build()
    
    do {
        let (data ,response) = try await URLSession.shared.data(for: req)
 
        guard let response = response as? HTTPURLResponse else {
            throw RequestError.InvalidURLResponse
        }
        
        guard response.statusCode == 200 else {
            throw RequestError.UnExpectedResponseStatus(response.statusCode, "")
        }
        
        let decoder = JSONDecoder()
        
        return try decoder.decode(FileInfoWSh.self, from: data)
    } catch {
        throw error
    }
}


public func FilesLswsh(filepath: String = "", completion: @escaping (FileInfoWSh? , Error?) -> Void) throws {
    let req = try LocalRequest(path: "files/lswsh")
        .set(Method: .POST)
        .set(Args: filepath)
        .set(Options: ["l": "true"])
        .build()
    
        let task = URLSession.shared.dataTask(with: req){ dataOptional, responseOptional, errorOptional in
            if let error = errorOptional {
                completion(nil,RequestError.InvalidRequest(error))
                return
            }
            
            guard let response = responseOptional as? HTTPURLResponse else {
                completion(nil,RequestError.InvalidURLResponse)
                return
            }
            
            guard response.statusCode == 200 else {
                completion(nil,RequestError.UnExpectedResponseStatus(response.statusCode, ""))
                return
            }
            
            guard let data = dataOptional else {
                completion(nil,RequestError.InvalidURLResponse)
                return
            }
        
            do {
                let decoder = JSONDecoder()
                let fstat = try decoder.decode(FileInfoWSh.self, from: data)
                
                completion(fstat, nil)
            } catch {
                completion(nil, RequestError.ErrOnDecoding)
            }
        }
                                                  
        task.resume()
}
