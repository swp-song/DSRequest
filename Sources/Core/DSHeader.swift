//
//  DSHeader.swift
//  DSRequest
//
//  Created by Dream on 2023/11/9.
//

import Foundation

/// URL Request Head
public struct DSHeader {

    /// Request Header name
    let name: String
    
    /// Request Header value
    let value : String
    
    
    /// `DSHeader` Initialization method
    /// - Parameters:
    ///   - name: Request Header name
    ///   - value: Request Header value
    public init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}

extension DSHeader: Hashable { }

extension DSHeader: CustomStringConvertible {
    
    /// Print information format `name: value`, `Content-Type: application/json"`
    public var description: String {
        "\(name): \(value)"
    }
}

// MARK: - DSHeader Packaging name set key
public extension DSHeader {
    
    /// Returns an `Accept` header.
    /// - Parameter value: `Accept` value.
    /// - Returns: DSHeader
    static func accept(_ value: String) -> DSHeader {
       DSHeader(name: "Accept", value: value)
    }
    
    /// Returns an `Accept-Charset` header.
    /// - Parameter value:  `Accept-Charset` value.
    /// - Returns: DSHeader
    static func acceptCharset(_ value: String) -> DSHeader {
       DSHeader(name: "Accept-Charset", value: value)
    }
    
    /// Returns an `Accept-Language` header.
    /// - Parameter value: `Accept-Language` value.
    /// - Returns:  DSHeader
    static func acceptLanguage(_ value: String) -> DSHeader {
       DSHeader(name: "Accept-Language", value: value)
    }
    
    /// Returns an `Accept-Encoding` header.
    /// - Parameter value: `Accept-Encoding` value.
    /// - Returns: DSHeader
    static func acceptEncoding(_ value: String) -> DSHeader {
       DSHeader(name: "Accept-Encoding", value: value)
    }
    
    ///  Returns a `Basic` `Authorization` header using the `username` and `password` provided.
    /// - Parameters:
    ///   - username: The username of the header.
    ///   - password: The password of the header.
    /// - Returns: DSHeader
    static func authorization(username: String, password: String) -> DSHeader {
        let credential = Data("\(username):\(password)".utf8).base64EncodedString()

        return authorization("Basic \(credential)")
    }
    
    /// Returns a `Bearer` `Authorization` header using the `bearerToken` provided
    /// - Parameter bearerToken: The bearer token.
    /// - Returns: DSHeader
    static func authorization(bearerToken: String) -> DSHeader {
        authorization("Bearer \(bearerToken)")
    }

    
    /// Returns an `Authorization` header.
    /// - Parameter value: The `Authorization` value.
    /// - Returns: DSHeader
    static func authorization(_ value: String) -> DSHeader {
       DSHeader(name: "Authorization", value: value)
    }
    
    ///  Returns a `Content-Disposition` header.
    /// - Parameter value: The `Content-Disposition` value.
    /// - Returns: DSHeader
    static func contentDisposition(_ value: String) -> DSHeader {
       DSHeader(name: "Content-Disposition", value: value)
    }
    
    /// Returns a `Content-Encoding` header.
    /// - Parameter value: The `Content-Encoding`.
    /// - Returns: DSHeader
    static func contentEncoding(_ value: String) -> DSHeader {
       DSHeader(name: "Content-Encoding", value: value)
    }
    
    /// Returns a `Content-Type` header.
    /// Provides `DSURLEncoding` and `DSJSONEncoding` resolution methods
    /// - Parameter value: `Content-Type` value.
    /// - Returns: DSHeader
    static func contentType(_ value: String) -> DSHeader {
       DSHeader(name: "Content-Type", value: value)
    }
  
    /// Returns a `User-Agent` header.
    /// - Parameter value: The `User-Agent` value.
    /// - Returns: DSHeader
    static func userAgent(_ value: String) -> DSHeader {
       DSHeader(name: "User-Agent", value: value)
    }
    
}
// MARK: -
