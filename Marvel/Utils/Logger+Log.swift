import OSLog
import Foundation

extension Logger {
    static var log: Logger {
        return Logger(
            subsystem: Bundle.main.bundlePath,
            category: "\(Self.self)"
        )
    }
}
