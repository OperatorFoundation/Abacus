//
//  LexiconProtocol.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/21/22.
//

import Foundation

public protocol NestedListProtocol: Equatable, Codable
{
    associatedtype Value where Value: Equatable, Value: Codable

    var count: Int {get}
    var split: (Value?, [Value])? {get}

    func append(value: Value) -> Bool
    func set(index: Int, value: Value) -> Bool
    func get(index: Int) -> Value?
    func remove(index: Int) -> Bool
    func values() -> [Value]
    func first() throws -> Value
}
