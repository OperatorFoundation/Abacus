//
//  DataExtensions.swift
//  
//
//  Created by Dr. Brandon Wiley on 7/26/22.
//

import Foundation

extension Data
{
    public func splitOn(position: UInt) -> (Data, Data)?
    {
        guard self.count >= position else
        {
            return nil
        }

        let headSlice = self[0..<position]
        let head = Data(headSlice)

        let tail: Data
        if self.count == position
        {
            tail = Data()
        }
        else
        {
            let tailSlice = self[position...]
            tail = Data(tailSlice)
        }

        return (head, tail)
    }
}
