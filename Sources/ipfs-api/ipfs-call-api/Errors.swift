//
//  Errors.swift
//  
//
//  Created by Debasish Nandi on 16/06/23.
//

public enum RequestError:Error {
    case InvalidURLResponse
    case ErrOnDecoding
    case InvalidFilePathForCommand
}
