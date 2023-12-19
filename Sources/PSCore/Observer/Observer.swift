/// A protocol that defines an action performed by an observer.
public protocol ObserverEvent {
    /// The type of the data associated with the event.
    associatedtype EventData
    /// The data associated with the event.
    var eventData: EventData { get }
}

/// A protocol that defines an observer.
public protocol Observer {
    /// The type of the event associated with the observer.
    associatedtype Event: ObserverEvent
    
    /// Sends the specified event to the observer.
    /// - Parameter event: The event to send to the observer.
    func send(event: Event)
}

/// A protocol that defines an observable object.
public protocol Observable: AnyObject {
    associatedtype RegisteredObserver: Observer
    
    /// The array of observers registered to the observable object.
    var registeredObservers: [RegisteredObserver] { get set }
    
    /// Registers an observer to the observable object.
    /// - Parameter observer: The observer to register.
    func register(observer: RegisteredObserver)
    
    /// Sends the specified event to all registered observers.
    /// - Parameter event: The event to send to the observers.
    func sendToAll(event: RegisteredObserver.Event)
}

/// Extends the `Observable` protocol with additional functionality.
public extension Observable {
    
    /// Registers an observer to the observable.
    /// - Parameter observer: The observer to be registered.
    func register(observer: RegisteredObserver) {
        registeredObservers.append(observer)
    }

    /// Sends the specified event to all registered observers.
    /// - Parameter event: The event to be sent.
    func sendToAll(event: RegisteredObserver.Event) {
        for observer in registeredObservers {
            observer.send(event: event)
        }
    }
}
