//
//  DSHeaders.swift
//  DSRequest
//
//  Created by Dream on 2023/11/8.
//

import Foundation


// MARK: - DSHeaders
/// Packaging DSHeade settings Request Head
public struct DSHeaders {
    
    /// Save DSHeader data for internal use
    private var headers: [DSHeader] = []
    
    /// `DSHeader` Initialization method
    public init() {}
    
    /// `DSHeader` Initialization method
    /// - Parameter headers: [DSHeader]
    public init(headers: [DSHeader]) {
         headers.forEach { update($0) }
    }
     
    /// `DSHeader` Initialization method
    /// - Parameter dictionary: [name : value]
     public init(_ dictionary: [String: String]) {
         dictionary.forEach { update(DSHeader(name: $0.key, value: $0.value)) }
     }
}


public extension DSHeaders {
    
    /// Added request header data
    /// - Parameters:
    ///   - name: request header `name`
    ///   - value: request header `value`
    mutating func add(name: String, value: String) {
        update(DSHeader(name: name, value: value))
    }
    
    /// Added request header data
    /// - Parameter header: request header, DSHeader
    mutating func add(_ header: DSHeader) {
        update(header)
    }
    
    
    /// Update request header data
    /// - Parameters:
    ///   - name: request header `name`
    ///   - value: request header `value`
    mutating func update(name: String, value: String) {
        update(DSHeader(name: name, value: value))
    }
    
    /// Remove request header data
    /// - Parameter name: request header `name`
    mutating func remove(name: String) {
        guard let index = headers.index(of: name) else { return }

        headers.remove(at: index)
    }
    
    /// Request header number sorted according to the name
    mutating func sort() {
        headers.sort { $0.name.lowercased() < $1.name.lowercased() }
    }
    
    /// Request header number sorted according to the name
    /// - Returns: DSHeaders
    func sorted() -> DSHeaders {
        var headers = self
        headers.sort()
        return headers
    }
    
    /// Get the request header data according to the name
    /// - Parameter name: request header `name`
    /// - Returns: request header `value`
    func value(for name: String) -> String? {
        guard let index = headers.index(of: name) else { return nil }
        return headers[index].value
    }
    
    /// Get the request header data, according to the index
    /// - Parameter name: request header `name`
    /// - Returns: request header `value`
    subscript(_ name: String) -> String? {
        get { value(for: name) }
        set {
            if let value = newValue {
                update(name: name, value: value)
            } else {
                remove(name: name)
            }
        }
    }

    
    /// Update request header data
    /// - Parameter header: DSHeader
    mutating func update(_ header: DSHeader) {
        guard let index = headers.index(of: header.name) else {
            headers.append(header)
            return
        }
        headers.replaceSubrange(index...index, with: [header])
    }
    
    
    /// `[DSHeader]` converts to dictionary data
    var dictionary: [String: String] {
        let namesAndValues = headers.map { ($0.name, $0.value) }
        return Dictionary(namesAndValues, uniquingKeysWith: { _, last in last })
    }
    
}

extension DSHeaders: Collection {
   
    public var startIndex: Int {
        headers.startIndex
    }
    
    public var endIndex: Int {
        headers.endIndex
    }
    
    public subscript(position: Int) -> DSHeader {
        headers[position]
    }
    
    public func index(after i: Int) -> Int {
        headers.index(after: i)
    }
    
}

extension DSHeaders: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, String)...) {
        elements.forEach { update(name: $0.0, value: $0.1) }
    }
}

extension DSHeaders: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: DSHeader...) {
        self.init(headers: elements)
    }
}

extension DSHeaders: Sequence {
    public func makeIterator() -> IndexingIterator<[DSHeader]> {
        headers.makeIterator()
    }
}

// MARK: -


// MARK: - Array, Element == DSRequest.Header
extension Array where Element == DSHeader {
    
    func index(of name: String) -> Int? {
        let lowercasedName = name.lowercased()
        return firstIndex { $0.name.lowercased() == lowercasedName }
    }
}
// MARK: -

