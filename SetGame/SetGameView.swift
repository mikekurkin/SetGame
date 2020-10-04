//
//  SetGameView.swift
//  SetGame
//
//  Created by Mike Kurkin on 18.09.2020.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var sg: SetGame
    
    @State private var deckFrame = CGRect()
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text("Set").bold()
                Spacer()
                HStack(alignment: .top, spacing: 25) {
                    HStack(spacing: 25) {
                        Text(String(sg.score)).bold()
                        
                        Button {
                            withAnimation(.easeInOut) {
                                sg.addThree()
                            }
                        } label: { Image(systemName: "plus") }
                            .disabled(sg.unusedCardsCount == 0)
                        Button {
                            withAnimation(.easeInOut) {
                                sg.newGame()
                            }
                        } label: { Image(systemName: "shuffle") }
                    }
                    ZStack{
                        GeometryReader { geometry in
                            Group{
                                Group {}
                                    .cardify(isFaceUp: false)
                                    
                            }
                            .onAppear {
                                let frame = geometry.frame(in: .global)
                                deckFrame = frame
                                print(frame)
                            }
                            .onChange(of: geometry.frame(in: .global)) { frame in
                                deckFrame = frame
                                print(frame)
                            }
                        }
                        .aspectRatio(5/7, contentMode: .fit)
                        .frame(height: 80)
                            
                                
                        Text(String(sg.unusedCardsCount))
                            .bold()
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .foregroundColor(.purple)
                }
            }
            .font(.title)
            .padding(.horizontal, 25)
            .padding(.top, 25)
            .padding(.bottom, 0)
                
            Grid(sg.cards, itemDesiredAspectRatio: 5 / 7) { card in
                GeometryReader { geometry in
                    let cardFrame = geometry.frame(in: .global)
//                    if card.isOnScreen {
                        Group {
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
                            .cardify(isFaceUp: card.isFaceUp)
                            .aspectRatio(5/7, contentMode: .fit)
                            .clipped()
                            .scaleEffect(card.isSelected ? 1.04 : 1)
                            .shadow(color: (card.isSelected && sg.selectedCardsCount == sg.cardsInSetCount) ?
                                        (sg.selectedSet ? Color.green : Color.red) : Color.primary.opacity(0.6),
                                    radius: (card.isSelected ? 10 : 1.5))
                            .padding(5)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.02)) { sg.select(card) }
                            }
                        }
                        .scaleEffect(x: card.isFaceUp ? 1.0 : deckFrame.size.width / cardFrame.size.width,
                                     y: card.isFaceUp ? 1.0 : deckFrame.size.height / cardFrame.size.height,
                                     anchor: .topLeading)
                        .offset(x: card.isFaceUp ? 0 : deckFrame.origin.x - cardFrame.origin.x,
                                y: card.isFaceUp ? 0 : deckFrame.origin.y - cardFrame.origin.y)
                        
//                    }
                    
                }
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.0)){ sg.turnOverOnScreenCards() }
                }
                
            }
            .foregroundColor(.purple)
            .padding()
            .onAppear {
                DispatchQueue.main.asyncAfter(
                    deadline: .now() + 0.2,
                    execute: {
                        withAnimation(.easeInOut(duration: 0.5)) { sg.deal() }
                    }
                )
            }
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
                case "striped":
//                    self.fill().opacity(0.8)
                    // FIXME: - Something wrong happens here with squiggle and diamond
                    Hatch(14, at: Angle(degrees: 90), lineWidth: 1)
                        .clipShape(self)
                case "solid":
                    self.fill().opacity(0.5)
                default:
                    self
                }
                self.strokeBorder(lineWidth: 3)
            }
//            .clipShape(self)
        
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
