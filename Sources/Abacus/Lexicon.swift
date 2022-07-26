//
//  NestedList.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/9/22.
//

import Foundation
import Datable

// NestedList is an oredered dictionary with optional keys.
// It can be accessed by key or index.
public class NestedList<Value>: NestedListProtocol where Value: Equatable, Value: Codable
{
    static public func merge<S,T>(input: S, output: inout T) throws where S: NestedListProtocol, T: NestedListProtocol, S.Value == T.Value
    {
        for value in input.values()
        {
            let _ = output.append(value: value)
        }
    }

    public typealias Value = Value

    public var count: Int
    {
        return self.orderedEntries.count
    }

    public var split: (Value?, [Value])?
    {
        guard self.orderedEntries.count > 0 else {return nil}
        let head = self.orderedEntries[0]

        let rest = [Value](self.orderedEntries[1...])
        return (head, rest)
    }

    var orderedEntries: [Value] = []

    required public init()
    {
        self.orderedEntries = []
    }

    required public init(values: [Value])
    {
        self.orderedEntries = values
    }

    required public init(elements: [Value])
    {
        self.orderedEntries.append(contentsOf: elements)
    }

    public func append(value: Value) -> Bool
    {
        self.orderedEntries.append(value)
        return true
    }

    public func set(index: Int, value: Value) -> Bool
    {
        // Check if the index is in the existing range
        guard index >= 0 && index < self.orderedEntries.count else {return false}

        // Add the value to the list at the index
        self.orderedEntries[index] = value

        return true
    }

    public func get(index: Int) -> Value?
    {
        guard index >= 0 && index < self.orderedEntries.count else {return nil}

        let value = self.orderedEntries[index]
        return value
    }

    public func remove(index: Int) -> Bool
    {
        guard index >= 0 && index < self.orderedEntries.count else {return false}
        self.orderedEntries.remove(at: index)

        return true
    }

    public func values() -> [Value]
    {
        return self.orderedEntries
    }

    public func first() throws -> Value
    {
        guard let result = self.orderedEntries.first else {throw NestedListError.empty}
        return result
    }
}

extension NestedList: Equatable
{
    public static func == (lhs: NestedList<Value>, rhs: NestedList<Value>) -> Bool
    {
        let lel = lhs.values()
        let rel = rhs.values()

        return zip(lel, rel).reduce(true)
        {
            (partialResult, combined) -> Bool in

            guard partialResult else {return false}

            let (r, l) = combined

            return (r == l)
        }
    }
}

public enum NestedListError: Error
{
    case empty
}
