//
//  Array+Identifiable.swift
//  Memorize
//
//  Created by Mike Kurkin on 09.09.2020.
//

import Foundation

extension Array where Element: Identifiable {
    func firstIndex(matching element: Element) -> Int? {
        self.firstIndex(where: { $0.id == element.id })
    }
}
