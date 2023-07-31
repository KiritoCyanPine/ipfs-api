//
//  File.swift
//  
//
//  Created by Debasish Nandi on 31/07/23.
//

import Foundation

public struct FileInfoWSh :Codable {
    public var Name         :String
    public var Size         :Int64?
    public var IsDirectory  :Bool
    public var IsLocal      :Bool
    public var CreatedOn    :Float64
    public var ModifiedOn   :Float64
    public var EDEK         :String?
    public var Hash         :String?
    public var Pinned       :Bool
    public var CrossDomain  :Bool
    public var AccountId    :String?
    
    public init(Name: String, Size: Int64, IsDirectory: Bool, IsLocal: Bool, CreatedOn: Float64, ModifiedOn: Float64, EDEK: String, Hash: String, Pinned: Bool, CrossDomain: Bool, AccountId: String) {
        self.Name = Name
        self.Size = Size
        self.IsDirectory = IsDirectory
        self.IsLocal = IsLocal
        self.CreatedOn = CreatedOn
        self.ModifiedOn = ModifiedOn
        self.EDEK = EDEK
        self.Hash = Hash
        self.Pinned = Pinned
        self.CrossDomain = CrossDomain
        self.AccountId = AccountId
    }
}
