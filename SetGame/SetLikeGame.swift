//
//  SetLikeGame.swift
//  SetGame
//
//  Created by Mike Kurkin on 18.09.2020.
//

import Foundation

struct CardProperty {
    let values: [PropertyValue]
    
    init(_ values: [PropertyValue]) {
        self.values = values
    }
}

protocol PropertyValue {
    var description: String { get }
    var propertyName: String { get }
    var value: Any { get }
}

struct SetLikeGame {
    private(set) var deck: [Card]
    
    private static func generateDeck(properties: [CardProperty]) -> [Card] {
        var deck: [Card] = []
        
        func propertyIterate(properties: [CardProperty], card: Card = Card(id: 0, properties: [:])) {
            if properties.count == 0 {
                return
            }
            var tmpCard = card
            
            if properties.count == 1 {
                for value in properties.last!.values {
                    tmpCard.properties.updateValue(value, forKey: value.propertyName)
                    tmpCard.id = deck.count
                    deck.append(tmpCard)
                }
            } else {
                for value in properties.last!.values {
                    tmpCard.properties.updateValue(value, forKey: value.propertyName)
                    let propertiesWithoutLast = Array(properties.prefix(upTo: properties.endIndex - 1))
                    propertyIterate(properties: propertiesWithoutLast, card: tmpCard)
                }
            }
        }
        
        propertyIterate(properties: properties)
        
        return deck
    }
    
    init(properties: [CardProperty]) {
        self.deck = SetLikeGame.generateDeck(properties: properties)
    }
    
    struct Card: Identifiable {
        var id: Int
        var properties: [String:PropertyValue]
        
        var description: String {
            var res = "\(id):"
            for property in properties {
                res += " \(property.value.description)"
            }
            return res
        }
    }
    
}
