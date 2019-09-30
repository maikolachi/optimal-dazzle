//
//  ImageDownloadOperation.swift
//  Optimal Dazzle
//
//  Created by Faisal Bhombal on 9/28/19.
//  Copyright © 2019 Bhombal. All rights reserved.
//

import Foundation

/***
 Operation queued when an image has to be downloaded. Checks if it is in the cache first. Downloads and signals
 with callback if download was ncessary. 
 */

class ImageDownloadOperation: Operation {
    
    private let fileName: String
    private let imageUrl: URL
    static var path: String = ""
    private let eventId: Int64
    
    var onComplete: ((Int64, Data) -> Void)?
    
    init(fileName: String, imageUrl: URL, eventId: Int64)   {
        self.fileName = fileName
        self.imageUrl = imageUrl
        self.eventId = eventId
    }
    
    override func main() {
        let url = NSURL(fileURLWithPath: ImageDownloadOperation.path)
        if let pathUrl = url.appendingPathComponent(self.fileName) {
            let filePath = pathUrl.path
            if FileManager.default.fileExists(atPath: filePath) {
                // print("Available: \(filePath)")
            } else {
                // Fetch the file
                guard
                    let imageData = try? Data(contentsOf: self.imageUrl) else {
                        return
                }
                do {
                    try imageData.write(to: pathUrl)
                    self.onComplete?(self.eventId, imageData)
                } catch {
//                    print("Caching crashed \(filePath)")
                }
                // Image returned save to file
            }
        } else {
//            print("FILE PATH NOT AVAILABLE")
        }
    }
}
