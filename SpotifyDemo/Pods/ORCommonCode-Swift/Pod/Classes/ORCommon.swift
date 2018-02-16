//
//  ORCommon.swift
//  Pods
//
//  Created by Maxim Soloviev on 10/09/16.
//
//

import Foundation

public func NSLS(_ key: String) -> String {
    return NSLocalizedString(key, comment: "")
}

public func or_typeToString<T>(_ type: T.Type) -> String {
    return String(describing: type)
}

public func or_instanceTypeToString(_ instance: Any) -> String {
    let s = String(describing: type(of: (instance) as AnyObject)).components(separatedBy: ".").last!
    return s
}

public func or_safeString(_ str: String?) -> String {
    return str ?? ""
}
