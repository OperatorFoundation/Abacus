//
//  Array+SlidingWindow.swift
//  
//
//  Created by Dr. Brandon Wiley on 5/10/23.
//

import Foundation

public extension Array
{
    func window2<Output>(_ function: (Element, Element) -> Output) -> [Output]
    {
        var result: [Output] = []

        for startIndex in self.startIndex..<self.index(before: self.endIndex)
        {
            let endIndex = self.index(after: startIndex)

            let x = self[startIndex]
            let y = self[endIndex]

            let output = function(x, y)
            result.append(output)
        }

        return result
    }

    func window2Indexed<Output>(_ function: (Element, Element, Int) -> Output) -> [Output]
    {
        var result: [Output] = []

        var count = 0
        for startIndex in self.startIndex..<self.index(before: self.endIndex)
        {
            let endIndex = self.index(after: startIndex)

            let x = self[startIndex]
            let y = self[endIndex]

            let output = function(x, y, count)
            count += 1
            result.append(output)
        }

        return result
    }

}
