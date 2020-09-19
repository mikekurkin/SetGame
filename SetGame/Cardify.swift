//
//  Cardify.swift
//  Memorize
//
//  Created by Mike Kurkin on 13.09.2020.
//

import SwiftUI

struct Cardify<BackContent>: AnimatableModifier where BackContent: View {
    
    var cardBack: BackContent
    
    var rotation: Double
    var isFaceUp: Bool {
        rotation < 90
    }
    
    init(isFaceUp: Bool, cardBack: BackContent) {
        self.rotation = 180 * (isFaceUp ? 0 : 1)
        self.cardBack = cardBack
    }
    
    var animatableData: Double {
        get { return rotation }
        set { rotation = newValue }
    }
    
    func body(content: Content) -> some View {
        ZStack {
            Group {
                RoundedRectangle(cornerRadius: cardCornerRadius, style: cardCornerStyle)
                    .fill()
                    .foregroundColor(cardBackgroundColor)
                content
                RoundedRectangle(cornerRadius: cardCornerRadius, style: cardCornerStyle)
                    .strokeBorder(lineWidth: cardStrokeLineWidth)
            }
                .opacity(isFaceUp ? 1 : 0)
            
            cardBack
                .clipShape(RoundedRectangle(cornerRadius: cardCornerRadius, style: cardCornerStyle))
                .opacity(isFaceUp ? 0 : 1)
        }
        .rotation3DEffect(
            Angle.degrees(rotation),
            axis: (x: 0, y: 1, z: 0)
        )
    }
    
    // MARK: - Drawing Constants
    
    private let cardCornerRadius: CGFloat = 14.0
    private let cardCornerStyle: RoundedCornerStyle = .continuous
    private let cardBackgroundColor: Color = .white
    private let cardStrokeLineWidth: CGFloat = 3.0
}

extension View {
    func cardify<BackContent>(isFaceUp: Bool, cardBack: BackContent) -> some View where BackContent: View {
        self.modifier(Cardify(isFaceUp: isFaceUp, cardBack: cardBack))
    }
}
