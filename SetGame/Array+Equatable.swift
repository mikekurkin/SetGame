//
//  Array+Identifiable.swift
//  Memorize
//
//  Created by Mike Kurkin on 09.09.2020.
//

import Foundation

extension ArraySlice where Element: Equatable {
    func allEqual() -> Bool {
        if self.isEmpty {
            return true
        }
        for element in self.dropFirst() {
            if element != self.first {
                return false
            }
        }
        return true
    }
    
    func allDifferent() -> Bool {
        if self.isEmpty {
            return false
        }
        for element in self.dropFirst() {
            if element == self.first {
                return false
            }
        }
        if self.dropFirst().count == 1 {
            return true
        }
        return self.dropFirst().allDifferent()
    }
}

extension Array where Element: Equatable {
    func allEqual() -> Bool {
        return ArraySlice(self).allEqual()
    }
    
    func allDifferent() -> Bool {
        return ArraySlice(self).allDifferent()
    }
}
