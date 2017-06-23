//
//  common.swift
//  Pods
//
//  Created by Mapleiny on 2017/6/23.
//
//

import Foundation



/// 对 Optional 解包
///
/// - Parameter any: any value
/// - Returns: unwrap value
func unwrap(_ any:Any) -> Any {
    let mi = Mirror(reflecting: any)
    
    if mi.displayStyle != .optional {
        return any
    }
    
    if mi.children.count == 0 { return NSNull() }
    return mi.children.first!.value
}
