//
//  SetLikeGame.swift
//  SetGame
//
//  Created by Mike Kurkin on 18.09.2020.
//

import Foundation

struct SetLikeGame {
    
    private var features: [CardFeature]
    private(set) var cardsInSetCount: Int
    
    private(set) var deck: [Card]
    
    private(set) var initialCardsCount: Int
    
    private(set) var score: Int = 0
    
    private let scoreReward =  +1
    private let scorePenalty = -1
    private let unnoticedSetPenalty = -2
    
    
    
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
    
    var setsOnScreen: [[Card]] {
        onScreenCards.combinations(ofLength: cardsInSetCount).filter {
            doFormSet($0)
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
            if selectedCards.count == cardsInSetCount {
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
        if selectedCards.count == cardsInSetCount {
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
        if cards.count != cardsInSetCount {
            return false
        }
        
        var cardFeatures: [[String]] = []
        for (featureIndex, feature) in features.enumerated() {
            cardFeatures.append([])
            for card in cards {
                cardFeatures[featureIndex].append(card.featureValues[feature.featureName]?.rawValue ?? "")
            }
        }
        
        let sameOrDifferent = cardFeatures.map{ $0.allEqual || $0.allDifferent }
        
        let isSet = sameOrDifferent.reduce(true) { $0 && $1 }
        
        return isSet
    }
    
    /// Returns a deck containing all cards with unique combinations of features.
    private static func generateDeck(with features: [CardFeature], deck: [Card] = [], card: Card = Card(id: 0, featureValues: [:])) -> [Card] {
            
        var features = features
        var deck = deck
        var card = card
        
        if !features.isEmpty {
            for value in features.removeLast().values {
                card.featureValues.updateValue(value, forKey: value.featureName)
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
    mutating func add(_ count: Int? = nil) -> [Card] {
        
        if setsOnScreen.count > 0 {
            score += unnoticedSetPenalty
        }
        
        let newCards = clearSelection()
        if !newCards.isEmpty {
            return newCards
        } else {
            let newCardIDs = unusedCards.shuffled().prefix(count ?? cardsInSetCount).map{ $0.id }
            onScreenCardIDs.append(contentsOf: newCardIDs)
            return onScreenCards.filter { newCardIDs.contains($0.id) }
        }
    }
    
    /// Turns card face up
    mutating func makeFaceUp(_ card: Card) {
        if let cardIndex = deck.firstIndex(matching: card) {
            deck[cardIndex].isFaceUp = true
        }
    }
    
    private(set) var cheatEnabled: Bool = false
    
    mutating func enableCheat() {
        cheatEnabled = true
    }
    
    init(features: [CardFeature], cardsCount: Int) {
        let featureValuesCounts = features.map { $0.values.count }
        let featureValuesCount = featureValuesCounts.min() ?? 0
        
        if !featureValuesCounts.allEqual {
            var features = features
            features = features.map { CardFeature(Array($0.values.prefix(featureValuesCount))) }
        }
        
        self.cardsInSetCount = featureValuesCount
        self.features = features
        self.deck = SetLikeGame.generateDeck(with: features).shuffled()
        self.initialCardsCount = cardsCount
    }
    
    
    struct Card: Identifiable, Equatable {
        
        var id: Int
        var featureValues: [String : FeatureValue]
        
        var isOnScreen: Bool = false
        var isFaceUp: Bool = false
        var isSelected: Bool = false
        
        var wasInSet: Bool = false
        
        var description: String {
            let sortedFeatureValues = featureValues.sorted(by: { $0.key < $1.key })
            
            var res = "\(id):"
            
            for feature in sortedFeatureValues {
                res += " \(feature.value.description)"
            }
            return res
        }
        
        static func == (lhs: SetLikeGame.Card, rhs: SetLikeGame.Card) -> Bool {
            if !(Set(lhs.featureValues.keys) == Set(rhs.featureValues.keys)) {
                return false
            }
            
            let keys = lhs.featureValues.keys
            
            return keys.compactMap { lhs.featureValues[$0]?.rawValue } == keys.compactMap { rhs.featureValues[$0]?.rawValue }
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
