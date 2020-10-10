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
        
        let game = SetLikeGame(features: [forms, hues, shadings, ranks], cardsCount: 12)
        
        return game
    }
    
    
//    var deck: [SetLikeGame.Card] {
//        game.deck
//    }
    
    var cardsInSetCount: Int {
        game.cardsInSetCount
    }
    
    var initialCardsCount: Int {
        game.initialCardsCount
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
    
    var setsCount: Int {
        game.setsOnScreen.count
    }
    
    var cheatEnabled: Bool {
        game.cheatEnabled
    }
    
    func enableCheat() {
        game.enableCheat()
    }
    
    func cheat() -> [SetLikeGame.Card] {
        if game.setsOnScreen.isEmpty {
            return []
        }
        
        if selectedSet {
            return game.clearSelection()
        }
        
        let set = game.setsOnScreen.randomElement()!
        for card in game.selectedCards {
            _ = select(card)
        }
        for card in set {
            _ = select(card)
        }
        return []
    }
    
    func select(_ card: SetLikeGame.Card) -> [SetLikeGame.Card] {
        game.select(card)
    }
    
    func newGame() -> [SetLikeGame.Card] {
        game = SetGame.createSetGame()
        return deal()
    }
    
    func deal() -> [SetLikeGame.Card] {
        return game.deal(initialCardsCount)
    }
    
    func addThree() -> [SetLikeGame.Card] {
        return game.add()
    }
    
    func turnOverOnScreenCards() {
        for card in cards {
            game.makeFaceUp(card)
        }
    }
    
    func makeFaceUp(_ card: SetLikeGame.Card) {
        game.makeFaceUp(card)
    }
    
    func rank(for card: SetLikeGame.Card) -> Int {
        guard let rank = card.featureValues["rank"]?.value as? Int else {
            return 0
        }
        return rank
    }
    
    
    func form(for card: SetLikeGame.Card) -> AnyInsettableShape {
        if let shape = card.featureValues["form"]?.value as? AnyInsettableShape {
            return shape
        } else {
            return AnyInsettableShape(Rectangle())
        }
    }
    
    func hue(for card: SetLikeGame.Card) -> Color {
        guard let hue = card.featureValues["hue"]?.value as? Color else {
            return Color.black
        }
        return hue
    }
    
//    func shading(for card: SetLikeGame.Card) -> Shading {
//        if let shadingString = card.features["shading"]?.description,
//           let shadingEnum = Shading(rawValue: shadingString) {
//            return shadingEnum
//        } else {
//            return Shading.solid
//        }
//    }
    
    @ViewBuilder
    func shaded(_ form: AnyInsettableShape, for card: SetLikeGame.Card) -> some View {
        if let shading = card.featureValues["shading"] as? Shading {
            shading.shaded(form)
        } else {
            form
        }
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
    
    @ViewBuilder
    func shaded(_ shape: AnyInsettableShape) -> some View {
        
        ZStack{
            switch self {
            case .stroked:
                shape.fill().opacity(0)
            case .striped:
                Hatch(14, at: Angle(degrees: 90), lineWidth: 1)
                    .clipShape(shape)
            case .solid:
                shape.fill().opacity(0.5)
            }
            shape.strokeBorder(lineWidth: 3)
        }
    }
    
    var value: Any? {
        return self.shaded
    }
}

