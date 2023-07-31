//
//  FilesRead.swift
//  
//
//  Created by Debasish Nandi on 03/07/23.
//

import Foundation

@available(macOS 12.0, *)
public func FilesRead(filepath: String, range: NSRange? = nil) async throws -> Data  {
    var req:Request
    
    req = LocalRequest(path: "files/read")
        .set(Method: .POST)
        .set(Args: filepath)
    
    if let range = range{
        var opts: [String : String] = [:]
        opts["offset"] = String(range.location)
        opts["count"] = String(range.length)
        req = req.set(Options: opts)
    }
    
    do {
        let request:URLRequest = try req.build()
        
        let (data ,response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw RequestError.InvalidURLResponse
        }
        
        guard response.statusCode == 200 else {
            throw RequestError.UnExpectedResponseStatus(response.statusCode, "")
        }
        
        return data
    } catch {
        throw error
    }
}
