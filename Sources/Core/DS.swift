//
//  DS.swift
//  DSRequest
//
//  Created by Dream on 2023/11/4.
//

import Foundation


/// Isolation
public struct DS<DS> {
    
    /// Prefix property
    public let ds: DS
    
    /// Initialization method
    /// - Parameter ds: DS
    public init(_ ds : DS) {
        self.ds = ds
    }
}

/// DSCompatible, Isolation Agreement
public protocol DSCompatible { }

public extension DSCompatible {
    
    /// Instance property
    var ds: DS<Self> {
        set { }
        get { DS(self) }
    }
    
    /// Static property
    static var ds: DS<Self>.Type {
        set { }
        get { DS<Self>.self }
    }
}
