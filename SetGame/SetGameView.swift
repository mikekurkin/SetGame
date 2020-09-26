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
            HStack(alignment: .center) {
                Text("Set Game").bold()
                Spacer()
                HStack(spacing: 25) {
                    Button {
                        withAnimation(.easeInOut) {
                            sg.add(3)
                        }
                    } label: { Image(systemName: "plus") }
                    Button {
                        withAnimation(.easeInOut) {
                            sg.deal(12)
                        }
                    } label: { Image(systemName: "shuffle") }
                }
            }
            .font(.title)
            .padding()
            
            Grid(sg.cards, itemDesiredAspectRatio: 5 / 7) { card in
//                ZStack {
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
                    .scaleEffect(card.isSelected ? 1.04 : 1)
                    .shadow(color: Color.purple.opacity(card.isSelected ? 0.5 : 0), radius: 10)
                    .onTapGesture { sg.select(card) }
                    .padding(5)
                    
//                }
            }
            .foregroundColor(.purple)
            .padding()
        }
    }
}

extension InsettableShape {
    @ViewBuilder
    func sgFill(_ fill: String) -> some View {
        GeometryReader { geometry in
            ZStack{
                switch fill {
                case "stroked":
                    self.fill().opacity(0)
                case "shaded":
                    Hatch(20, at: Angle(degrees: 90), lineWidth: 0.7)
                        .clipShape(self)
                case "filled":
                    self.fill().opacity(0.5)
                default:
                    self
                }
                self.strokeBorder(lineWidth: 2)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let game = SetGame()
        game.select(game.cards[1])
        return ContentView(sg: game)
//            .preferredColorScheme(.dark)
    }
}
