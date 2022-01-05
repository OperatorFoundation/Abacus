//
//  PersistentSortedDictionary.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/5/22.
//

import Foundation
import Gardener
import Datable

public class PersistentSortedDictionary<Key,Value>: SortedDictionary where Key: LosslessStringConvertible, Key: Comparable, Key: Hashable, Value: MaybeDatable
{
    public typealias Key = Key
    public typealias Value = Value

    let path: String
    let url: URL

    var sortedKeys: SortedSet<Key>

    public init?(path: String, sortingStyle: SortingStyle)
    {
        self.path = path
        self.url = URL(fileURLWithPath: path)
        sortedKeys = SortedSet<Key>(sortingStyle: sortingStyle)

        if File.exists(path)
        {
            guard let contents = File.contentsOfDirectory(atPath: path) else {return nil}
            for item in contents
            {
                guard let key = Key(item) else {return nil}
                sortedKeys.add(element: key)
            }
        }
        else
        {
            guard File.makeDirectory(atPath: path) else {return nil}
        }
    }

    public func set(key: Key, value: Value)
    {
        let destination = self.url.appendingPathComponent(key.description)
        let data = value.data

        do
        {
            try data.write(to: destination)
            sortedKeys.add(element: key)
        }
        catch
        {

        }
    }

    public func get(key: Key) -> Value?
    {
        let source = self.url.appendingPathComponent(key.description)

        do
        {
            let data = try Data(contentsOf: source)
            return Value(data: data)
        }
        catch
        {
            return nil
        }
    }

    public func remove(key: Key)
    {
        let source = self.url.appendingPathComponent(key.description)
        guard File.delete(atPath: source.path) else {return}

        sortedKeys.remove(element: key)
    }

    public func keys() -> SortedSet<Key>
    {
        return sortedKeys
    }

    public func set(index: Int, value: Value)
    {
        guard index >= 0 && index < sortedKeys.sorted.count else {return}
        let key = sortedKeys.sorted[index]
        self.set(key: key, value: value)
    }

    public func get(index: Int) -> Value?
    {
        guard index >= 0 && index < sortedKeys.sorted.count else {return nil}
        let key = sortedKeys.sorted[index]
        return self.get(key: key)
    }

    public func remove(index: Int)
    {
        guard index >= 0 && index < sortedKeys.sorted.count else {return}
        let key = sortedKeys.sorted[index]
        remove(key: key)
    }

    public func values() -> [Value]
    {
        return sortedKeys.sorted.compactMap
        {
            (key: Key) -> Value? in

            return self.get(key: key)
        }
    }

    public func insert(after: Int, value: Value)
    {
        let letters = ["a", "b", "c", "d", "e", "f", "g", "h",
            "i", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]

        if self.sortedKeys.sorted.count == 0 && after == 0
        {
            let string = letters[Int.random(in: 0..<26)]
            guard let key = Key(string) else {return}
            self.set(key: key, value: value)
        }
        else
        {
            guard after >= 0 && after < self.sortedKeys.sorted.count else {return}

            let lastKey = self.sortedKeys.sorted[after]
            let lastKeyString = lastKey.description
            guard !lastKeyString.isEmpty else {return}
            guard let lastKeyLetter = lastKeyString.last else {return}
            guard let lastKeyIndex = letters.firstIndex(of: String(lastKeyLetter)) else {return}

            if lastKeyIndex == letters.count
            {
                let nextKeyLetter = letters[Int.random(in: 0..<26)]
                let nextKeyString = lastKeyString + nextKeyLetter
                guard let nextKey = Key(nextKeyString) else {return}
                self.set(key: nextKey, value: value)
            }
            else
            {
                let nextKeyIndex = lastKeyIndex + 1
                let nextKeyLetter = letters[nextKeyIndex]
                let nextKeyString = String(lastKeyString[..<lastKeyString.endIndex]) + nextKeyLetter
                guard let nextKey = Key(nextKeyString) else {return}
                self.set(key: nextKey, value: value)
            }
        }
    }

    public func append(value: Value)
    {
        if self.sortedKeys.sorted.count == 0
        {
            self.insert(after: 0, value: value)
        }
        else
        {
            self.insert(after: self.sortedKeys.sorted.count - 1, value: value)
        }
    }
}
