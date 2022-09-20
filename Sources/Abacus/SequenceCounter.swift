//
//  SequenceCounter.swift
//  
//
//  Created by Dr. Brandon Wiley on 7/26/22.
//

import Foundation

import Datable

public class PositionalSequenceCounter
{
    let counter = SequenceCounter()

    public init()
    {
    }

    public func add(sequence: Data, aOrB: Bool)
    {
        // FIXME
    }

    public func add(position: UInt16, sequence: Data, aOrB: Bool)
    {
        let prefix = position.maybeNetworkData!
        let data = prefix + sequence
        self.counter.add(sequence: data, aOrB: aOrB)
    }
}

public class SequenceCounter: Codable
{
    let top = Layer()

    public init()
    {
    }

    public func add(sequence: Data, aOrB: Bool)
    {
        top.add(sequence: sequence, aOrB: aOrB)
    }

    public func extract() -> [Layer]
    {
        return top.extract().sorted
        {
            x, y in

            if abs(x.score) > abs(y.score)
            {
                return true
            }
            else if abs(x.score) < abs(y.score)
            {
                return false
            }
            else // abs(x.score) == abs(y.score)
            {
                return x.length > y.length
            }
        }
    }

    public func extractData() -> [Data]
    {
        return self.extract().map { $0.data }
    }
}

public class Layer: Codable
{
    static var nextId: Int = 0
    static func getNewId() -> Int
    {
        let result = nextId
        nextId += 1
        return result
    }

    public let length: Int
    public let id: Int

    public var score: Int
    {
        return self.countA - self.countB
    }

    public var data: Data
    {
        // FIXME - implement this
        return Data()
    }

    var tracker: [UInt64] = [0, 0, 0, 0]
    var next: [Coordinates: Layer] = [:]
    var countA: Int = 0
    var countB: Int = 0

    public init(length: Int = 1)
    {
        self.length = length
        self.id = Layer.getNewId()
    }

    public func add(sequence: Data, aOrB: Bool)
    {
        guard let (first, rest) = sequence.splitOn(position: 1) else
        {
            // The sequence ends here, increment the count.
            if aOrB
            {
                self.countA += 1
            }
            else
            {
                self.countB += 1
            }

            return
        }

        let coordinates = map(first[0])
        self.set(coordinates)

        let layer: Layer
        if let oldLayer = self.next[coordinates]
        {
            layer = oldLayer
        }
        else
        {
            layer = Layer(length: self.length + 1)
            self.next[coordinates] = layer
        }

        layer.add(sequence: rest, aOrB: aOrB)
    }

    public func extract() -> [Layer]
    {
        var results = self.next.values.flatMap { $0.extract() }

        if self.countA != self.countB
        {
            results.append(self)
        }

        return results
    }

    func map(_ byte: UInt8) -> Coordinates
    {
        let int = Int(byte)
        let index = int / 64
        let offset = int % 64
        return Coordinates(index: index, offset: offset)
    }

    func set(_ coordinates: Coordinates)
    {
        let mask: UInt64 = 1 << coordinates.offset
        self.tracker[coordinates.index] |= mask
    }

//    func clear(index: Int, offset: Int)
//    {
//        let mask: UInt64 = ~(1 << offset)
//        self.tracker[index] &= mask
//    }

    func get(coordinates: Coordinates) -> Bool
    {
        let mask: UInt64 = 1 << coordinates.offset
        return (self.tracker[coordinates.index] & mask) != 0
    }
}

public struct Coordinates: Codable, Hashable
{
    public let index: Int
    public let offset: Int
}
