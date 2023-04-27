//
//  HTTPHeader.swift
//  
//
//  Created by Tiago Ferreira on 27/04/2023.
//

import Foundation

public struct HTTPHeader {
    let key: String
    let value: String

    public init(key: String, value: String) {
        self.key = key
        self.value = value
    }
}
