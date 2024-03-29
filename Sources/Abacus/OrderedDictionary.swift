//
//  OrderedDictionary.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/9/22.
//

import Foundation

public class OrderedDictionary<Key,Value> where Key: Hashable
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

    func set(key: Key, value: Value)
    {
        self.dictionary[key] = value
        self.orderedKeys.add(key)
    }

    func get(key: Key) -> Value?
    {
        return self.dictionary[key]
    }

    func remove(key: Key)
    {
        guard self.orderedKeys.contains(key) else {return}
        self.dictionary.removeValue(forKey: key)
        self.orderedKeys.remove(key)
    }

    func keys() -> [Key]
    {
        return self.orderedKeys.array
    }

    func set(index: Int, value: Value) -> Bool
    {
        guard let key = self.orderedKeys.get(index) else {return false}
        self.dictionary[key] = value

        return true
    }

    func get(index: Int) -> Value?
    {
        guard let key = self.orderedKeys.get(index) else {return nil}
        return self.dictionary[key]
    }

    func remove(index: Int) -> Bool
    {
        guard let key = self.orderedKeys.get(index) else {return false}
        self.dictionary.removeValue(forKey: key)
        self.orderedKeys.remove(key)

        return true
    }

    func values() -> [Value]
    {
        return self.orderedKeys.array.compactMap
        {
            (key: Key) -> Value? in

            return self.get(key: key)
        }
    }
}
