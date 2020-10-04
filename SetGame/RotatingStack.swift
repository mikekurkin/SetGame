//
//  Grid.swift
//  Memorize
//
//  Created by Mike Kurkin on 09.09.2020.
//

import SwiftUI

struct RotatingStack<Content>: View where Content: View {
    
    private var content: () -> Content
    private var itemDesiredAspectRatio: Double = 1
    
    private var inverseOrientation: Bool
    
    init(inverseOrientation: Bool = false, @ViewBuilder content: @escaping () -> Content) {
        self.inverseOrientation = inverseOrientation
        self.content = content
    }
    
    private func isPortrait(_ geometry: GeometryProxy) -> Bool {
        geometry.size.height >= geometry.size.width
    }

    var body: some View {
        GeometryReader { geometry in
            let shouldBeVStack = (isPortrait(geometry) != inverseOrientation)
            if shouldBeVStack {
                VStack {
                    content()
                }.onAppear{print("VStack", geometry.size)}
            } else {
                HStack {
                    content()
                }.onAppear{print("HStack", geometry.size)}
            }
        }
    }
}

