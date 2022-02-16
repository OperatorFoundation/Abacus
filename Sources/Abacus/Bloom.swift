//
//  Bloom.swift
//  
//
//  Created by Joshua Clark on 1/23/22.
//

import Foundation

public struct BloomFilter<T: Hashable> {
    static func optimalNumOfBits(expectedInsertions: Int, falsePositiveRate: Double) -> Int {
        var probability = falsePositiveRate
        if (falsePositiveRate == 0) {
            probability = Double.leastNonzeroMagnitude
        }
        let baseConversion: Double = log(Double(2)) * log(Double(2))
        let logResult: Double = log(probability) / baseConversion
        return Int(Double(-expectedInsertions) * logResult)
      }
    
    private var bits: [Bool]
    private let seeds: [Int]
    
    public init(expectedInsertions: Int, falsePositiveRate: Double, hashCount: Int) {
        let size = BloomFilter.optimalNumOfBits(expectedInsertions: expectedInsertions, falsePositiveRate: falsePositiveRate)
        bits = Array(repeating: false, count: size)
        seeds = (0..<hashCount).map({ _ in Int.random(in: 0..<Int.max) })
    }
    
    public init() {
        self.init(expectedInsertions: 1000, falsePositiveRate: 0.03, hashCount: 3)
    }
    
    public mutating func insert(_ data: T) {
        hashes(for: data)
        .forEach({ hash in
            bits[hash % bits.count] = true
        })
    }
    
    public func contains(_ data: T) -> Bool {
        return hashes(for: data)
        .allSatisfy({ hash in
            bits[hash % bits.count]
        })
    }
    
    private func hashes(for data: T) -> [Int] {
        return seeds.map({ seed -> Int in
            var hasher = Hasher()
            hasher.combine(data)
            hasher.combine(seed)
            let hashValue = abs(hasher.finalize())
            return hashValue
        })
    }
}


