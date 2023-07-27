//
//  Errors.swift
//  
//
//  Created by Debasish Nandi on 16/06/23.
//

public enum RequestError:Error {
    case InvalidURLResponse
    case UnExpectedResponseStatus(Int,String)
    case ErrOnDecoding
    case InvalidFilePathForCommand
    case InvalidRequest(Error)
}
