public protocol ObserverAction {
    associatedtype Value
    var value: Value { get }
}

public protocol Observer {
    associatedtype Action: ObserverAction
    func notify(action: Action)
}

public protocol Observable: AnyObject {
    associatedtype InsideObserver: Observer
    var observers: [InsideObserver] { get set }
    func subscribe(observer: InsideObserver)
    func notifyAll(action: InsideObserver.Action)
}

public extension Observable {
    func subscribe(observer: InsideObserver) {
        observers.append(observer)
    }

    func notifyAll(action: InsideObserver.Action) {
        for observer in observers {
            observer.notify(action: action)
        }
    }
}
