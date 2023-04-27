//
//  HTTPMethod.swift
//  
//
//  Created by Tiago Ferreira on 27/04/2023.
//

import Foundation

public enum HTTPMethod {
    case get
    case post(body: Data?)
    case put(body: Data?)
    case patch(body: Data?)
    case delete

    var httpMethod: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .put: return "PUT"
        case .patch: return "PATCH"
        case .delete: return "DELETE"
        }
    }

    var body: Data? {
        switch self {
        case .post(let body): return body
        case .put(let body): return body
        case .patch(let body): return body
        case .delete, .get: return nil
        }
    }
}
