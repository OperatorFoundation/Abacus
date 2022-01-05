typealias Count = Int
typealias Index = Int
typealias ElementIndex = (Count, Index)

public class SortedMultiset<Element> where Element: Hashable, Element: Comparable
{
    typealias Elements = [Element]
    
    var elementToElementIndex: [Element: ElementIndex] = [:]
    var countToElements: SimpleSortedDictionary<Count, Elements>
    
    public init(sortingStyle: SortingStyle)
    {
        countToElements = SimpleSortedDictionary<Count, Elements>(sortingStyle: sortingStyle)
    }
}

public extension SortedMultiset
{
    func add(element: Element)
    {
        // This is an existing element.
        if let oldElementIndex = elementToElementIndex[element]
        {
            let (oldCount, _) = oldElementIndex
            let newCount = oldCount + 1
            
            removeOldElement(element: element)
            addNewElement(element: element, count: newCount)
        }
        else // This is a new element.
        {
            let newCount = 1
            addNewElement(element: element, count: newCount)
        }
    }
    
    func removeOldElement(element: Element)
    {
        let elementIndex = elementToElementIndex[element]!
        let (count, index) = elementIndex
            
        let maybeElements = countToElements.get(key: count)
        assert(maybeElements != nil)
        var elements = maybeElements!
        assert(element == elements[index])
        
        // This was the only element with the previous count.
        if elements.count == 1
        {
            countToElements.remove(key: count)
        }
        else // There are multiple elements with the previous count.
        {
            elements.remove(at: index)
            countToElements.set(key: count, value: elements)
            
            for movedElement in elements[index..<elements.count]
            {
                let oldMovedElementIndex = elementToElementIndex[movedElement]!
                let (movedCount, oldMovedIndex) = oldMovedElementIndex
                let newMovedIndex = oldMovedIndex - 1
                let newMovedElementIndex = (movedCount, newMovedIndex)
                elementToElementIndex[movedElement] = newMovedElementIndex
            }
        }
    }
    
    internal func addNewElement(element: Element, count: Count)
    {
        // There are multiple elements with the new count.
        if var elements = countToElements.get(key: count)
        {
            let newIndex = elements.count
            elements.append(element)
            assert(elements[newIndex] == element)
            countToElements.set(key: count, value: elements)
            
            let elementIndex = (count, newIndex)
            elementToElementIndex[element] = elementIndex
        }
        else // This is the only element with the new count.
        {
            let elements: [Element] = [element]
            countToElements.set(key: count, value: elements)
            let index = 0
            let elementIndex = (count, index)
            elementToElementIndex[element] = elementIndex
        }
    }
}

public extension SortedMultiset
{
    var array: [(Int, Element)]
    {
        var result: [(Int, Element)] = []
        
        for count in countToElements.keys().array
        {
            guard let elements = countToElements.get(key: count) else {continue}
            
            for element in elements
            {
                result.append((count, element))
            }
        }
        
        return result
    }
    
    var values: [Element]
    {
        var result: [Element] = []
        
        for count in countToElements.keys().array
        {
            guard let elements = countToElements.get(key: count) else {continue}
            
            for element in elements
            {
                result.append(element)
            }
        }
        
        return result
    }
    
    var counts: [Int]
    {
        var result: [Int] = []
        
        for count in countToElements.keys().array
        {
            guard let elements = countToElements.get(key: count) else {continue}
            
            for _ in elements
            {
                result.append(count)
            }
        }
        
        return result
    }
    
    var expanded: [Element]
    {
        var newArray = [Element]()
        
        for i in 0 ..< self.array.count
        {
            let value = self.values[i]
            let score = self.counts[i]
            
            // The score is the number of times we saw a given value
            // Add the value to the array "score" times
            for _ in 0..<Int(score)
            {
                newArray.append(value)
            }
        }
        
        newArray.sort()
        return newArray
    }

}

public extension SortedMultiset
{
    func top(limit: Int) -> [(Int, Element)]
    {
        var result: [(Int, Element)] = []
        
        for count in countToElements.keys().array
        {
            guard let elements = countToElements.get(key: count) else {continue}
            
            for element in elements
            {
                guard result.count < limit else
                {
                    return result
                }
                
                result.append((count, element))
            }
        }
        
        return result
    }
    
    func bottom(limit: Int) -> [(Int, Element)]
    {
        var result: [(Int, Element)] = []
        
        for count in countToElements.keys().array.reversed()
        {
            guard let elements = countToElements.get(key: count) else {continue}
            
            // This is not strictly necessary, but if we don't do it users might be confused by the results.
            let reversedElements = elements.reversed()
            
            for element in reversedElements
            {
                guard result.count < limit else
                {
                    return result
                }
                
                result.append((count, element))
            }
        }
        
        return result
    }
}
