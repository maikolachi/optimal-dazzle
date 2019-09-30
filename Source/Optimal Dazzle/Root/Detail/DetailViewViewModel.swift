//
//  DetailViewViewModel.swift
//  Optimal Dazzle
//
//  Created by Faisal Bhombal on 9/29/19.
//  Copyright © 2019 Bhombal. All rights reserved.
//

import Foundation

class DetailViewViewModel {
    
    /***
        We already have the image (Should) so return it from the cache. Can probably make it more robust
        to do another regtrieve in case the image to display in detail is larger. But not the case now..
     ***/
    
    func image(forEvent event: EventModel) -> Data?  {
        let url = NSURL(fileURLWithPath: ImageDownloadOperation.path)
        guard let pathUrl = url.appendingPathComponent(event.imageHash) else {
            print("File path unavailable in detail")
            return nil
        }
        
        if FileManager.default.fileExists(atPath: pathUrl.path) {
            do {
                let imageData = try Data(contentsOf: pathUrl)
                if !imageData.isEmpty {
                    return imageData
                } else {
                    return nil
                }
            } catch {
                return nil
            }
        }
        return nil
    }
}
