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
                VStack(spacing: 0) {
                    Spacer()
                    ForEach(0..<sg.rank(for: card)) { _ in
                        sg.form(for: card)
                            .sgFill(sg.fill(for: card))
                            .aspectRatio(2, contentMode: .fit)
                            .padding(.vertical, 5)
                    }
                    .foregroundColor(sg.hue(for: card))
                    .padding(.horizontal, 20)
                    Spacer()
                }
                .cardify(isFaceUp: true, cardBack: Rectangle().fill())
                .aspectRatio(5/7, contentMode: .fit)
                .padding(5)
            }
            .foregroundColor(.purple)
            .padding()
        }
    }
}

extension InsettableShape {
    @ViewBuilder
    func sgFill(_ fill: String) -> some View {
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
            self.strokeBorder(lineWidth: 2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGame()
        ContentView(sg: game)
            .preferredColorScheme(.dark)
    }
}
