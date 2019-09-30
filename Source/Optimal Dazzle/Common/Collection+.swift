//
//  Collection+.swift
//  Optimal Dazzle
//
//  Created by Faisal Bhombal on 9/26/19.
//  Copyright © 2019 Bhombal. All rights reserved.
//

import Foundation

extension Collection {
    subscript (safe index: Index?) -> Element? {
        guard let index = index else {
            return nil
        }
        return indices.contains(index) ? self[index] : nil
    }
}
