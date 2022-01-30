//
//  LexiconProtocol.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/21/22.
//

import Foundation

// LexiconProtocol is an oredered dictionary with optional keys.
// It can be accessed by key or index.
public protocol LexiconProtocol: Equatable
{
    associatedtype Key where Key: Hashable
    associatedtype Value where Value: Equatable
    associatedtype Head where Head: Equatable

    var count: Int {get}
    var split: (Head?, [(Key?, Value)])? {get}

//    init(_ head: Head?)
//    init(_ head: Head?, keys: [Key?], values: [Value])
//    init(_ head: Head?, elements: [(Key?, Value)])

    func append(key: Key?, value: Value) -> Bool
    func set(key: Key, value: Value) -> Bool
    func get(key: Key) -> Value?
    func remove(key: Key) -> Bool
    func keys() -> [Key]
    func set(index: Int, key: Key?, value: Value) -> Bool
    func get(index: Int) -> Value?
    func remove(index: Int) -> Bool
    func values() -> [Value]
    func elements() -> [(Key?, Value)]
}
