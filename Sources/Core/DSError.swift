//
//  DSError.swift
//  DSRequest
//
//  Created by Dream on 2023/11/9.
//

import Foundation


/// DSError
public enum DSError: Error {
    
    /// Request URL Error
    case urlError
    
    /// Invalid response to the request.
    case invalidResponse
    
    /// Request Parameters Encoding Failed
    case parameterEncodingFailed(reason: ParameterEncodingFailureReason)
    
}


extension DSError: LocalizedError  {
    var localizedDescription: String {
        switch self {
        case .urlError:
            return "Request URL Error"
        case .invalidResponse:
            return "Invalid response to the request."
        case .parameterEncodingFailed(let error):
            return error.localizedDescription

        }
    }
}

public extension DSError {
    
    /// Request Parameters Encoding Failed
    enum ParameterEncodingFailureReason {
        
        /// The `URLRequest` did not have a `URL` to encode.
        case missingURL
        
        /// JSON serialization failed with an underlying system error during the encoding process.
        case jsonEncodingFailed(error: Error)
        
        /// Custom parameter encoding failed due to the associated `Error`.
        case customEncodingFailed(error: Error)
    }
    
}

extension DSError.ParameterEncodingFailureReason {
    var localizedDescription: String {
        switch self {
        case .missingURL:
            return "URL request to encode was missing a URL"
        case let .jsonEncodingFailed(error):
            return "JSON could not be encoded because of error:\n\(error.localizedDescription)"
        case let .customEncodingFailed(error):
            return "Custom parameter encoder failed with error: \(error.localizedDescription)"
        }
    }
}

public extension DSJSONEncoding {
    
    /// URL Coding error
    enum Error: Swift.Error {
        case invalidJSONObject
    }
}

public extension DSJSONEncoding.Error {
     var localizedDescription: String {
        """
        Invalid JSON object provided for parameter or object encoding. \
        This is most likely due to a value which can't be represented in Objective-C.
        """
    }
}
