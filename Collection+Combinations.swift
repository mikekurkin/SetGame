//
//  Collection+Combinations.swift
//  SetGame
//
//  Created by Mike Kurkin on 11.10.2020.
//

import Foundation

extension Collection where Index == Int {
    func combinations(ofLength length: Int) -> [[Element]] {
        
        switch length {
        case let l where l <= 0:
            return []
        case 1:
            return self.map{ [$0] }
        default:
            switch self.count {
            case let n where n < length:
                return []
            case length:
                return [Array(self)]
            default:
                return (0..<self.count).map { index in
                    self.suffix(from: self.startIndex + 1 + index).combinations(ofLength: length - 1).map {
                        [self[self.startIndex + index]] + $0
                    }
                }.reduce([], +)
            }
        }
    }
}
