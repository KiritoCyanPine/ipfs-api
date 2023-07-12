//
//  File.swift
//  
//
//  Created by Debasish Nandi on 11/07/23.
//

import Foundation

@available(macOS 12.0, *)
public func FilesReadDownload(filepath: String, file:URL, completion: @escaping (Error?) -> Void ) async throws {
    var req:Request
    
    req = LocalRequest(path: "files/read")
        .set(Method: .POST)
        .set(Args: filepath)
    
    do {
        let request:URLRequest = try req.build()
    
        let task = URLSession.shared.downloadTask(with: request) {
                (tempURL, response, error) in
                // Early exit on error
                guard let tempURL = tempURL else {
                    completion(error)
                    return
                }

                do {
                    // Remove any existing document at file
                    if FileManager.default.fileExists(atPath: file.path) {
                        try FileManager.default.removeItem(at: file)
                    }

                    // Copy the tempURL to file
                    try FileManager.default.copyItem(
                        at: tempURL,
                        to: file
                    )

                    completion(nil)
                }

                // Handle potential file system errors
                catch {
                    completion(error)
                }
            }

            task.resume()
    } catch {
        throw error
    }
}
