//
//  URLSessionConfiguration+Swizzle.swift
//  
//
//  Created by Tiago Ferreira on 28/04/2023.
//

import Foundation

extension URLSessionConfiguration {

    public static var swizzleMockURLProtocol = false {
        didSet {
            guard swizzleMockURLProtocol != oldValue else { return }
            swizzle()
        }
    }

    private class func swizzle() {
        guard
            let originalConfig = class_getClassMethod(
                URLSessionConfiguration.self,
                #selector(getter: URLSessionConfiguration.default)
            ),
              let replacementConfig = class_getClassMethod(
                URLSessionConfiguration.self,
                #selector(URLSessionConfiguration.swizzledDefaultSessionConfiguration)
              ),
              let originalEphemeralConfig = class_getClassMethod(
                URLSessionConfiguration.self,
                #selector(getter: URLSessionConfiguration.ephemeral)
              ),
              let replacementEphemeralConfig = class_getClassMethod(
                URLSessionConfiguration.self,
                #selector(URLSessionConfiguration.swizzledEphemeralSessionConfiguration)
              )
        else {
            assertionFailure("Methods not found")
            return
        }

        method_exchangeImplementations(originalConfig, replacementConfig)
        method_exchangeImplementations(originalEphemeralConfig, replacementEphemeralConfig)
    }

    @objc private class func swizzledDefaultSessionConfiguration() -> URLSessionConfiguration {
        let configuration = swizzledDefaultSessionConfiguration()
        // swiftlint:disable:next force_unwrapping
        configuration.protocolClasses = [MockURLProtocol.self] as [AnyClass] + configuration.protocolClasses!
        return configuration
    }

    @objc private class func swizzledEphemeralSessionConfiguration() -> URLSessionConfiguration {
        let configuration = swizzledEphemeralSessionConfiguration()
        // swiftlint:disable:next force_unwrapping
        configuration.protocolClasses = [MockURLProtocol.self] as [AnyClass] + configuration.protocolClasses!
        return configuration
    }
}
