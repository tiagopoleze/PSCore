# PSCore

PSCore is a Swift package that includes implementations for the Observer and Chain of Responsibility design patterns, in addition to various other functionalities.

## Install

To install PSCore, you need to add the following to your Package.swift file:

```swift
dependencies: [
    .package(url: "https://github.com/tiagopoleze/PSCore.git", branch: "main")
]
```

## Using
### Observer
To use the Observer pattern, you need to do the following:
```
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

let observer = TestObserver()
let observable = TestObservable()

observable.register(observer: observer)
observable.sendToAll(event: TestAction(eventData: true))
```

### Chain of Responsibility
To use the Chain of Responsibility pattern, you need to do the following:
```
let first = ChainOfResponsibility<Int, Int> { number in
    number == 10
} result: { number in
    number + 1
}

let second = ChainOfResponsibility<Int, Int>(next: first) { number in
    number == 5
} result: { number in
    number + 2
}

let result = try second.execute(input: 10)
let result2 = try second.execute(input: 5)
```

## Tests
To run the tests, you can use the following command:
```
swift test
```

## Linting
For linting, we use SwiftLint. You can run the linter with the following command:
```
./scripts/bin/swiftlint --format --quiet --config ./.swiftlint.yml
```

## Contributions
Contributions are welcome! Please read our contribution guide to get started.

## License
This project is licensed under the MIT License - see the LICENSE file for details.