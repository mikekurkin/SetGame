//
//  SetGame.swift
//  SetGame
//
//  Created by Mike Kurkin on 18.09.2020.
//

import SwiftUI

class SetGame: ObservableObject {
    
    @Published private var game = createSetGame()
    
    
    private static func createSetGame() -> SetLikeGame {
        
        let ranks = SetLikeGame.CardProperty(Rank.allCases)
        let forms = SetLikeGame.CardProperty(Form.allCases)
        let hues = SetLikeGame.CardProperty(Hue.allCases)
        let fills = SetLikeGame.CardProperty(Fill.allCases)
        
        guard let game = SetLikeGame(properties: [forms, hues, fills, ranks]) else {
            fatalError()
        }
        
        return game
    }
    
    
    var deck: [SetLikeGame.Card] {
        game.deck
    }
    
    var cards: [SetLikeGame.Card] {
        return Array(game.deck.prefix(upTo: 12))
//        return Array(game.deck.shuffled().prefix(upTo: 12))
    }
    
    func select(_ card: SetLikeGame.Card) {
        game.select(card)
    }
    
    func rank(for card: SetLikeGame.Card) -> Int {
        guard let rank = card.properties["rank"]?.value as? Int else {
            return 0
        }
        return rank
    }
    
    
    func form(for card: SetLikeGame.Card) -> AnyInsettableShape {
        if let shape = card.properties["form"]?.value as? AnyInsettableShape {
            return shape
        } else {
            return AnyInsettableShape(Rectangle())
        }
    }
    
    func hue(for card: SetLikeGame.Card) -> Color {
        guard let hue = card.properties["hue"]?.value as? Color else {
            return Color.black
        }
        return hue
    }
    
    func fill(for card: SetLikeGame.Card) -> String {
        guard let fill = card.properties["fill"]?.description else {
            return ""
        }
        return fill
    }
}



enum Rank: String, CaseIterable, PropertyValue {
    case one
    case two
    case three
    
    var propertyName: String { "rank" }
    var description: String { self.rawValue }
    
    var value: Any? {
        switch self {
            case .one: return 1
            case .two: return 2
            case .three: return 3
        }
    }
}

enum Form: String, CaseIterable, PropertyValue {
    case oval
    case diamond
    case squiglee
    
    var propertyName: String { "form" }
    var description: String { self.rawValue }
    
    var value: Any? {
        switch self {
            case .oval: return AnyInsettableShape(Capsule())
            case .diamond: return AnyInsettableShape(Diamond())
            case .squiglee: return AnyInsettableShape(Squiglee())
        }
    }
}

enum Hue: String, CaseIterable, PropertyValue {
    
    case red
    case green
    case purple
    
    var propertyName: String { "hue" }
    var description: String { self.rawValue }
    
    var value: Any? {
        switch self {
        case .red: return Color(red: 255 / 255, green: 0 / 255, blue: 134 / 255)
        case .green: return Color(red: 68 / 255, green: 212 / 255, blue: 77 / 255)
        case .purple: return Color(red: 116 / 255, green: 115 / 255, blue: 211 / 255)
        }
    }
}

enum Fill: String, CaseIterable, PropertyValue {
    case stroked
    case shaded
    case filled
    
    var propertyName: String { "fill" }
    var description: String { self.rawValue }
    
    var value: Any? { nil }
}

