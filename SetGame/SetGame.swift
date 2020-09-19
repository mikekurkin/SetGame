//
//  SetGame.swift
//  SetGame
//
//  Created by Mike Kurkin on 18.09.2020.
//

import SwiftUI

struct AnyShape: Shape {
    init<S: Shape>(_ wrapped: S) {
        _path = { rect in
            let path = wrapped.path(in: rect)
            return path
        }
    }

    func path(in rect: CGRect) -> Path {
        return _path(rect)
    }

    private let _path: (CGRect) -> Path
}

enum Rank: String, CaseIterable, PropertyValue {
    case one
    case two
    case three
    
    var propertyName: String { "rank" }
    var description: String { self.rawValue }
    
    var value: Any {
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
    
    var value: Any {
        switch self {
            case .oval: return AnyShape(Capsule())
            case .diamond: return AnyShape(Diamond())
            case .squiglee: return AnyShape(Squiglee())
        }
    }
}

enum Hue: String, CaseIterable, PropertyValue {
    
    case red
    case green
    case purple
    
    var propertyName: String { "hue" }
    var description: String { self.rawValue }
    
    var value: Any {
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
    
    var value: Any {EmptyModifier()}
}

class SetGame: ObservableObject {
    @Published private var game = createSetGame()
    
    private static func createSetGame() -> SetLikeGame {
        
        let ranks = CardProperty(Rank.allCases)
        let forms = CardProperty(Form.allCases)
        let hues = CardProperty(Hue.allCases)
        let fills = CardProperty(Fill.allCases)
        
        let properties = [forms, hues, fills, ranks]
        return SetLikeGame(properties: properties)
    }
    
    var deck: [SetLikeGame.Card] {
        game.deck
    }
    
    func rank(for card: SetLikeGame.Card) -> Int {
        guard let rank = card.properties["rank"]?.value as? Int else {
            return 0
        }
        return rank
    }
    
//    @ViewBuilder
    func form(for card: SetLikeGame.Card) -> AnyShape {
        if let shape = card.properties["form"]?.value as? AnyShape {
            return shape
        } else {
            return AnyShape(Circle())
        }
    }
    
    func hue(for card: SetLikeGame.Card) -> Color {
        guard let hue = card.properties["hue"]?.value as? Color else {
            return Color.black
        }
        return hue
    }

    
}

extension Shape {
    @ViewBuilder
    func sgFill(for card: SetLikeGame.Card) -> some View {
        if let fill = card.properties["fill"]?.description {
            ZStack{
                switch fill {
                case "stroked":
                    self.fill().opacity(0)
                case "shaded":
                    self.fill().opacity(0.2)
                case "filled":
                    self.fill()
                default:
                    self
                }
                self.stroke(lineWidth: 2)
            }
            
        } else {
            self
        }
        
    }
}

