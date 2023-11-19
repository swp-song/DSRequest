//
//  DSJSONEncoding.swift
//  DSRequest
//
//  Created by Dream on 2023/11/13.
//

import Foundation


/// JSON Encoding
public struct DSJSONEncoding {
    
    /// `DSJSONEncoding` Initialization `default`
    public static var `default`: DSJSONEncoding { DSJSONEncoding() }
    
    /// JSON Encoding, options = prettyPrinted
    public static var prettyPrinted: DSJSONEncoding { DSJSONEncoding(options: .prettyPrinted)  }

    /// JSON Encoding, options
    public let options: JSONSerialization.WritingOptions
        
    /// `DSJSONEncoding` Initialization method
    /// - Parameter options: Default = `.prettyPrinted`
    public init(options: JSONSerialization.WritingOptions = []) {
        self.options = options
    }
 
}

extension DSJSONEncoding: DSEncoding {
    
    /// URLRequest JSON encoding
    /// - Parameters:
    ///   - urlRequest: Coding `URLRequest`
    ///   - parameters: Coding `Parameters`, `DSParameters = [String: Any]`
    /// - Returns: The encoding completed URLRequest
    public func encode(_ urlRequest: URLRequest, with parameters: DSParameters?) throws -> URLRequest {
        
        guard let parameters = parameters else { return urlRequest }
        
        guard JSONSerialization.isValidJSONObject(parameters) else {
            throw DSError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: Error.invalidJSONObject))
        }
        
        var request = urlRequest
        
        do {
            let data = try JSONSerialization.data(withJSONObject: parameters, options: options)

            if request.headers["Content-Type"] == nil {
                request.headers.update(.contentType("application/json"))
            }

            request.httpBody = data
        } catch {
            throw DSError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
        }
        
        return request
    }
    
    
    /// URLRequest JSON encoding
    /// - Parameters:
    ///   - urlRequest: Coding `URLRequest`
    ///   - jsonObject: Coding `Parameters`,  `jsonObject` = Any
    /// - Returns: The encoding completed URLRequest
    public func encode(_ urlRequest: URLRequest, withJSONObject jsonObject: Any? = nil) throws -> URLRequest {
        
        guard let jsonObject = jsonObject else { return urlRequest }
        
        guard JSONSerialization.isValidJSONObject(jsonObject) else {
            throw DSError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: Error.invalidJSONObject))
        }
        
        var request = urlRequest
        
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: options)
            
            if request.headers["Content-Type"] == nil {
                request.headers.update(.contentType("application/json"))
            }
            request.httpBody = data
            
        } catch {
            throw DSError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
        }
        
        return request
    }
}


