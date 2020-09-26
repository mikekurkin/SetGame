//
//  Array+Identifiable.swift
//  Memorize
//
//  Created by Mike Kurkin on 09.09.2020.
//

import Foundation

extension Array where Element: Equatable {
    func allEqual() -> Bool {
        if self.isEmpty {
            return true
        }
        let firstElement = self.first
        for element in self.dropFirst() {
            if element != firstElement {
                return false
            }
        }
        return true
    }
    
    func allDifferent() -> Bool {
        if self.isEmpty {
            return false
        }
        let firstElement = self.first
        for element in self.dropFirst() {
            if element == firstElement {
                return false
            }
        }
        if self.dropFirst().count == 1 {
            return true
        }
        return self.dropFirst().allDifferent()
    }
}

extension ArraySlice where Element: Equatable {
    func allEqual() -> Bool {
        if self.isEmpty {
            return true
        }
        let firstElement = self.first
        for element in self.dropFirst() {
            if element != firstElement {
                return false
            }
        }
        return true
    }
    
    func allDifferent() -> Bool {
        if self.isEmpty {
            return false
        }
        let firstElement = self.first
        for element in self.dropFirst() {
            if element == firstElement {
                return false
            }
        }
        if self.dropFirst().count == 1 {
            return true
        }
        return self.dropFirst().allDifferent()
    }
}
