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
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw RequestError.InvalidURLResponse
        }
        
        let decoder = JSONDecoder()
        
        return try decoder.decode(FileStat.self, from: data)
    } catch {
        throw error
    }
}
