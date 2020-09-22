//
//  Diamond.swift
//  SetGame
//
//  Created by Mike Kurkin on 18.09.2020.
//

import SwiftUI

struct Diamond: InsettableShape {
    
    var insetAmount: CGFloat = 0
    
    func inset(by amount: CGFloat) -> Diamond {
        var shape = self
        shape.insetAmount = amount
        return shape
    }
    
    func path(in rect: CGRect) -> Path {
        
        let insetRect = rect.insetBy(dx: insetAmount, dy: insetAmount)
        
        let bottom = CGPoint(x: insetRect.minX, y: insetRect.midY)
        let left = CGPoint(x: insetRect.midX, y: insetRect.minY)
        let top = CGPoint(x: insetRect.maxX, y: insetRect.midY)
        let right = CGPoint(x: insetRect.midX, y: insetRect.maxY)
        
        var p = Path()
        
        p.move(to: bottom)
        p.addLine(to: left)
        p.addLine(to: top)
        p.addLine(to: right)
        p.addLine(to: bottom)
        p.closeSubpath()
        
        return p
    }
    
}

struct Diamond_Previews: PreviewProvider {
    static var previews: some View {
        Diamond()
            .strokeBorder(lineWidth: 10)
            .aspectRatio(2, contentMode: .fit)
            .padding()
    }
}
