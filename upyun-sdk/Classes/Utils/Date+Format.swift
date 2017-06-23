//
//  Date+Format.swift
//  Pods
//
//  Created by Mapleiny on 2017/6/22.
//
//

import Foundation

extension Date {
    func standFormat() -> String {
        let format = DateFormatter()
        format.dateFormat = "EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'"
        return format.string(from: self)
    }
}
