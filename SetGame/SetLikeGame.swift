//
//  SetLikeGame.swift
//  SetGame
//
//  Created by Mike Kurkin on 18.09.2020.
//

import Foundation

struct SetLikeGame {
    private(set) var deck: [Card]
    
    private static func generateDeck(with properties: [CardProperty]) -> [Card] {
        var deck: [Card] = []
        
        func addProperties(_ properties: [CardProperty], card: Card = Card(id: 0, properties: [:])) {
            if properties.isEmpty {
                return
            }
            
            var properties = properties
            var card = card
            
            for value in properties.removeLast().values {
                card.properties.updateValue(value, forKey: value.propertyName)
                if properties.isEmpty {
                    card.id = deck.count
                    deck.append(card)
                } else {
                    addProperties(properties, card: card)
                }
            }
        }
        
        addProperties(properties)
        
        return deck
    }
    
    init(properties: [CardProperty]) {
        self.deck = SetLikeGame.generateDeck(with: properties)
    }
    
    struct CardProperty {
        let values: [PropertyValue]
        
        init(_ values: [PropertyValue]) {
            self.values = values
        }
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

protocol PropertyValue {
    var description: String { get }
    var propertyName: String { get }
    var value: Any { get }
}
