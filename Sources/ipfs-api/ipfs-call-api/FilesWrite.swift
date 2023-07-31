//
//  FilesWrite.swift
//  
//
//  Created by Debasish Nandi on 10/07/23.
//

import Foundation

@available(macOS 12.0, *)
public func FilesWrite(filepath: String, data:Data, range: NSRange? = nil, truncate: Bool = false) async throws -> Data  {
    
    guard filepath != "" else {
        throw RequestError.InvalidFilePathForCommand
    }
    
    let boundary = UUID().uuidString
    
    let headers: [String:Any] = ["Content-Type":"multipart/form-data; boundary=\(boundary)"]
    
    var opts: [String : String] = [:]
    opts["create"] = "true"
    opts["parent"] = "true"
    opts["truncate"] = String(truncate)
    
    if let range = range{
        opts["offset"] = String(range.location)
        opts["count"] = String(range.length)
    }
    
    let body = GenerateHttpBody( with:data, boundary: boundary)
    
    let request = try LocalRequest(path: "files/write")
        .set(Method: .POST)
        .set(Args: filepath)
        .set(Headers: headers)
        .set(Body: body)
        .set(Options: opts)
        .build()
    
    do {
        let (data ,response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw RequestError.InvalidURLResponse
        }
        
        guard response.statusCode == 200 else {
            throw RequestError.UnExpectedResponseStatus(response.statusCode, "")
        }
        
        return data
    } catch {
        throw error
    }
}

public func FilesWrite(filepath: String, data:Data, range: NSRange? = nil, truncate:Bool = false, completion: @escaping (Error?) -> Void ) throws  {
    
    guard filepath != "" else {
        throw RequestError.InvalidFilePathForCommand
    }
    
    let boundary = UUID().uuidString
    
    let headers: [String:Any] = ["Content-Type":"multipart/form-data; boundary=\(boundary)"]
    
    var opts: [String : String] = [:]
    opts["create"] = "true"
    opts["parent"] = "true"
    opts["truncate"] = String(truncate)
    
    if let range = range{
        opts["offset"] = String(range.location)
        opts["count"] = String(range.length)
    }
    
    let body = GenerateHttpBody( with:data, boundary: boundary)
    
    let request = try LocalRequest(path: "files/write")
        .set(Method: .POST)
        .set(Args: filepath)
        .set(Headers: headers)
        .set(Body: body)
        .set(Options: opts)
        .build()
    
    let uploadTask = URLSession.shared.dataTask(with: request) { (dataOptional, responseOptional, errorOptional) in
        if let error = errorOptional {
            completion(RequestError.InvalidRequest(error))
            return
        }
        
        guard let response = responseOptional as? HTTPURLResponse else {
            completion(RequestError.InvalidURLResponse)
            return
        }
        
        guard response.statusCode == 200 else {
            completion(RequestError.UnExpectedResponseStatus(response.statusCode, ""))
            return
        }
        
        completion(nil)
    }
    
    uploadTask.resume()
}

func GenerateHttpBody(with data:Data, boundary:String) -> Data {
    let boundaryPrefix = "--\(boundary)\r\n"
    let boundarySuffix = "--\(boundary)--\r\n"
    
    var body = Data()
    body.append(boundaryPrefix.data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"file\"; file=\"file\"\r\n".data(using: .utf8)!)
    body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
    body.append(data)
    body.append(("\r\n"+boundarySuffix).data(using: .utf8)!)
    
    return body
}

