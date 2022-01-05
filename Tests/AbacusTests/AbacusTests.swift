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
    
    func testMultiSetExpanded()
    {
        let correct = [1, 1, 2, 2, 3, 3, 4]
        let sorted = SortedMultiset<Int>(sortingStyle: .highFirst)
        sorted.add(element: 1)
        sorted.add(element: 2)
        sorted.add(element: 3)
        sorted.add(element: 1)
        sorted.add(element: 3)
        sorted.add(element: 2)
        sorted.add(element: 4)
        
        let results = sorted.expanded
        print(results)
        XCTAssertEqual(correct, results)
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

    func testPersistentSortedDictionary()
    {
        let correct = 0

        guard let dict = PersistentSortedDictionary<String,Int>(path: "test", sortingStyle: .lowFirst) else
        {
            XCTFail()
            return
        }

        dict.set(key: "a", value: correct)
        let result = dict.get(key: "a")
        XCTAssertEqual(result, correct)

        dict.remove(key: "a")
    }

    func testPersistentSortedDictionary2()
    {
        let correct = 0

        guard let dict = PersistentSortedDictionary<String,Int>(path: "test", sortingStyle: .lowFirst) else
        {
            XCTFail()
            return
        }

        dict.set(key: "a", value: correct)
        dict.set(key: "b", value: 1)

        let result = dict.get(index: 0)
        XCTAssertEqual(result, correct)

        dict.remove(key: "a")
        dict.remove(key: "b")
    }
}
