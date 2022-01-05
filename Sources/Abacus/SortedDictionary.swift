//
//  SortedDictionary.swift
//  
//
//  Created by Dr. Brandon Wiley on 7/2/20.
//

import Foundation
import AppKit

public protocol SortedDictionary
{
    associatedtype Key where Key: Comparable
    associatedtype Value

    func set(key: Key, value: Value)
    func get(key: Key) -> Value?
    func remove(key: Key)
    func keys() -> SortedSet<Key>
    func set(index: Int, value: Value)
    func get(index: Int) -> Value?
    func remove(index: Int)
    func values() -> [Value]
}
