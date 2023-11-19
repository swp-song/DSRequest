//
//  URLEncoding.swift
//  DSRequest
//
//  Created by Dream on 2023/11/13.
//

import Foundation

/// URL Encodeing
public struct DSURLEncoding {
    
    /// Returns a default `URLEncoding` instance with a `.methodDependent` destination.
    public static var `default`: DSURLEncoding { DSURLEncoding() }
    
    /// Returns a `URLEncoding` instance with a `.queryString` destination.
    public static var queryString: DSURLEncoding { DSURLEncoding(destination: .queryString) }
    
    /// Returns a `URLEncoding` instance with an `.httpBody` destination.
    public static var httpBody: DSURLEncoding { DSURLEncoding(destination: .httpBody) }
    
    /// The destination defining where the encoded query string is to be applied to the URL request.
    var destination: Destination
    
    /// The encoding to use for `Array` parameters.
    public var arrayEncoding: ArrayEncoding
    
    /// The encoding to use for `Bool` parameters.
    public var boolEncoding: BoolEncoding
    
    
    /// `DSURLEncoding` Initialization method
    /// - Parameters:
    ///   - destination:    The destination defining where the encoded query string is to be applied to the URL request.
    ///   - arrayEncoding:  The encoding to use for `Array` parameters.
    ///   - boolEncoding:   The encoding to use for `Bool` parameters.
    public init(destination: Destination = .methodDependent, arrayEncoding: ArrayEncoding = .brackets, boolEncoding: BoolEncoding = .numeric) {
        self.destination    = destination
        self.arrayEncoding  = arrayEncoding
        self.boolEncoding   = boolEncoding
    }
    
}

public extension DSURLEncoding {

    /// Defines whether the url-encoded query string is applied to the existing query string or HTTP body of the
    /// resulting URL request.
    enum Destination {
        
        /// Applies encoded query string result to existing query string for `GET`, `HEAD` and `DELETE` requests and
        /// sets as the HTTP body for requests with any other HTTP method.
        case methodDependent
         
        /// Sets or appends encoded query string result to existing query string.
        case queryString
        
        /// Sets encoded query string result as the HTTP body of the URL request.
        case httpBody
        
        
        /// Method of Judging Request
        /// - Parameter method:`get`, `post` DSMethod
        /// - Returns: contains
        func encodesParametersInURL(for method: DSMethod) -> Bool {
            switch self {
            case .methodDependent:
                return [DSMethod.get].contains(method)
            case .queryString:
                return true
            case .httpBody:
                return false
            }
        }
    }
    
    /// Configures how `Array` parameters are encoded.
    enum ArrayEncoding {
        
        /// An empty set of square brackets is appended to the key for every value. This is the default behavior.
        case brackets
        /// No brackets are appended. The key is encoded as is.
        case noBrackets
        /// Brackets containing the item index are appended. This matches the jQuery and Node.js behavior.
        case indexInBrackets
        /// Provide a custom array key encoding with the given closure.
        case custom((_ key: String, _ index: Int) -> String)

        func encode(key: String, atIndex index: Int) -> String {
            switch self {
            case .brackets:
                return "\(key)[]"
            case .noBrackets:
                return key
            case .indexInBrackets:
                return "\(key)[\(index)]"
            case let .custom(encoding):
                return encoding(key, index)
            }
        }
    }
    
    /// Configures how `Bool` parameters are encoded.
    enum BoolEncoding {
        /// Encode `true` as `1` and `false` as `0`. This is the default behavior.
        case numeric
        /// Encode `true` and `false` as string literals.
        case literal

        func encode(value: Bool) -> String {
            switch self {
            case .numeric:
                return value ? "1" : "0"
            case .literal:
                return value ? "true" : "false"
            }
        }
    }
}


extension DSURLEncoding: DSEncoding {
    
    
    /// URLRequest for encoding
    /// - Parameters:
    ///   - urlRequest: Coding `URLRequest`
    ///   - parameters: Coding `Parameters`, `DSParameters = [String: Any]`
    /// - Returns: The encoding completed URLRequest
    public func encode(_ urlRequest: URLRequest, with parameters: DSParameters?) throws -> URLRequest {
        
        guard let parameters = parameters else { return urlRequest }
        
        var request = urlRequest
        
        if let method = request.method, destination.encodesParametersInURL(for: method) {
            guard let url = request.url else {
                throw DSError.parameterEncodingFailed(reason: .missingURL)
            }
            
            if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
                let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameters)
                urlComponents.percentEncodedQuery = percentEncodedQuery
                request.url = urlComponents.url
            }
        } else {
            if request.headers["Content-Type"] == nil {
                request.headers.update(.contentType("application/x-www-form-urlencoded; charset=utf-8"))
            }

            request.httpBody = Data(query(parameters).utf8)
        }
        return request
    }
    
}

extension DSURLEncoding {
    
    
    /// Create a group percent-escaped, URL encoded query string components from the given key-value pair recursively.
    /// - Parameter parameters: [String: Any]
    /// - Returns:
    private func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
    
    /// Creates a percent-escaped, URL encoded query string components from the given key-value pair recursively.
    /// - Parameters:
    ///   - key:    Key of the query component.
    ///   - value:  Value of the query component.
    /// - Returns: The percent-escaped, URL encoded query string components.
    public func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        
        switch value {
        case let dictionary as [String: Any]:
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        case let array as [Any]:
            for (index, value) in array.enumerated() {
                components += queryComponents(fromKey: arrayEncoding.encode(key: key, atIndex: index), value: value)
            }
            
        case let number as NSNumber:
            if number.isBool {
                components.append((escape(key), escape(boolEncoding.encode(value: number.boolValue))))
            }
        case let bool as Bool:
            components.append((escape(key), escape(boolEncoding.encode(value: bool))))
        default:
            components.append((escape(key), escape("\(value)")))
            
        }
        
        return components
    }
    
    
    /// Creates a percent-escaped string following RFC 3986 for a query string key or value.
    /// - Parameter string: `String` to be percent-escaped.
    /// - Returns: The percent-escaped `String`.
    public func escape(_ string: String) -> String {
        string.addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) ?? string
    }
    
}
