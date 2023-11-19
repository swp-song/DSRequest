//
//  DSRequest.swift
//  DSRequest
//
//  Created by Dream on 2023/11/4.
//

import Foundation
import Combine

/// Request Network Components
public struct DSRequest {
    public static let `default` = DSRequest()
    private init() { }
}
extension DSRequest: DSCompatible { }

// MARK: - JSON Analysis
public extension DS where DS == DSRequest {
    
    /// JSON Decoder
    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    /// JSON Encoder
    static var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }
    
}
// MARK: -

// MARK: - GET Request
public extension DS where DS == DSRequest {
    
    
    /// GET Request
    /// - Parameters:
    ///   - url:        Request `url`
    ///   - parameters: Request `parameters`
    ///   - encoding:   Request `encoding`
    ///   - headers:    Request `headers`
    /// - Returns:      Server Request Information
    func get(url: String,
             parameters: DSParameters? = nil,
             encoding: DSEncoding =  DSURLEncoding.default,
             headers: DSHeaders? = nil) -> AnyPublisher<Data, Error> {
        return request(url: url, method: .get, parameters: parameters, encoding: encoding, headers: headers)
    }
    
    
    /// GET Request
    /// - Parameters:
    ///   - url:        Request `url`
    ///   - parameters: Request `parameters`
    ///   - encoding:   Request `encoding`
    ///   - headers:    Request `headers`
    ///   - model:      Request `Data Conversion Model`
    /// - Returns:      Server Request Information and `Model`
    func get<Itme>(url: String,
                   parameters: DSParameters? = nil,
                   encoding: DSEncoding =  DSURLEncoding.default,
                   headers: DSHeaders? = nil,
                   model: Itme.Type) -> AnyPublisher<Itme, Error> where Itme: Codable {
        return request(url: url, method: .get, parameters: parameters, encoding: encoding, headers: headers, model: model)
    }
}
// MARK: -

// MARK: - POST Request
public extension DS where DS == DSRequest {
    
    
    /// POST Request
    /// - Parameters:
    ///   - url:        Request `url`
    ///   - parameters: Request `parameters`
    ///   - encoding:   Request `encoding`
    ///   - headers:    Request `headers`
    /// - Returns:      Server Request Information
    func post(url: String,
              parameters: DSParameters? = nil,
              encoding: DSEncoding = DSJSONEncoding.prettyPrinted,
              headers: DSHeaders? = nil) -> AnyPublisher<Data, Error> {
        return request(url: url, method: .post, parameters: parameters, encoding: encoding, headers: headers)
    }
    
    
    /// POST Request
    /// - Parameters:
    ///   - url:        Request `url`
    ///   - parameters: Request `parameters`
    ///   - encoding:   Request `encoding`
    ///   - headers:    Request `headers`
    ///   - model:      Request `Data Conversion Model`
    /// - Returns:      Server Request Information and `Model`
    func post<Itme>(url: String,
                    parameters: DSParameters? = nil,
                    encoding: DSEncoding = DSJSONEncoding.prettyPrinted,
                    headers: DSHeaders? = nil, 
                    model: Itme.Type) -> AnyPublisher<Itme, Error> where Itme: Codable {
        return request(url: url, method: .post, parameters: parameters, encoding: encoding, headers: headers, model: model)
    }
}

// MARK: -


// MARK: - Request
public extension DS where DS == DSRequest {

    
    /// Network Requests
    /// - Parameters:
    ///   - url:        Request `url`
    ///   - method:     Request `method`
    ///   - parameters: Request `parameters`
    ///   - encoding:   Request `encoding`
    ///   - headers:    Request `headers`
    /// - Returns:      Server Request Information
    func request(url: String,
                 method: DSMethod = .get,
                 parameters: DSParameters? = nil,
                 encoding: DSEncoding = DSURLEncoding.default,
                 headers: DSHeaders? = nil) -> AnyPublisher<Data, Error> {
        
        guard let request = convertible(url: url, method: method, parameters: parameters, encoding: encoding, headers: headers) else {
            return Fail(error: DSError.urlError)
                .eraseToAnyPublisher()
        }
        
        return URLSession
            .shared
            .dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    if let log = String(data: data, encoding: .utf8) {
                        debugPrint(log)
                    }
                    throw DSError.invalidResponse
                }
                return data
            }
            .eraseToAnyPublisher()
    }
    
    
    /// Network Requests
    /// - Parameters:
    ///   - url:        Request `url`
    ///   - method:     Request `method`
    ///   - parameters: Request `parameters`
    ///   - encoding:   Request `encoding`
    ///   - headers:    Request `headers`
    ///   - model:      Request `Data Conversion Model`
    /// - Returns:      Server Request Information and `Model`
    func request<Itme>(url: String,
                       method: DSMethod = .get,
                       parameters: DSParameters? = nil,
                       encoding: DSEncoding = DSURLEncoding.default,
                       headers: DSHeaders? = nil,
                       model: Itme.Type) -> AnyPublisher<Itme, Error> where Itme: Codable {
        return request(url: url, method: method, parameters: parameters, encoding: encoding, headers: headers)
            .decode(type: model, decoder: DSRequest.ds.decoder)
            .eraseToAnyPublisher()
    }
   
}
// MARK: -

// MARK: - Convertible URLRequest
private extension DS where DS == DSRequest  {
    
    /// `URLRequest` encoding
    /// - Parameters:
    ///   - url:        encoding `url`
    ///   - method:     encoding `method`
    ///   - parameters: encoding `parameters`
    ///   - encoding:   encoding `encoding`
    ///   - headers:    encoding `headers`
    /// - Returns: Encoded the complete `URLRequest`
    func convertible(url: String,
                     method: DSMethod,
                     parameters: DSParameters?,
                     encoding: DSEncoding,
                     headers: DSHeaders?) -> URLRequest? {
        guard let request = try? URLRequest(url: url, method: method, headers: headers) else { return nil }
        return try? encoding.encode(request, with: parameters);
    }
}
// MARK: -
