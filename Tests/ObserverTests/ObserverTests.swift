//
//  ObserverTests.swift
//  
//
//  Created by Tiago Ferreira on 28/04/2023.
//

import XCTest
@testable import Observer

class ObserverTests: XCTestCase {
    func testObserver() throws {
        let observer = TestObserver()
        let observable = TestObservable()
        XCTAssertFalse(observer.value)
        observable.register(observer: observer)
        observable.sendToAll(event: TestAction(eventData: true))
        XCTAssertTrue(observer.value)
    }
}

struct TestAction: ObserverEvent {
    var eventData: Bool
}

class TestObserver: Observer {
    var value: Bool = false

    func send(event: TestAction) {
        self.value = event.eventData
    }
}

class TestObservable: Observable {
    var registeredObservers: [TestObserver] = []
}
