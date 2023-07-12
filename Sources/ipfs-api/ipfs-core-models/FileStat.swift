//
//  File.swift
//  
//
//  Created by Debasish Nandi on 06/07/23.
//

import Foundation

public struct FileStat: Codable{
    public var Blocks:UInt64
    public var CumulativeSize: UInt64
    public var Hash:String?
    public var Local: Bool?
    public var Size: UInt64?
    public var SizeLocal: UInt64?
    public var `Type`: String?
    public var WithLocality: Bool?
}
