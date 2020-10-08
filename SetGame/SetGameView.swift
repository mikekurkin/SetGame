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
                
                HStack(alignment: .top, spacing: standardPadding) {
                    HStack(spacing: standardPadding) {
                        Text(String(sg.score)).bold()
                        
                        Button {
                            dealWithAnimation { sg.addThree() }
                        } label: { Image(systemName: "plus") }
                            .disabled(sg.unusedCardsCount == 0)
                        
                        Button {
                            dealWithAnimation { sg.newGame() }
                        } label: { Image(systemName: "shuffle") }
                        
                    }
                    ZStack {
                        GeometryReader { geometry in
                            EmptyView()
                                .cardify(isFaceUp: false)
                                .onAppear {
                                    let frame = geometry.frame(in: .global)
                                    deckFrame = frame
                                }
                                .onChange(of: geometry.frame(in: .global)) { frame in
                                    deckFrame = frame
                                }
                        }
                        .aspectRatio(cardAspectRatio, contentMode: .fit)
                        .frame(height: deckHeight)
                            
                                
                        Text(String(sg.unusedCardsCount))
                            .bold()
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .foregroundColor(.purple)
                    
                }
            }
            .font(.title)
            .padding(Edge.Set.horizontal.union(.top), standardPadding)
            .zIndex(1)
                
            Grid(sg.cards, itemDesiredAspectRatio: Double(cardAspectRatio)) { card in
                
                GeometryReader { geometry in
                    
                    let cardFrame = geometry.frame(in: .global)

                    Group {
                        VStack(spacing: 0) {
                            Spacer()
                            ForEach(0..<sg.rank(for: card)) { _ in
                                sg.shaded(sg.form(for: card), for: card)
                                .aspectRatio(2, contentMode: .fit)
                                .padding(.vertical, 5)
                            }
                            .foregroundColor(sg.hue(for: card))
                            .padding(.horizontal, 20)
                            Spacer()
                        }
                        .cardify(isFaceUp: card.isFaceUp)
                    }
                    .frame(width: card.isFaceUp ? cardFrame.size.width : deckFrame.size.width,
                           height: card.isFaceUp ? cardFrame.size.height : deckFrame.size.height)
                    .offset(x: card.isFaceUp ? 0 : deckFrame.origin.x - cardFrame.origin.x,
                            y: card.isFaceUp ? 0 : deckFrame.origin.y - cardFrame.origin.y)
                    
                }
                .aspectRatio(cardAspectRatio, contentMode: .fit)
                .scaleEffect(card.isSelected ? selectedCardScale : 1.0)
                .shadow(color: (card.isSelected && sg.selectedCardsCount == sg.cardsInSetCount) ?
                            (sg.selectedSet ? Color.green : Color.red) : Color.primary.opacity(cardShadowOpacity),
                        radius: (card.isSelected ? selectedCardShadowRadius : notSelectedCardShadowRadius))
                .padding(smallPadding)
                .onTapGesture {
                    dealWithAnimation(cardSelectAnimation) { sg.select(card) }
                }
                .transition(AnyTransition.asymmetric(insertion: .identity, removal: .move(edge: .bottom)))
            }
            .foregroundColor(.purple)
            .padding()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + cardDealDelay) {
                    dealWithAnimation { sg.deal() }
                }
            }
        }
    }
    
    func dealWithAnimation(_ animation: Animation? = nil, dealingFunction: () -> [SetLikeGame.Card]) {
        withAnimation(animation ?? cardDealAnimation) {
            let newCards = dealingFunction()
            for card in newCards {
                withAnimation(cardTurnOverAnimation
                       .delay(cardTurnOverSequenceDelay * Double((newCards.firstIndex(matching: card) ?? 0))))
                {
                    sg.makeFaceUp(card)
                }
            }
        }
    }
    
    // MARK: - Animation parameters
    
    let cardSelectAnimation: Animation      = .easeInOut(duration: 0.02)
    let cardDealAnimation: Animation        = .easeIn(duration: 0.5)
    let cardDealDelay: Double               = 0.2
    let cardTurnOverAnimation: Animation    = .easeInOut(duration: 0.5)
    let cardTurnOverSequenceDelay: Double   = 0.05
    
    // MARK: - Drawing constants
    
    let cardAspectRatio: CGFloat                = 5 / 7
    let selectedCardScale: CGFloat              = 1.04
    let selectedCardShadowRadius: CGFloat       = 10
    let notSelectedCardShadowRadius: CGFloat    = 1.5
    let cardShadowOpacity: Double               = 0.6
    let deckHeight: CGFloat                     = 80
    
    let standardPadding: CGFloat                = 25
    let smallPadding: CGFloat                   = 5
    
}

// MARK: -

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let game = SetGame()
        _ = game.select(game.cards[1])
        return ContentView(sg: game)
//            .preferredColorScheme(.dark)
    }
}
