/// A protocol that defines an action performed by an observer.
public protocol ObserverAction {
    /// The type of the value associated with the action.
    associatedtype Value
    /// The value associated with the action.
    var value: Value { get }
}

/// A protocol that defines an observer.
public protocol Observer {
    /// The type of the action associated with the observer.
    associatedtype Action: ObserverAction
    
    /// Notifies the observer with the specified action.
    /// - Parameter action: The action to notify the observer with.
    func notify(action: Action)
}

/// A protocol that defines an observable object.
public protocol Observable: AnyObject {
    associatedtype InsideObserver: Observer
    
    /// The array of observers subscribed to the observable object.
    var observers: [InsideObserver] { get set }
    
    /// Subscribes an observer to the observable object.
    /// - Parameter observer: The observer to subscribe.
    func subscribe(observer: InsideObserver)
    
    /// Notifies all observers with the specified action.
    /// - Parameter action: The action to notify the observers with.
    func notifyAll(action: InsideObserver.Action)
}

/// Extends the `Observable` protocol with additional functionality.
public extension Observable {
    
    /// Subscribes an observer to the observable.
    /// - Parameter observer: The observer to be subscribed.
    func subscribe(observer: InsideObserver) {
        observers.append(observer)
    }

    /// Notifies all subscribed observers with the specified action.
    /// - Parameter action: The action to be notified.
    func notifyAll(action: InsideObserver.Action) {
        for observer in observers {
            observer.notify(action: action)
        }
    }
}
