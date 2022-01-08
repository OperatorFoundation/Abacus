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

    public init()
    {
    }

    public func add(element: Element)
    {
        guard !self.elements.contains(element) else {return}

        self.elements.insert(element)
        self.array.append(element)
    }

    public func remove(element: Element)
    {
        if let index = array.firstIndex(of: element)
        {
            array.remove(at: index)
            elements.remove(element)
        }
    }
}
