//
//  File 2.swift
//  
//
//  Created by Debasish Nandi on 06/07/23.
//

import Foundation

@available(macOS 12.0, *)
public func FilesStat(filepath: String = "/") async throws -> FileStat {
    let req = try LocalRequest(path: "files/stat")
        .set(Method: .POST)
        .set(Args: filepath)
        .build()
    
    do {
        let (data ,response) = try await URLSession.shared.data(for: req)

        guard let response = response as? HTTPURLResponse else {
            throw RequestError.InvalidURLResponse
        }
        
        guard response.statusCode == 200 else {
            throw RequestError.UnExpectedResponseStatus(response.statusCode, String(data: data, encoding: String.Encoding.utf8 ) ?? "unknown error")
        }
        
        let decoder = JSONDecoder()
        
        return try decoder.decode(FileStat.self, from: data)
    } catch {
        throw error
    }
}


@available(macOS 12.0, *)
public func FilesStat(filepath: String = "/", completion: @escaping (FileStat?,Error?) -> Void) throws {
    let req = try LocalRequest(path: "files/stat")
        .set(Method: .POST)
        .set(Args: filepath)
        .build()
    
        let statTask = URLSession.shared.dataTask(with: req, completionHandler: {  (dataOptional, responseOptional, errorOptional) in
            
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
                let fstat = try decoder.decode(FileStat.self, from: data)
                
                completion(fstat, nil)
            } catch {
                completion(nil, RequestError.ErrOnDecoding)
            }
        })
    
    statTask.resume()
}
