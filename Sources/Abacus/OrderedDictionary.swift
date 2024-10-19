//
//  OrderedDictionary.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/9/22.
//

import Foundation

public class OrderedDictionary<Key,Value> where Key: Equatable, Key: Hashable, Value: Equatable, Value: Hashable
{
    public typealias Key = Key
    public typealias Value = Value

    public var count: Int
    {
        return self.orderedKeys.count
    }

    var dictionary: [Key: Value] = [:]
    var orderedKeys: OrderedSet<Key> = OrderedSet<Key>()

    required public init()
    {
    }

    public init(keys: [Key], values: [Value])
    {
        for (key, value) in zip(keys, values)
        {
            self.set(key: key, value: value)
        }
    }

    public func set(key: Key, value: Value)
    {
        self.dictionary[key] = value
        self.orderedKeys.add(key)
    }

    public func get(key: Key) -> Value?
    {
        return self.dictionary[key]
    }

    public func remove(key: Key)
    {
        guard self.orderedKeys.contains(key) else {return}
        self.dictionary.removeValue(forKey: key)
        self.orderedKeys.remove(key)
    }

    public func keys() -> [Key]
    {
        return self.orderedKeys.array
    }

    public func set(index: Int, value: Value) -> Bool
    {
        guard let key = self.orderedKeys.get(index) else {return false}
        self.dictionary[key] = value

        return true
    }

    public func get(index: Int) -> Value?
    {
        guard let key = self.orderedKeys.get(index) else {return nil}
        return self.dictionary[key]
    }

    public func remove(index: Int) -> Bool
    {
        guard let key = self.orderedKeys.get(index) else {return false}
        self.dictionary.removeValue(forKey: key)
        self.orderedKeys.remove(key)

        return true
    }

    public func values() -> [Value]
    {
        return self.orderedKeys.array.compactMap
        {
            (key: Key) -> Value? in

            return self.get(key: key)
        }
    }
}

extension OrderedDictionary: Equatable
{
    public static func ==(lhs: OrderedDictionary, rhs: OrderedDictionary) -> Bool
    {
        guard lhs.orderedKeys == rhs.orderedKeys else
        {
            return false
        }

        for key in lhs.orderedKeys.array
        {
            let lvalue = lhs.dictionary[key]
            let rvalue = rhs.dictionary[key]

            guard lvalue == rvalue else
            {
                return false
            }
        }

        return true
    }
}

extension OrderedDictionary: Hashable
{
    public func hash(into hasher: inout Hasher)
    {
        hasher.combine(self.dictionary)
        hasher.combine(self.orderedKeys)
    }
}
