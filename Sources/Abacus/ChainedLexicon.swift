//
//  ChainedLexicon.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/26/22.
//

import Foundation

public class ChainedLexicon<S,T> where S: LexiconProtocol, T: LexiconProtocol, S.Key == T.Key, S.Value == T.Value, S.Head == T.Head
{
    let parent: Lexicon<S.Key,S.Value,S.Head>
    let child: Lexicon<S.Key,S.Value,S.Head>

    public init(parent: S, child: T)
    {
        self.parent = Lexicon<S.Key,S.Value,S.Head>(elements: parent.elements())
        self.child = Lexicon<S.Key,S.Value,S.Head>(elements: child.elements())
    }
}

extension ChainedLexicon: LexiconProtocol
{
    public typealias Key = S.Key
    public typealias Value = S.Value
    public typealias Head = S.Head

    public var count: Int
    {
        return child.count + parent.count
    }

    public var split: (S.Value?, [(S.Key?, S.Value)])?
    {
        return self.child.split
    }

    public func append(key: S.Key?, value: S.Value) -> Bool
    {
        self.parent.append(key: key, value: value)
    }
    
    public func set(key: S.Key, value: S.Value) -> Bool
    {
        if self.child.get(key: key) != nil
        {
            return self.child.set(key: key, value: value)
        }
        else
        {
            if self.parent.get(key: key) != nil
            {
                return self.parent.set(key: key, value: value)
            }
            else
            {
                return self.child.set(key: key, value: value)
            }
        }
    }
    
    public func get(key: S.Key) -> S.Value?
    {
        if let value = self.child.get(key: key)
        {
            return value
        }
        else
        {
            return self.parent.get(key: key)
        }
    }
    
    public func remove(key: S.Key) -> Bool
    {
        if self.child.get(key: key) != nil
        {
            return self.child.remove(key: key)
        }
        else
        {
            return self.parent.remove(key: key)
        }

    }
    
    public func keys() -> [S.Key]
    {
        var result: [S.Key] = []

        var keySet = Set<S.Key>()
        for key in child.keys()
        {
            result.append(key)
            keySet.insert(key)
        }
        
        for key in parent.keys()
        {
            if !keySet.contains(key)
            {
                result.append(key)
            }
        }
        
        return result
    }
    
    public func set(index: Int, key: S.Key?, value: S.Value) -> Bool
    {
        if index < self.child.count
        {
            return self.child.set(index: index, key: key, value: value)
        }
        else if index < self.child.count + self.parent.count
        {
            let newIndex = index - self.child.count
            return self.parent.set(index: newIndex, key: key, value: value)
        }
        else
        {
            return false
        }
    }
    
    public func get(index: Int) -> S.Value?
    {
        if index < self.child.count
        {
            return self.child.get(index: index)
        }
        else if index < self.child.count + self.parent.count
        {
            let newIndex = index - self.child.count
            return self.parent.get(index: newIndex)
        }
        else
        {
            return nil
        }
    }
    
    public func remove(index: Int) -> Bool
    {
        if index < self.child.count
        {
            return self.child.remove(index: index)
        }
        else if index < self.child.count + self.parent.count
        {
            let newIndex = index - self.child.count
            return self.parent.remove(index: newIndex)
        }
        else
        {
            return false
        }
    }
    
    public func values() -> [S.Value]
    {
        var result: [S.Value] = []

        for value in child.values()
        {
            result.append(value)
        }
        
        for value in parent.values()
        {
            result.append(value)
        }
        
        return result
    }
    
    public func elements() -> [(S.Key?, S.Value)]
    {
        var result: [(S.Key?, S.Value)] = []

        for element in child.elements()
        {
            result.append(element)
        }
        
        for element in parent.elements()
        {
            result.append(element)
        }
        
        return result
    }

    public func first() throws -> S.Value
    {
        guard let (_, result) = self.child.elements().first else
        {
            throw LexiconError<S.Key>.empty
        }

        return result
    }
}

extension ChainedLexicon: Equatable
{
    public static func == (lhs: ChainedLexicon<S, T>, rhs: ChainedLexicon<S, T>) -> Bool
    {
        if lhs.count != rhs.count {return false}
        for ((maybeWord1, value1), (maybeWord2, value2)) in zip(lhs.elements(), lhs.elements())
        {
            if maybeWord1 != maybeWord2 {return false}
            if value1 != value2 {return false}
        }
        
        return true
    }
}
