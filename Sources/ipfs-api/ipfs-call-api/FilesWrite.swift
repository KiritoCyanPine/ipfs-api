//
//  File.swift
//  
//
//  Created by Debasish Nandi on 10/07/23.
//

import Foundation


@available(macOS 12.0, *)
public func FilesWrite(filepath: String, range: NSRange? = nil) async throws -> Data  {
    
    guard filepath != "" else {
        throw RequestError.InvalidFilePathForCommand
    }
    
    let boundary = UUID().uuidString
    let boundaryPrefix = "--\(boundary)\r\n"
    let boundarySuffix = "--\(boundary)--\r\n"
    
    let headers: [String:Any] = ["Content-Type":"multipart/form-data; boundary=\(boundary)"]
    
    var opts: [String : String] = [:]
    opts["create"] = "true"
    
    if let range = range{
        opts["offset"] = String(range.location)
        opts["count"] = String(range.length)
    }
    
    let body = GenerateHttpBody(boundaryPrefix: boundaryPrefix, boundarySuffix: boundarySuffix, filePath: filepath)
    
    let request = try LocalRequest(path: "files/write")
        .set(Method: .POST)
        .set(Args: filepath)
        .set(Headers: headers)
        .set(Body: body)
        .set(Options: opts)
        .build()
    
    do {        
        let (data ,response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw RequestError.InvalidURLResponse
        }
        
        return data
    } catch {
        throw error
    }
}

func GenerateHttpBody(boundaryPrefix:String, boundarySuffix:String, filePath:String) -> Data {
    
    // Create the multipart form data body
    var body = Data()
    body.append(boundaryPrefix.data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"file\"; file=\"\(filePath)\"\r\n".data(using: .utf8)!)
    body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
    
    guard let fileInputStream = InputStream(fileAtPath: filePath) else {
        print("Failed to open file input stream")
        return Data()
    }
    fileInputStream.open()
    
    // set data by chunksizes
    let bufferSize = 1024
    let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
    while fileInputStream.hasBytesAvailable {
        let bytesRead = fileInputStream.read(buffer, maxLength: bufferSize)
        if bytesRead < 0 {
            print("Error reading file")
            break
        }
        body.append(buffer, count: bytesRead)
    }
    
    buffer.deallocate()
    fileInputStream.close()
    
    // append the payload to body :Data()
    body.append(("\r\n"+boundarySuffix).data(using: .utf8)!)
    
    return body
}
