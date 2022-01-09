//
//  Lexicon.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/9/22.
//

import Foundation

// Lexicon is an oredered dictionary with optional keys.
// It can be accessed by key or index.
public class Lexicon<Key,Value> where Key: Hashable
{
    public var count: Int
    {
        return self.orderedEntries.count
    }

    var dictionary: [Key: Int] = [:]
    var orderedEntries: [(Key?, Value)] = []

    required public init()
    {
    }

    public init(keys: [Key?], values: [Value])
    {
        for (key, value) in zip(keys, values)
        {
            let _ = self.append(key: key, value: value)
        }
    }

    public func append(key: Key? = nil, value: Value) -> Bool
    {
        if let key = key
        {
            guard self.dictionary[key] == nil else {return false}
            self.dictionary[key] = self.orderedEntries.count
            self.orderedEntries.append((key, value))
            return true
        }
        else
        {
            self.orderedEntries.append((key, value))
            return true
        }
    }

    func set(key: Key, value: Value) -> Bool
    {
        if self.dictionary[key] == nil
        {
            return self.append(key: key, value: value)
        }
        else
        {
            guard let index = self.dictionary[key] else {return false}
            self.orderedEntries[index] = (key, value)
            return true
        }
    }

    func get(key: Key) -> Value?
    {
        guard let index = self.dictionary[key] else {return nil}
        let (_, value) = self.orderedEntries[index]
        return value
    }

    func remove(key: Key) -> Bool
    {
        guard let index = self.dictionary[key] else {return false}
        self.dictionary.removeValue(forKey: key)
        self.orderedEntries.remove(at: index)
        return true
    }

    func keys() -> [Key]
    {
        return [Key](self.dictionary.keys)
    }

    func set(index: Int, key: Key? = nil, value: Value) -> Bool
    {
        // Check if the index is in the existing range
        guard index >= 0 && index < self.orderedEntries.count else {return false}

        // The dictionary may or may not already have a key for this index.
        let result = self.dictionary.first
        {
            (oldKey, value) in

            return value == index
        }

        // If we found a key, delete it
        if let (oldKey, _) = result
        {
            self.dictionary.removeValue(forKey: oldKey)
        }

        // Add the new key if there is one
        if let newKey = key
        {
            self.dictionary[newKey] = index
        }

        // Add the value to the list at the index
        self.orderedEntries[index] = (key, value)

        return true
    }

    func get(index: Int) -> Value?
    {
        guard index >= 0 && index < self.orderedEntries.count else {return nil}

        let (_, value) = self.orderedEntries[index]
        return value
    }

    func remove(index: Int) -> Bool
    {
        guard index >= 0 && index < self.orderedEntries.count else {return false}
        self.orderedEntries.remove(at: index)

        // The dictionary may or may not already have a key for this index.
        let result = self.dictionary.first
        {
            (oldKey, value) in

            return value == index
        }

        if let (oldKey, _) = result
        {
            self.dictionary.removeValue(forKey: oldKey)
        }

        return true
    }

    func values() -> [Value]
    {
        return self.orderedEntries.compactMap
        {
            (key: Key?, value: Value) -> Value? in

            return value
        }
    }
}
