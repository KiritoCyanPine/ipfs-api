//
//  GetUsers.swift
//  
//
//  Created by Debasish Nandi on 16/06/23.
//

import Foundation


@available(macOS 12.0, *)
public func GetUserDetails(user: String = "") async throws -> GithubUser {
    let req = try Request(url: "https://api.github.com/users", path: user)
        .set(Method: .GET)
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
        
        return try decoder.decode(GithubUser.self, from: data)
    } catch {
        throw error
    }
}
