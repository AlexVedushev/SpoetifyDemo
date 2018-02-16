//
//  String+Hex.swift
//  Pods
//
//  Created by Maxim Soloviev on 10/05/17.
//  Copyright © 2017 Maxim Soloviev. All rights reserved.
//

import Foundation

extension String {
 
    public var or_hex: Int? {
        return Int(self, radix: 16)
    }
}
