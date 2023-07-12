//
//  FilesList.swift
//  
//
//  Created by Debasish Nandi on 16/06/23.
//

import Foundation

@available(macOS 12.0, *)
public func FilesList(filepath: String = "") async throws -> LsFile {
    let req = try LocalRequest(path: "files/ls")
        .set(Method: .POST)
        .set(Args: filepath)
        .set(Options: ["l": "true"])
        .build()
    
    do {
        let (data ,response) = try await URLSession.shared.data(for: req)
 
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw RequestError.InvalidURLResponse
        }
        
        let decoder = JSONDecoder()
        
        return try decoder.decode(LsFile.self, from: data)
    } catch {
        throw error
    }
}
