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
        observable.subscribe(observer: observer)
        observable.notifyAll(action: TestAction(value: true))
        XCTAssertTrue(observer.value)
    }
}

struct TestAction: ObserverAction {
    var value: Bool
}

class TestObserver: Observer {
    var value: Bool = false

    func notify(action: TestAction) {
        self.value = action.value
    }
}

class TestObservable: Observable {
    var observers: [TestObserver] = []
}
