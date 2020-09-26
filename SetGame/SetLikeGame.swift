//
//  SetLikeGame.swift
//  SetGame
//
//  Created by Mike Kurkin on 18.09.2020.
//

import Foundation

struct SetLikeGame {
    
    private var properties: [CardProperty]
    private var propertyValuesCount: Int
    
    private(set) var deck: [Card]
    
    /// Contains `id`s of cards in the deck
    private(set) var onScreenCards: [Int] = []
    
    
    /// Arary that contains only selected cards
    var selectedCards: [Card] {
        deck.filter{ $0.isSelected }
    }
    
    /// Toggles `card`'s `isSelected`, if enough cards for a set is selected, checks
    /// if selected cards actually form a set and sets all cards to not selected.
    mutating func select(_ card: Card) {
        deck[deck.firstIndex(matching: card)!].isSelected.toggle()
        if selectedCards.count == propertyValuesCount {
            print(doFormSet(selectedCards))
            for index in 0..<deck.count {
                deck[index].isSelected = false
            }
        }
    }
    
    /// Returns true if for `cards` it is true that either all the properties
    /// are the same or they are all different.
    private func doFormSet(_ cards: [Card]) -> Bool {
        print(cards.map{$0.description})
        
        var cardProperties: [[String]] = []
        for (propertyIndex, property) in properties.enumerated() {
            cardProperties.append([])
            for card in cards {
                cardProperties[propertyIndex].append(card.properties[property.propertyName]?.rawValue ?? "")
            }
            print(property.propertyName, cardProperties[propertyIndex])
        }
        let sameOrDifferent = cardProperties.map{ $0.allEqual() || $0.allDifferent() }
        print(sameOrDifferent)
        
        let isSet = sameOrDifferent.reduce(true) { $0 && $1 }
        return isSet
    }
    
    
    
    /// Returns a deck containing all cards with unique combinations of properties.
    private static func generateDeck(with properties: [CardProperty], deck: [Card] = [], card: Card = Card(id: 0, properties: [:])) -> [Card] {
            
        var properties = properties
        var deck = deck
        var card = card
        
        if !properties.isEmpty {
            for value in properties.removeLast().values {
                card.properties.updateValue(value, forKey: value.propertyName)
                if properties.isEmpty {
                    card.id = deck.count
                    deck.append(card)
                } else {
                    deck = generateDeck(with: properties, deck: deck, card: card)
                }
            }
        }
        
        return deck
    }

    /// "Deals"
    mutating func deal(_ count: Int) {
        onScreenCards = []
        onScreenCards = Array(deck.shuffled().prefix(upTo: count)).map{ $0.id }
    }
    
    init?(properties: [CardProperty]) {
        let propertyValuesCounts = properties.map { $0.values.count }
        if !propertyValuesCounts.allEqual() {
            return nil
        }
        self.propertyValuesCount = propertyValuesCounts.first ?? 0
        self.properties = properties
        self.deck = SetLikeGame.generateDeck(with: properties)
    }
    
    
    struct Card: Identifiable {
        var id: Int
        var properties: [String:PropertyValue]
        
        var isFaceUp: Bool = true
        var isSelected: Bool = false
        
        var description: String {
            var res = "\(id):"
            for property in properties {
                res += " \(property.value.description)"
            }
            return res
        }
    }
    
    struct CardProperty {
        let values: [PropertyValue]
        var propertyName: String
        
        init(_ values: [PropertyValue]) {
            self.values = values
            self.propertyName = values.first?.propertyName ?? ""
        }
    }
}

protocol PropertyValue {
    var description: String { get }
    var rawValue: String { get }
    var propertyName: String { get }
    var value: Any? { get }
}
