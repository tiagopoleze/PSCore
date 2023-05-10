//
//  Logger.swift
//  
//
//  Created by Tiago Ferreira on 26/04/2023.
//

import OSLog

/**
 Logging utility

 - Warning: When building a release it is recommended to disable all levels (default value).

 To enable debugging level:
 ```swift
 Logging.level = .debug
 ```

 To disable all logging:
 ```swift
 Logging.level = nil
 ```

 Logging is performed using `OSLog` with subsystem "logging.PSCore" and category "main".
 */
public enum Logging {

    /// Log message level.
    public enum Level: Int, CaseIterable {
        case debug
        case info
        case error

        var icon: String {
            switch self {
            case .debug:
                return "🚧"
            case .info:
                return "ℹ️"
            case .error:
                return "❌"
            }
        }

        var osLogType: OSLogType {
            switch self {
            case .debug:
                return .debug
            case .info:
                return .info
            case .error:
                return .error
            }
        }
    }

    static var osLogger = Logger(subsystem: "logging.PSCore", category: "main")

    /// Array of enabled log levels. Default value is: [].
    public static var level: Level? = {
#if DEBUG
        return .debug
#else
        return nil
#endif
    }()
}

public func print(
    _ items: Any...,
    separator: String = " ",
    terminator: String = "\n",
    logLevel: Logging.Level
) {
    guard let enabledLevel = Logging.level,
          logLevel.rawValue >= enabledLevel.rawValue else { return }

    let allItems: [Any] = ["\(logLevel.icon) Description: "] + items
    let content = allItems.map({ "\n\($0)" }).joined(separator: separator) + terminator
    Logging.osLogger.log(level: logLevel.osLogType, "\(content)")
}
