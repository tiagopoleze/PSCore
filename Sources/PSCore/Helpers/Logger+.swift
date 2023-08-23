import OSLog

@available(iOS 14.0, macOS 11, *)
extension Logger {
    private static let subsystem = Bundle.main.bundleIdentifier!
    static let bundleDecoder = Logger(subsystem: subsystem, category: "decoder")
}
