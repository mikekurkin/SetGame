//
//  SetLikeGame.swift
//  SetGame
//
//  Created by Mike Kurkin on 18.09.2020.
//

import Foundation

struct SetLikeGame {
    
    private var features: [CardFeature]
    private(set) var featureValuesCount: Int
    
    private(set) var deck: [Card]
    
    private(set) var initialCardsCount: Int
    
    private(set) var score: Int = 0
    
    private let scoreReward =  +1
    private let scorePenalty = -1
    
    /// Contains ordered `id`s of cards currently on screen
    private(set) var onScreenCardIDs: [Int] = [] {
        didSet {
            for card in onScreenCards {
                if let cardIndex = deck.firstIndex(matching: card) {
                    deck[cardIndex].isOnScreen = onScreenCards.contains { $0.id == card.id }
                    if !deck[cardIndex].isOnScreen {
                        deck[cardIndex].isFaceUp = false
                    }
                }
            }
        }
    }
    
    /// Contains ordered cards currently on screen
    var onScreenCards: [Card] {
        deck.filter{
            onScreenCardIDs.contains($0.id)
        }.sorted{
            if let i0 = onScreenCardIDs.firstIndex(of: $0.id),
               let i1 = onScreenCardIDs.firstIndex(of: $1.id) {
                return i0 < i1
            } else {
                return true
            }
        }
    }
    
    /// Contains only selected cards
    var selectedCards: [Card] {
        deck.filter{ $0.isSelected }
    }
    
    /// Contains cards that did not appear on screen
    var unusedCards: [Card] {
        deck.filter{ !$0.wasInSet && !onScreenCardIDs.contains($0.id) }
    }
    
    /// Toggles `card`'s `isSelected`, if enough cards for a set is selected, checks
    /// if selected cards actually form a set and sets all cards to not selected.
    mutating func select(_ card: Card) -> [Card] {
        let newCards = clearSelection()
        
        if !card.wasInSet {
            deck[deck.firstIndex(matching: card)!].isSelected.toggle()
            if selectedCards.count == featureValuesCount {
                if doFormSet(selectedCards) {
                    for card in selectedCards {
                        deck[deck.firstIndex(matching: card)!].wasInSet = true
                    }
                    score += scoreReward
                } else {
                    score += scorePenalty
                }
            }
        }
        
        return newCards
    }
    
    /// Takes care of previously selected cards after set is checked
    mutating private func clearSelection() -> [Card] {
        var newCardIDs: [Int] = []
        if selectedCards.count == featureValuesCount {
            for card in onScreenCards {
                if card.wasInSet,
                   let cardIndex = onScreenCardIDs.firstIndex(of: card.id) {
                    if onScreenCards.count <= initialCardsCount,
                       let replacementID = unusedCards.randomElement()?.id {
                        onScreenCardIDs[cardIndex] = replacementID
                        newCardIDs.append(replacementID)
                    } else {
                        onScreenCardIDs.remove(at: cardIndex)
                    }
                }
            }
            for index in 0..<deck.count {
                deck[index].isSelected = false
            }
        }
        return onScreenCards.filter { newCardIDs.contains($0.id) }
    }
    
    /// Returns true if for `cards` it is true that either all the features
    /// are the same or they are all different.
    func doFormSet(_ cards: [Card]) -> Bool {
        if cards.count != featureValuesCount {
            return false
        }
        
        print(cards.map{$0.description})
        
        var cardFeatures: [[String]] = []
        for (featureIndex, feature) in features.enumerated() {
            cardFeatures.append([])
            for card in cards {
                cardFeatures[featureIndex].append(card.features[feature.featureName]?.rawValue ?? "")
            }
            print(feature.featureName, cardFeatures[featureIndex])
        }
        
        let sameOrDifferent = cardFeatures.map{ $0.allEqual() || $0.allDifferent() }
        print(sameOrDifferent)
        
        let isSet = sameOrDifferent.reduce(true) { $0 && $1 }
        print(isSet)
        
        return isSet
    }
    
    /// Returns a deck containing all cards with unique combinations of features.
    private static func generateDeck(with features: [CardFeature], deck: [Card] = [], card: Card = Card(id: 0, features: [:])) -> [Card] {
            
        var features = features
        var deck = deck
        var card = card
        
        if !features.isEmpty {
            for value in features.removeLast().values {
                card.features.updateValue(value, forKey: value.featureName)
                if features.isEmpty {
                    card.id = deck.count
                    deck.append(card)
                } else {
                    deck = generateDeck(with: features, deck: deck, card: card)
                }
            }
        }
        
        return deck
    }

    /// Clears on screen cards and deals `count` cards
    mutating func deal(_ count: Int) -> [Card] {
        onScreenCardIDs.removeAll()
        return add(count)
    }
    
    /// Adds `count` cards to ones that are currently on screen
    mutating func add(_ count: Int) -> [Card] {
        let newCardIDs = unusedCards.shuffled().prefix(count).map{ $0.id }
        onScreenCardIDs.append(contentsOf: newCardIDs)
        return onScreenCards.filter { newCardIDs.contains($0.id) }
    }
    
    /// Turns card face up
    mutating func makeFaceUp(_ card: Card) {
        if let cardIndex = deck.firstIndex(matching: card) {
            deck[cardIndex].isFaceUp = true
        }
    }
    
    init(features: [CardFeature], cardsCount: Int) {
        let featureValuesCounts = features.map { $0.values.count }
        let featureValuesCount = featureValuesCounts.min() ?? 0
        
        if !featureValuesCounts.allEqual() {
            var features = features
            features = features.map { CardFeature(Array($0.values.prefix(featureValuesCount))) }
        }
        
        self.featureValuesCount = featureValuesCount
        self.features = features
        self.deck = SetLikeGame.generateDeck(with: features).shuffled()
        self.initialCardsCount = cardsCount
    }
    
    
    struct Card: Identifiable {
        var id: Int
        var features: [String:FeatureValue]
        
        var isOnScreen: Bool = false
        var isFaceUp: Bool = false
        var isSelected: Bool = false
        
        var wasInSet: Bool = false
        
        var description: String {
            var res = "\(id):"
            for feature in features {
                res += " \(feature.value.description)"
            }
            return res
        }
    }
    
    struct CardFeature {
        let values: [FeatureValue]
        var featureName: String
        
        init(_ values: [FeatureValue]) {
            self.values = values
            self.featureName = values.first?.featureName ?? ""
        }
    }
}

protocol FeatureValue {
    var description: String { get }
    var rawValue: String { get }
    var featureName: String { get }
    var value: Any? { get }
}
