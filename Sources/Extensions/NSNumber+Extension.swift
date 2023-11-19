//
//  NSNumber+Extension.swift
//  Demo
//
//  Created by Dream on 2023/11/10.
//

import Foundation

extension NSNumber {
    
    /// Use Obj-C type encoding to check whether the underlying type is a `Bool`, as it's guaranteed as part of
    var isBool: Bool {
        // Use Obj-C type encoding to check whether the underlying type is a `Bool`, as it's guaranteed as part of
        // swift-corelibs-foundation, per [this discussion on the Swift forums](https://forums.swift.org/t/alamofire-on-linux-possible-but-not-release-ready/34553/22).
        String(cString: objCType) == "c"
    }
}

