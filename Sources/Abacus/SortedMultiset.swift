typealias Count = Int
typealias Index = Int
typealias ElementIndex = (Count, Index)

public class SortedMultiset<Element> where Element: Hashable
{
    typealias Elements = [Element]
    
    var elementToElementIndex: [Element: ElementIndex] = [:]
    var sortedCounts: SortedSet<Count>
    var countToElements: [Count: Elements] = [:]
    
    public init(sortingStyle: SortingStyle)
    {
        sortedCounts = SortedSet<Count>(sortingStyle: sortingStyle)
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
            addNewElement(element: element, newCount: newCount)
        }
        else // This is a new element.
        {
            let newCount = 1
            addNewElement(element: element, newCount: newCount)
        }
    }
    
    func removeOldElement(element: Element)
    {
        let oldElementIndex = elementToElementIndex[element]!
        let (oldCount, oldIndex) = oldElementIndex
            
        let maybeOldCountElements = countToElements[oldCount]
        assert(maybeOldCountElements != nil)
        var oldCountElements = maybeOldCountElements!
        let oldElement = oldCountElements[oldIndex]
        assert(oldElement == element)
        
        // This was the only element with the previous count.
        if oldCountElements.count == 1
        {
            countToElements.removeValue(forKey: oldCount)
            sortedCounts.remove(element: oldCount)
        }
        else // There are multiple elements with the previous count.
        {
            oldCountElements.remove(at: oldIndex)
            countToElements[oldIndex] = oldCountElements
        }
    }
    
    internal func addNewElement(element: Element, newCount: Count)
    {
        // There are multiple elements with the new count.
        if var newCountElements = countToElements[newCount]
        {
            let newIndex = newCountElements.count
            newCountElements.append(element)
            assert(newCountElements[newIndex] == element)
            
            let newElementIndex = (newCount, newIndex)
            elementToElementIndex[element] = newElementIndex
        }
        else // This is the only element with the new count.
        {
            sortedCounts.add(element: newCount)
        }
    }
}

public extension SortedMultiset
{
    var array: [(Int, Element)]
    {
        var result: [(Int, Element)] = []
        
        for (count, elements) in countToElements
        {
            for element in elements
            {
                result.append((count, element))
            }
        }
        
        return result
    }
}
