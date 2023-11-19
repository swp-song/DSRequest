//
//  AnyCancellable+Extension.swift
//  DSRequest
//
//  Created by Dream on 2023/11/9.
//

import Foundation
import Combine

// MARK: - AnyCancellable
public extension AnyCancellable {
    
    /// Combine Token
     class Token {

         /// AnyCancellable
         var cancellable: AnyCancellable? = nil
         
         /// `Token` Initialization method
         public init() { }
         
         /// Remove token
         public func unseal() { cancellable = nil }
        
    }
    
    /// Add token
    /// - Parameter token: token
    func seal(in token: AnyCancellable.Token) {
        token.cancellable = self
    }
}

// MARK: -
