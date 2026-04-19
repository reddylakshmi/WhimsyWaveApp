import OSLog

enum AppLogger {
    static func log(
        _ message: String,
        level: OSLogType = .default,
        category: LogCategory
    ) {
        let logger = Logger(
            subsystem: Bundle.main.bundleIdentifier ?? "com.whimsywave.app",
            category: category.rawValue
        )
        logger.log(level: level, "\(message)")
    }

    static func debug(_ message: String, category: LogCategory) {
        log(message, level: .debug, category: category)
    }

    static func info(_ message: String, category: LogCategory) {
        log(message, level: .info, category: category)
    }

    static func error(_ message: String, category: LogCategory) {
        log(message, level: .error, category: category)
    }

    static func fault(_ message: String, category: LogCategory) {
        log(message, level: .fault, category: category)
    }
}
