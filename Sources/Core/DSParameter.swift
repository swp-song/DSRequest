//
//  DSParameters.swift
//  DSRequest
//
//  Created by Dream on 2023/11/9.
//

import Foundation


/// Request Parameters
public typealias DSParameters = [String: Any]

/// Request parameter coding protocol
public protocol DSEncoding  {
    
    /// URLRequest for encoding
    /// - Parameters:
    ///   - urlRequest: Coding `URLRequest`
    ///   - parameters: Coding `Parameters`, `DSParameters = [String: Any]`
    /// - Returns: The encoding completed URLRequest
    func encode(_ urlRequest: URLRequest, with parameters: DSParameters?) throws -> URLRequest
}
