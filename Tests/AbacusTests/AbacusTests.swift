import XCTest
@testable import Abacus

final class AbacusTests: XCTestCase {
    func testSortedSet()
    {
        let correct = [4, 3, 2, 1]
        
        let sorted = SortedSet<Int>(sortingStyle: .highFirst)
        sorted.add(element: 1)
        sorted.add(element: 2)
        sorted.add(element: 3)
        sorted.add(element: 1)
        sorted.add(element: 3)
        sorted.add(element: 2)
        sorted.add(element: 4)
        
        let result = sorted.array
        XCTAssertEqual(result, correct)
    }
    
    func testMultiSet()
    {
        let correct = [(1, 4), (2, 3), (2, 2), (2, 1)]
        
        let sorted = SortedMultiset<Int>(sortingStyle: .highFirst)
        sorted.add(element: 1)
        sorted.add(element: 2)
        sorted.add(element: 3)
        sorted.add(element: 1)
        sorted.add(element: 3)
        sorted.add(element: 2)
        sorted.add(element: 4)
        
        let results = sorted.array
        for (index, result) in results.enumerated()
        {
            let (resultCount, resultElement) = result
            let (correctCount, correctElement) = correct[index]
            
            XCTAssertEqual(resultCount, correctCount)
            XCTAssertEqual(resultElement, correctElement)
        }
    }
}
