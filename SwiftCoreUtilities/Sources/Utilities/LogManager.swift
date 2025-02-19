import os
import Foundation

enum LogLevel: String {
    case debug = "DEBUG"
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
}

final class LogManager {
    // MARK: - Properties
    
    static let shared = LogManager()
    private let logger = Logger(subsystem: "com.swiftCoreUtilities.logger", category: "SwiftCoreUtilities")
    
    // MARK: - Initialization
    
    private init() {}
    
    // MARK: - Public Methods
    
    static func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        shared.log(message, level: .debug, file: file, function: function, line: line)
    }
    
    static func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        shared.log(message, level: .info, file: file, function: function, line: line)
    }
    
    static func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        shared.log(message, level: .warning, file: file, function: function, line: line)
    }
    
    static func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        shared.log(message, level: .error, file: file, function: function, line: line)
    }
    
    // MARK: - Private methods
    
    private func log(
        _ message: String,
        level: LogLevel,
        file: String,
        function: String,
        line: Int
    ) {
        guard !message.isEmpty else { return }
        
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        let emoji = emoji(for: level)
        let formattedMessage = "\(emoji) [\(timestamp)] [\(level.rawValue)] [\(fileName):\(line)] \(function) → \(message)"
        
        switch level {
        case .debug:
            logger.debug("\(formattedMessage, privacy: .public)")
        case .info:
            logger.info("\(formattedMessage, privacy: .public)")
        case .warning:
            logger.warning("\(formattedMessage, privacy: .public)")
        case .error:
            logger.error("\(formattedMessage, privacy: .public)")
        }        
    }
    
    private func emoji(for level: LogLevel) -> String {
        switch level {
        case .debug: return "🐛🐛🐛"
        case .info: return "ℹ️ℹ️ℹ️"
        case .warning: return "⚠️⚠️⚠️"
        case .error: return "❌❌❌"
        }
    }
}
