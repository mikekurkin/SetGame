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
    private(set) var onScreenCardIDs: [Int] = []
    
    
    /// Arary that contains only selected cards
    var selectedCards: [Card] {
        deck.filter{ $0.isSelected }
    }
    
    var unusedCards: [Card] {
        deck.filter{ !$0.wasInSet && !onScreenCardIDs.contains($0.id) }
    }
    
    /// Toggles `card`'s `isSelected`, if enough cards for a set is selected, checks
    /// if selected cards actually form a set and sets all cards to not selected.
    mutating func select(_ card: Card) {
        if selectedCards.count == propertyValuesCount {
            print(onScreenCardIDs)
            for card in deck.filter({ onScreenCardIDs.contains($0.id) }) {
                if card.wasInSet {
                    if let cardIndex = onScreenCardIDs.firstIndex(of: card.id) {
//                        onScreenCards.remove(at: cardIndex)
                        if let replacementId = unusedCards.randomElement()?.id {
                            onScreenCardIDs[cardIndex] = replacementId
                        } else {
                            onScreenCardIDs.remove(at: cardIndex)
                        }
                    }
//                    add(1)
                }
                
                
            }
            print(onScreenCardIDs)
            for index in 0..<deck.count {
                deck[index].isSelected = false
            }
            print(unusedCards.count)
            
            return
        }
        deck[deck.firstIndex(matching: card)!].isSelected.toggle()
        if selectedCards.count == propertyValuesCount {
            
            
//            let group = DispatchGroup()
//            group.enter()
            if doFormSet(selectedCards) {
                for card in selectedCards {
                    deck[deck.firstIndex(matching: card)!].wasInSet = true
                }
            }
            
            
//            for index in 0..<deck.count {
//
////                deck[index].isSelected = false
//            }
            
            
            
            
        }
    }
    
    /// Returns true if for `cards` it is true that either all the properties
    /// are the same or they are all different.
    func doFormSet(_ cards: [Card]) -> Bool {
        if cards.count != propertyValuesCount {
            return false
        }
        
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
        
        print(isSet)
        
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
        onScreenCardIDs = []
        onScreenCardIDs = deck.shuffled().prefix(upTo: count).map{ $0.id }
    }
    
//    mutating func deal(_ count: Int) {
//        for _ in 0..<count {
//            if let randomUnusedCard = unusedCards.randomElement(),
//               let cardIndex = deck.firstIndex(matching: randomUnusedCard) {
//                deck[cardIndex].isOnScreen = true
//            }
//        }
//    }
    
    mutating func add(_ count: Int) {
        onScreenCardIDs.append(contentsOf: unusedCards.shuffled().prefix(count).map{ $0.id })
    }
    
    init?(properties: [CardProperty]) {
        let propertyValuesCounts = properties.map { $0.values.count }
        if !propertyValuesCounts.allEqual() {
            return nil
        }
        self.propertyValuesCount = propertyValuesCounts.first ?? 0
        self.properties = properties
        self.deck = SetLikeGame.generateDeck(with: properties).shuffled()
    }
    
    
    struct Card: Identifiable {
        var id: Int
        var properties: [String:PropertyValue]
        
        var isFaceUp: Bool = true
        var isOnScreen: Bool = false
        var isSelected: Bool = false
        
        var wasInSet: Bool = false
        
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
