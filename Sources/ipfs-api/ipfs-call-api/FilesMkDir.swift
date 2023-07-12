//
//  File.swift
//  
//
//  Created by Debasish Nandi on 10/07/23.
//

import Foundation

@available(macOS 12.0, *)
public func FilesMkDir(filepath: String = "") async throws -> Data {
    let req = try LocalRequest(path: "files/mkdir")
        .set(Method: .POST)
        .set(Args: filepath)
        .set(Options: ["parents":"true"])
        .build()
    
    do {
        let (data ,response) = try await URLSession.shared.data(for: req)
        print(response, String(decoding: data, as: UTF8.self))
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw RequestError.InvalidURLResponse
        }
        
        return data
    } catch {
        throw error
    }
}