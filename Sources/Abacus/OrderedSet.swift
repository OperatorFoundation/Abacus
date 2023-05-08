//
//  OrderedSet.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/7/22.
//

import Foundation

public class OrderedSet<Element> where Element: Hashable
{
    var elements = Set<Element>()
    public var array: [Element] = []

    public var count: Int
    {
        return array.count
    }

    public init()
    {
    }

    public func add(_ element: Element)
    {
        guard !self.elements.contains(element) else {return}

        self.elements.insert(element)
        self.array.append(element)
    }

    public func remove(_ element: Element)
    {
        if let index = array.firstIndex(of: element)
        {
            array.remove(at: index)
            elements.remove(element)
        }
    }

    public func get(_ index: Int) -> Element?
    {
        guard index >= 0 && index < self.array.count else {return nil}
        return self.array[index]
    }

    public func contains(_ element: Element) -> Bool
    {
        return self.elements.contains(element)
    }
}

extension OrderedSet: Equatable
{
    public static func == (lhs: OrderedSet<Element>, rhs: OrderedSet<Element>) -> Bool
    {
        return lhs.array == rhs.array
    }
}
