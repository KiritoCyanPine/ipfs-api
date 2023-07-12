//
//  User.swift
//  
//
//  Created by Debasish Nandi on 16/06/23.
//

public struct GithubUser: Codable {
    public var login:String
    public var bio:String?
    public var avatar_url:String?
    public var id: UInt32
}
