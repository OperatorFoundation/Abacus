//
//  SortedArray.swift
//  
//
//  Created by Dr. Brandon Wiley on 7/1/20.
//

import Foundation

public enum SortingStyle
{
    case highFirst
    case lowFirst
}

public class SortedSet<Element> where Element: Comparable
{
    var sorted: [Element] = []
    let sortingStyle: SortingStyle
    
    public init(sortingStyle: SortingStyle)
    {
        self.sortingStyle = sortingStyle
    }
}

public extension SortedSet
{
    func add(element: Element)
    {
        guard sorted.count > 0 else
        {
            sorted.append(element)
            return
        }
        
        for (index, sortedElement) in sorted.enumerated()
        {
            if element == sortedElement
            {
                return
            }
            else if sortingStyle == .highFirst && element > sortedElement
            {
                sorted.insert(element, at: index)
                return
            }
            else if sortingStyle == .lowFirst && element < sortedElement
            {
                sorted.insert(element, at: index)
                return
            }
        }
        
        sorted.append(element)
    }
        
    func remove(element: Element)
    {
        if let index = sorted.firstIndex(of: element)
        {
            sorted.remove(at: index)
        }
    }
}

public extension SortedSet
{
    var array: [Element]
    {
        return sorted
    }
}
