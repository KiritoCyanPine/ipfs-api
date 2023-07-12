//
//  lsFiles.swift
//  
//
//  Created by Debasish Nandi on 16/06/23.
//

public struct LsFile: Codable {
    public var Entries : [File]?
}

public struct File: Codable {
    public var Name:String
    public var Hash:String?
    public var Size:UInt64?
    public var `Type`: UInt8
    
    public init(Name: String, Hash: String? = nil, Size: UInt64? = nil, type:UInt8) {
        self.Name = Name
        self.Hash = Hash
        self.Size = Size
        self.Type = type
    }
}
