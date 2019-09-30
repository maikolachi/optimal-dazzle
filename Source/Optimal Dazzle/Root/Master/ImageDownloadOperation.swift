//
//  ImageDownloadOperation.swift
//  Optimal Dazzle
//
//  Created by Faisal Bhombal on 9/28/19.
//  Copyright © 2019 Bhombal. All rights reserved.
//

import Foundation

/***
    Operation to download the image if it is not already in the document cache. Queue
    runns without any callbacks.
 
    Assumption: A image url is never updated, a new url may be created for an event
 */

class ImageDownloadOperation: Operation {
    
    private let fileName: String
    private let imageUrl: URL
    static var path: String = ""
    private let eventId: UInt
    
    var onComplete: ((UInt, Data) -> Void)?
    
    init(fileName: String, imageUrl: URL, eventId: UInt)   {
        self.fileName = fileName
        self.imageUrl = imageUrl
        self.eventId = eventId
    }
    
    override func main() {
        let url = NSURL(fileURLWithPath: ImageDownloadOperation.path)
        if let pathUrl = url.appendingPathComponent(self.fileName) {
            let filePath = pathUrl.path
            if FileManager.default.fileExists(atPath: filePath) {
                print("Available: \(filePath)")
            } else {
                // Fetch the file
                guard
                    let imageData = try? Data(contentsOf: self.imageUrl) else {
                        return
                }
                do {
                    try imageData.write(to: pathUrl)
                    print("Cached: \(filePath)")
                    self.onComplete?(self.eventId, imageData)
                } catch {
                    print("Caching crashed \(filePath)")
                }
                // Image returned save to file
            }
        } else {
            print("FILE PATH NOT AVAILABLE")
        }
    }
}
