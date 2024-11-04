//
//  Bijection.swift
//  
//
//  Created by Dr. Brandon Wiley on 10/16/22.
//

import Foundation

public class Bijection<S,T> where S: Hashable, T: Hashable
{
    var leftward: [T: S] = [:]
    var rightward: [S: T] = [:]

    public init()
    {
    }

    public init(leftward: [T : S], rightward: [S : T])
    {
        self.leftward = leftward
        self.rightward = rightward
    }

    public func set(_ s: S, _ t: T) throws
    {
        guard !rightward.keys.contains(s) else
        {
            throw BijectionError.conflict
        }

        guard !leftward.keys.contains(t) else
        {
            throw BijectionError.conflict
        }

        leftward[t] = s
        rightward [s] = t
    }

    public func clear(_ s: S, _ t: T)
    {
        guard rightward.keys.contains(s) else
        {
            return
        }

        guard leftward.keys.contains(t) else
        {
            return
        }

        leftward.removeValue(forKey: t)
        rightward.removeValue(forKey: s)
    }

    public func clearRight(_ s: S)
    {
        guard let t = self.right(s) else
        {
            return
        }

        leftward.removeValue(forKey: t)
        rightward.removeValue(forKey: s)
    }

    public func clearLeft(_ t: T)
    {
        guard let s = self.left(t) else
        {
            return
        }

        leftward.removeValue(forKey: t)
        rightward.removeValue(forKey: s)
    }

    public func right(_ s: S) -> T?
    {
        return self.rightward[s]
    }

    public func left(_ t: T) -> S?
    {
        return self.leftward[t]
    }
}

public enum BijectionError: Error
{
    case conflict
}
