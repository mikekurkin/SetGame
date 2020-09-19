//
//  SetGameView.swift
//  SetGame
//
//  Created by Mike Kurkin on 18.09.2020.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var sg: SetGame
    
    
    
    var body: some View {
        VStack {
            Grid(Array(sg.deck.shuffled().prefix(upTo: 12)), itemDesiredAspectRatio: 5 / 7) { card in
                Group{
                    VStack(spacing: 0) {
                        Spacer()
                        ForEach(0..<sg.rank(for: card)) { _ in
                            sg.form(for: card)
                                .sgFill(for: card)
                                .aspectRatio(2, contentMode: .fit)
                                .padding(.vertical, 5)
                        }
                        .foregroundColor(sg.hue(for: card))
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .cardify(isFaceUp: true, cardBack: Rectangle().fill())
                    .padding(5)
                }
                .aspectRatio(5/7, contentMode: .fit)
                
            }
            .foregroundColor(.purple)
            .padding()
        }

    }
}


struct CardView<BackContent>: View where BackContent: View {
    var card: SetLikeGame.Card
    var back: BackContent
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                
            }
            .cardify(isFaceUp: true, cardBack: back)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGame()
        ContentView(sg: game)
    }
}
