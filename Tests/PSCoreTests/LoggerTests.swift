//
//  File.swift
//  
//
//  Created by Tiago Ferreira on 10/05/2023.
//

import XCTest
import OSLog
@testable import PSCore

class LoggerTests: XCTestCase {
    func testLogger() throws {
        let logStore = try OSLogStore(scope: .currentProcessIdentifier)
        print("My info log", logLevel: .info)
        print("My debug log", logLevel: .debug)
        print("My error log", logLevel: .error)
        let oneMinuteAgo = Date().addingTimeInterval(-60)
        let position = logStore.position(date: oneMinuteAgo)
        let entries = try logStore.getEntries(at: position).compactMap { $0 as? OSLogEntryLog }.filter { $0.subsystem == "logging.PSCore" }
        XCTAssertEqual("\nℹ️ Description:  \nMy info log", entries[0].composedMessage)
        XCTAssertEqual("\n🚧 Description:  \nMy debug log", entries[1].composedMessage)
        XCTAssertEqual("\n❌ Description:  \nMy error log", entries[2].composedMessage)
    }
}
