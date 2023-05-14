import OSLog

@available(iOS 14.0, macOS 11.0, *)
public enum Logging {

    public enum Level: Int, CaseIterable {
        case debug
        case info
        case error

        var icon: String {
            switch self {
            case .debug: return "🚧"
            case .info: return "ℹ️"
            case .error: return "❌"
            }
        }

        var osLogType: OSLogType {
            switch self {
            case .debug: return .debug
            case .info: return .info
            case .error: return .error
            }
        }
    }

    static var osLogger = Logger(subsystem: "logging.PSCore", category: "main")

    public static var level: Level? = {
#if DEBUG
        return .debug
#else
        return nil
#endif
    }()
}

@available(iOS 14.0, macOS 11.0, *)
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
