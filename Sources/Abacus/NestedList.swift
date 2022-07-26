//
//  Lexicon.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/9/22.
//

import Foundation
import Datable

// Lexicon is an oredered dictionary with optional keys.
// It can be accessed by key or index.
public class Lexicon<Key,Value,Head>: LexiconProtocol where Key: Hashable, Value: Equatable, Head: Equatable
{
    static public func merge<S,T>(input: S, output: inout T) throws where S: LexiconProtocol, T: LexiconProtocol, S.Key == T.Key, S.Value == T.Value, S.Head == T.Head
    {
        for (maybeKey, value) in input.elements()
        {
            if let key = maybeKey
            {
                guard output.get(key: key) == nil else {throw LexiconError.shadowedMerge(key)}

                let _ = output.set(key: key, value: value)
            }
            else
            {
                let _ = output.append(key: nil, value: value)
            }
        }
    }


    public typealias Key = Key
    public typealias Value = Value
    public typealias Head = Head

    public var count: Int
    {
        return self.orderedEntries.count
    }

    public var split: (Value?, [(Key?, Value)])?
    {
        guard self.orderedEntries.count > 0 else {return nil}
        let (maybeKey, head) = self.orderedEntries[0]
        guard maybeKey == nil else {return nil}

        let rest = [(Key?, Value)](self.orderedEntries[1...])
        return (head, rest)
    }

    var dictionary: [Key: Int] = [:]
    var orderedEntries: [(Key?, Value)] = []

    required public init()
    {
        self.dictionary = [:]
        self.orderedEntries = []
    }

    required public init(keys: [Key?], values: [Value])
    {
        for (key, value) in zip(keys, values)
        {
            let _ = self.append(key: key, value: value)
        }
    }

    required public init(elements: [(Key?, Value)])
    {
        for (key, value) in elements
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

    public func set(key: Key, value: Value) -> Bool
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

    public func get(key: Key) -> Value?
    {
        guard let index = self.dictionary[key] else {return nil}
        let (_, value) = self.orderedEntries[index]
        return value
    }

    public func remove(key: Key) -> Bool
    {
        guard let index = self.dictionary[key] else {return false}
        self.dictionary.removeValue(forKey: key)
        self.orderedEntries.remove(at: index)
        return true
    }

    public func keys() -> [Key]
    {
        return [Key](self.dictionary.keys)
    }

    public func set(index: Int, key: Key? = nil, value: Value) -> Bool
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

    public func get(index: Int) -> Value?
    {
        guard index >= 0 && index < self.orderedEntries.count else {return nil}

        let (_, value) = self.orderedEntries[index]
        return value
    }

    public func remove(index: Int) -> Bool
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

    public func values() -> [Value]
    {
        return self.orderedEntries.compactMap
        {
            (key: Key?, value: Value) -> Value? in

            return value
        }
    }

    public func elements() -> [(Key?, Value)]
    {
        return self.orderedEntries
    }

    public func first() throws -> Value
    {
        guard let (_, result) = self.orderedEntries.first else {throw LexiconError<Key>.empty}
        return result
    }
}

extension Lexicon: Equatable
{
    public static func == (lhs: Lexicon<Key, Value, Head>, rhs: Lexicon<Key, Value, Head>) -> Bool
    {
        let lel = lhs.elements()
        let rel = rhs.elements()

        return zip(lel, rel).reduce(true)
        {
            (partialResult, combined) -> Bool in

            guard partialResult else {return false}

            let (r, l) = combined
            let (rw, rv) = r
            let (lw, lv) = l

            return (rw == lw) && (rv == lv)
        }
    }
}

public enum LexiconError<Key>: Error
{
    case shadowedMerge(Key)
    case empty
}
