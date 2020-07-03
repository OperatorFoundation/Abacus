import XCTest
@testable import Abacus

final class AbacusTests: XCTestCase {
    func testSortedSetHigh()
    {
        let correct = [4, 3, 2, 1]
        
        let sorted = SortedSet<Int>(sortingStyle: .highFirst)
        sorted.add(element: 2)
        sorted.add(element: 1)
        sorted.add(element: 3)
        sorted.add(element: 1)
        sorted.add(element: 3)
        sorted.add(element: 2)
        sorted.add(element: 4)
        
        let result = sorted.array
        XCTAssertEqual(result.count, 4)
        XCTAssertEqual(result, correct)
    }

    func testSortedSetLow()
    {
        let correct = [1, 2, 3, 4]
        
        let sorted = SortedSet<Int>(sortingStyle: .lowFirst)
        sorted.add(element: 1)
        sorted.add(element: 3)
        sorted.add(element: 2)
        sorted.add(element: 1)
        sorted.add(element: 3)
        sorted.add(element: 2)
        sorted.add(element: 4)
        
        let result = sorted.array
        XCTAssertEqual(result.count, 4)
        XCTAssertEqual(result, correct)
    }
    
    func testMultiSet()
    {
        let correct = [(2, 1), (2, 3), (2, 2), (1, 4)]
        
        let sorted = SortedMultiset<Int>(sortingStyle: .highFirst)
        sorted.add(element: 1)
        sorted.add(element: 2)
        sorted.add(element: 3)
        sorted.add(element: 1)
        sorted.add(element: 3)
        sorted.add(element: 2)
        sorted.add(element: 4)
        
        let results = sorted.array
        print(results)
        XCTAssertTrue(compare(results: results, correct: correct))
    }
    
    func testMultiSetOneTwo()
    {
        let correct = [(1, 1), (1, 2)]
        
        let sorted = SortedMultiset<Int>(sortingStyle: .highFirst)
        sorted.add(element: 1)
        sorted.add(element: 2)
        
        let results = sorted.array
        print(results)
        XCTAssertTrue(compare(results: results, correct: correct))
    }
    
    func testMultiSetTwoOnes()
    {
        let correct = [(2, 1)]
        
        let sorted = SortedMultiset<Int>(sortingStyle: .highFirst)
        sorted.add(element: 1)
        sorted.add(element: 1)
        
        let results = sorted.array
        print(results)
        XCTAssertTrue(compare(results: results, correct: correct))
    }

    func testMultiSetTwoOnesTwoTwos()
    {
        let correct = [(2, 1), (2, 2)]
        
        let sorted = SortedMultiset<Int>(sortingStyle: .highFirst)
        sorted.add(element: 1)
        sorted.add(element: 1)
        sorted.add(element: 2)
        sorted.add(element: 2)

        let results = sorted.array
        print(results)
        XCTAssertTrue(compare(results: results, correct: correct))
    }
    
    func testMultiSetTwoOnesTwoTwosInterleaved()
    {
        let correct = [(2, 1), (2, 2)]
        
        let sorted = SortedMultiset<Int>(sortingStyle: .highFirst)
        sorted.add(element: 1)
        sorted.add(element: 2)
        sorted.add(element: 1)
        sorted.add(element: 2)

        let results = sorted.array
        print(results)
        XCTAssertTrue(compare(results: results, correct: correct))
    }
    
    func testMultiSetTopShort()
    {
        let correct = [(1, 1)]
        
        let sorted = SortedMultiset<Int>(sortingStyle: .highFirst)
        sorted.add(element: 1)
        
        let results = sorted.top(limit: 2)
        XCTAssertTrue(compare(results: results, correct: correct))
    }
    
    func testMultiSetTop()
    {
        let correct = [(2, 1), (2, 3)]
        
        let sorted = SortedMultiset<Int>(sortingStyle: .highFirst)
        sorted.add(element: 1)
        sorted.add(element: 2)
        sorted.add(element: 3)
        sorted.add(element: 1)
        sorted.add(element: 3)
        sorted.add(element: 2)
        sorted.add(element: 4)
        
        let results = sorted.top(limit: 2)
        print(results)
        XCTAssertTrue(compare(results: results, correct: correct))
    }
    
    func testMultiSetBottomShort()
    {
        let correct = [(1, 1)]
        
        let sorted = SortedMultiset<Int>(sortingStyle: .highFirst)
        sorted.add(element: 1)
        
        let results = sorted.bottom(limit: 2)
        XCTAssertTrue(compare(results: results, correct: correct))
    }
    
    func testMultiSetBottom()
    {
        let correct = [(1, 4), (2, 2)]
        
        let sorted = SortedMultiset<Int>(sortingStyle: .highFirst)
        sorted.add(element: 1)
        sorted.add(element: 2)
        sorted.add(element: 3)
        sorted.add(element: 1)
        sorted.add(element: 3)
        sorted.add(element: 2)
        sorted.add(element: 4)
        
        let results = sorted.bottom(limit: 2)
        print(results)
        XCTAssertTrue(compare(results: results, correct: correct))
    }
    
    func compare(results: [(Int,Int)], correct: [(Int,Int)]) -> Bool
    {
        guard results.count == correct.count else {return false}
        
        for (index, correctElement) in correct.enumerated()
        {
            let (correctCount, correctElement) = correctElement
            let (resultCount, resultElement) = results[index]

            if resultCount != correctCount {return false}
            if resultElement != correctElement {return false}
        }
        
        return true
    }
}
