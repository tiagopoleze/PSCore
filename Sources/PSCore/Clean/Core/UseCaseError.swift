//
//  File.swift
//  
//
//  Created by Tiago Ferreira on 28/04/2023.
//

public enum UseCaseError: Error {
    case isNil(String)
    case validation(String)
    case repository(String)
}
