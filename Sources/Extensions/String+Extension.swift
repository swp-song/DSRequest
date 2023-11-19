//
//  Collection+Extension.swift
//  DSRequest
//
//  Created by Dream on 2023/11/9.
//

import Foundation

// MARK: - Collection, Element == String
extension Collection where Element == String {
    
    
    /// Quality Encoded
    /// - Returns: Encoded String
    func qualityEncoded() -> String {
        enumerated().map { index, encoding in
            let quality = 1.0 - (Double(index) * 0.1)
            return "\(encoding);q=\(quality)"
        }.joined(separator: ", ")
    }
}
// MARK: -
