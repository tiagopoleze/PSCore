//
//  NSPredicate+helpers.swift
//  
//
//  Created by Tiago Ferreira on 13/05/2023.
//

import CoreData

extension NSPredicate {
    public enum CompareSize: String {
        case big = ">"
        case bigOrEqual = ">="
        case equal = "="
        case small = "<"
        case smallOrEqual = "<="
    }

    public enum Connection: String {
        case and = "AND"
        // swiftlint:disable:next identifier_name
        case or = "OR"
    }

    static let beginsWith = "BEGINSWITH[cd]"

    public static func build(_ keyPath: String, action: CompareSize, arg: CVarArg) -> NSPredicate {
        NSPredicate(format: "%K \(action.rawValue) %@", keyPath, arg)
    }

    public static func build(_ keyPath: String, isBeginsWith: Bool = true, arg: CVarArg) -> NSPredicate {
        if isBeginsWith {
            return NSPredicate(format: "%K \(NSPredicate.beginsWith) %@", keyPath, arg)
        } else {
            return NSPredicate(format: "NOT %K \(NSPredicate.beginsWith) %@", keyPath, arg)
        }
    }

    public func compound(
        _ connection: Connection,
        with second: NSPredicate
    ) -> NSCompoundPredicate {
        switch connection {
        case .and:
            return NSCompoundPredicate(andPredicateWithSubpredicates: [self, second])
        case .or:
            return NSCompoundPredicate(orPredicateWithSubpredicates: [self, second])
        }
    }
}
