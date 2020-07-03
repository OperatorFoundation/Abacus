//
//  SortedDictionary.swift
//  
//
//  Created by Dr. Brandon Wiley on 7/2/20.
//

import Foundation

public class SortedDictionary<Key,Value> where Key: Hashable, Key: Comparable
{
    var dictionary: [Key: Value] = [:]
    var sortedKeys: SortedSet<Key>
    
    public init(sortingStyle: SortingStyle)
    {
        sortedKeys = SortedSet<Key>(sortingStyle: sortingStyle)
    }
}

public extension SortedDictionary
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
}
