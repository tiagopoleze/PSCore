//
//  Observer.swift
//  
//
//  Created by Tiago Ferreira on 28/04/2023.
//

/// The action that will be called to notify all
public protocol ObserverAction {
    associatedtype Value
    var value: Value { get }
}

/// The Observer object
public protocol Observer {
    associatedtype Action: ObserverAction
    /// The call that notify the Observables
    /// - Parameter action: The action that will be called
    func notify(action: Action)
}

/// The Observable object
public protocol Observable: AnyObject {
    associatedtype InsideObserver: Observer
    var observers: [InsideObserver] { get set }
    /// The call to subscribe any Observer
    /// - Parameter observer: The observer that will be watched
    func subscribe(observer: InsideObserver)
    /// The call to notify all the observers
    /// - Parameter action: The action that will be called
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
