//
//  SimpleSortedDictionary.swift
//
//
//  Created by Dr. Brandon Wiley on 7/2/20.
//

import Foundation

public class SimpleSortedDictionary<Key,Value>: SortedDictionary where Key: Hashable, Key: Comparable
{
    public typealias Key = Key
    public typealias Value = Value

    var dictionary: [Key: Value] = [:]
    var sortedKeys: SortedSet<Key>

    required public init(sortingStyle: SortingStyle)
    {
        sortedKeys = SortedSet<Key>(sortingStyle: sortingStyle)
    }
}

public extension SimpleSortedDictionary
{
    func set(key: Key, value: Value)
    {
        dictionary[key] = value
        sortedKeys.add(element: key)
    }

    func get(key: Key) -> Value?
    {
        return dictionary[key]
    }

    func remove(key: Key)
    {
        guard dictionary[key] != nil else {return}
        dictionary.removeValue(forKey: key)
        sortedKeys.remove(element: key)
    }

    func keys() -> SortedSet<Key>
    {
        return sortedKeys
    }

    func set(index: Int, value: Value)
    {
        guard index > 0 && index < sortedKeys.sorted.count else {return}
        let key = sortedKeys.sorted[index]
        dictionary[key] = value
    }

    func get(index: Int) -> Value?
    {
        guard index > 0 && index < sortedKeys.sorted.count else {return nil}
        let key = sortedKeys.sorted[index]
        return dictionary[key]
    }

    func remove(index: Int)
    {
        guard index > 0 && index < sortedKeys.sorted.count else {return}
        let key = sortedKeys.sorted[index]
        guard dictionary[key] != nil else {return}
        dictionary.removeValue(forKey: key)
        sortedKeys.remove(element: key)
    }

    func values() -> [Value]
    {
        return sortedKeys.sorted.compactMap
        {
            (key: Key) -> Value? in

            return self.get(key: key)
        }
    }

}
