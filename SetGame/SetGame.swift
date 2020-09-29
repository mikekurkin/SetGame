//
//  SetGame.swift
//  SetGame
//
//  Created by Mike Kurkin on 18.09.2020.
//

import SwiftUI

class SetGame: ObservableObject {
    
    @Published private var game = SetGame.createSetGame()
    
    
    private static func createSetGame() -> SetLikeGame {
        
        let ranks = SetLikeGame.CardFeature(Rank.allCases)
        let forms = SetLikeGame.CardFeature(Form.allCases)
        let hues = SetLikeGame.CardFeature(Hue.allCases)
        let shadings = SetLikeGame.CardFeature(Shading.allCases)
        
        guard let game = SetLikeGame(features: [forms, hues, shadings, ranks], cardsCount: 12) else {
            fatalError()
        }
        
        return game
    }
    
    
//    var deck: [SetLikeGame.Card] {
//        game.deck
//    }
    
    var cardsInSetCount: Int {
        game.featureValuesCount
    }
    
    var cards: [SetLikeGame.Card] {
        game.onScreenCards
    }
    
    var unusedCardsCount: Int {
        game.unusedCards.count
    }
    
    var score: Int {
        game.score
    }
    
    var selectedCardsCount: Int {
        game.selectedCards.count
    }
    
    var selectedSet: Bool {
        game.doFormSet(game.selectedCards)
    }
    
    
    func select(_ card: SetLikeGame.Card) {
        game.select(card)
    }
    
    func newGame() {
        game = SetGame.createSetGame()
    }
    
    func addThree() {
        game.add(3)
    }
    
    func rank(for card: SetLikeGame.Card) -> Int {
        guard let rank = card.features["rank"]?.value as? Int else {
            return 0
        }
        return rank
    }
    
    
    func form(for card: SetLikeGame.Card) -> AnyInsettableShape {
        if let shape = card.features["form"]?.value as? AnyInsettableShape {
            return shape
        } else {
            return AnyInsettableShape(Rectangle())
        }
    }
    
    func hue(for card: SetLikeGame.Card) -> Color {
        guard let hue = card.features["hue"]?.value as? Color else {
            return Color.black
        }
        return hue
    }
    
    func fill(for card: SetLikeGame.Card) -> String {
        guard let fill = card.features["shading"]?.description else {
            return ""
        }
        return fill
    }
}



enum Rank: String, CaseIterable, FeatureValue {
    case one
    case two
    case three
    
    var featureName: String { "rank" }
    var description: String { self.rawValue }
    
    var value: Any? {
        switch self {
            case .one: return 1
            case .two: return 2
            case .three: return 3
        }
    }
}

enum Form: String, CaseIterable, FeatureValue {
    case oval
    case diamond
    case squiggle
    
    var featureName: String { "form" }
    var description: String { self.rawValue }
    
    var value: Any? {
        switch self {
            case .oval: return AnyInsettableShape(Capsule())
            case .diamond: return AnyInsettableShape(Diamond())
            case .squiggle: return AnyInsettableShape(Squiggle())
        }
    }
}

enum Hue: String, CaseIterable, FeatureValue {
    
    case red
    case green
    case purple
    
    var featureName: String { "hue" }
    var description: String { self.rawValue }
    
    var value: Any? {
        switch self {
        case .red: return Color(red: 255 / 255, green: 0 / 255, blue: 134 / 255)
        case .green: return Color(red: 68 / 255, green: 212 / 255, blue: 77 / 255)
        case .purple: return Color(red: 116 / 255, green: 115 / 255, blue: 211 / 255)
        }
    }
}

enum Shading: String, CaseIterable, FeatureValue {
    case stroked
    case striped
    case solid
    
    var featureName: String { "shading" }
    var description: String { self.rawValue }
    
    var value: Any? { nil }
}

