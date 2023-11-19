//
//  URLRequest+Extension.swift
//  DSRequest
//
//  Created by Dream on 2023/11/9.
//

import Foundation

// MARK: - URLRequest
extension URLRequest {
    
    
    /// `URLRequest` Initialization method
    /// - Parameters:
    ///   - url:        Request `url`
    ///   - method:     Request `method`
    ///   - headers:    Request `headers`, [DSHeader]
    public init(url: String, method: DSMethod, headers: DSHeaders? = nil) throws {
        guard let url = URL(string: url) else {
            throw DSError.urlError
        }
        self.init(url: url)
        httpMethod = method.rawValue
        allHTTPHeaderFields = headers?.dictionary
    }
    
    
    /// Request method
    public var method: DSMethod? {
        get { 
            guard let httpMethod = httpMethod else { return nil }
            return DSMethod(rawValue: httpMethod)
        }
        set { 
            httpMethod = newValue?.rawValue
        }
    }
    
    
    /// Set the request header
    public var headers: DSHeaders {
        get { allHTTPHeaderFields.map(DSHeaders.init) ?? DSHeaders() }
        set { allHTTPHeaderFields = newValue.dictionary }
    }
    
}
// MARK: -
