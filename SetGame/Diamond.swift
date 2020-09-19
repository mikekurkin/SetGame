//
//  Diamond.swift
//  SetGame
//
//  Created by Mike Kurkin on 18.09.2020.
//

import SwiftUI

struct Diamond: Shape {
    
    func path(in rect: CGRect) -> Path {
        let bottom = CGPoint(x: rect.minX, y: rect.midY)
        let left = CGPoint(x: rect.midX, y: rect.minY)
        let top = CGPoint(x: rect.maxX, y: rect.midY)
        let right = CGPoint(x: rect.midX, y: rect.maxY)
        
        var p = Path()
        
        p.move(to: bottom)
        p.addLine(to: left)
        p.addLine(to: top)
        p.addLine(to: right)
        p.addLine(to: bottom)
        
        return p
    }
    
}

struct Diamond_Previews: PreviewProvider {
    static var previews: some View {
        Diamond()
            .aspectRatio(9 / 4, contentMode: .fit)
    }
}
