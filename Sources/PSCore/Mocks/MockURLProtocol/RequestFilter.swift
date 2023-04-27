//
//  RequestFilter.swift
//  
//
//  Created by Tiago Ferreira on 27/04/2023.
//

import Foundation

public typealias RequestFilter = (URLRequest) -> (Bool)

public struct RequestFilters {
    public static func url(
        _ url: String
    ) -> RequestFilter {
        return { (request: URLRequest) in
            return request.url?.absoluteString == url
        }
    }

    public static func requestData(
        _ data: Data
    ) -> RequestFilter {
        return { (request: URLRequest) in
            return data == request.streamedBody
        }
    }
}

extension RequestFilters {
    public static func requestFilter(
        json: String
    ) -> RequestFilter {
        return { (request: URLRequest) in
            return dataIsEqualToJSON(data: request.streamedBody, json: json)
        }
    }

    private static func dataIsEqualToJSON(
        data: Data?,
        json: String
    ) -> Bool {
        guard let data = data,
              let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return false
        }

        return dictIsEqualToJSON(dict: dict, json: json)
    }

    private static func dictIsEqualToJSON(
        dict: [String: Any],
        json: String
    ) -> Bool {
        guard let expectedJsonData = json.data(using: .utf8),
              let expectedJsonDict = try? JSONSerialization.jsonObject(with: expectedJsonData) as? [String: Any] else {
            return false
        }

        return NSDictionary(dictionary: dict) == NSDictionary(dictionary: expectedJsonDict)
    }
}

extension RequestFilters {

    public static func lastPathComponent(
        _ lastPathComponent: String
    ) -> RequestFilter {
        return { (request: URLRequest) in
            return request.url?.lastPathComponent == lastPathComponent
        }
    }

    public static func partialPathComponents(
        _ pathComponents: String
    ) -> RequestFilter {
        return { (request: URLRequest) in
            guard var requestPathComponents = request.url?.pathComponents else { return false }
            requestPathComponents = requestPathComponents.filter { $0 != "/" }
            let receivedPathComponents = pathComponents.split(separator: "/").map { String($0) }
            if receivedPathComponents.count > requestPathComponents.count { return false }
            guard let firstReceivedPathComponent = receivedPathComponents.first,
                  let indexRequestPathComponents = requestPathComponents
                .firstIndex(where: {
                    $0 == firstReceivedPathComponent
                }) else { return false }
            for indexReceivedPathComponents in 1..<receivedPathComponents.count {
                if indexReceivedPathComponents + indexRequestPathComponents >= requestPathComponents.count {
                    return false
                }
                // swiftlint:disable:next line_length
                if receivedPathComponents[indexReceivedPathComponents] != requestPathComponents[indexReceivedPathComponents + indexRequestPathComponents] { return false
                }
            }
            return true
        }
    }

    public static func pathComponents(
        _ pathComponents: String
    ) -> RequestFilter {
        return { (request: URLRequest) in
            guard var requestPathComponents = request.url?.pathComponents else { return false }
            requestPathComponents = requestPathComponents.filter { $0 != "/" }
            let receivedPathComponents = pathComponents.split(separator: "/").map { String($0) }
            return requestPathComponents == receivedPathComponents
        }
    }
}
