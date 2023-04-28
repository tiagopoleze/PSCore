//
//  File.swift
//  
//
//  Created by Tiago Ferreira on 28/04/2023.
//

public extension Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
}
