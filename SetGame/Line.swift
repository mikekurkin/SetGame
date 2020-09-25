//
//  Line.swift
//  SetGame
//
//  Created by Mike Kurkin on 18.09.2020.
//

import SwiftUI

struct Line: Shape {
    
    var angle: Angle
    var offset: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        
        let sinA = CGFloat(sin(angle.radians))
        let tanA = CGFloat(tan(angle.radians))
        
        let center = CGPoint(x: rect.midX + offset / sinA, y: rect.midY)
        
        func line(x: CGFloat) -> CGFloat {
            tanA * (x - center.x) + center.y
        }
        func line(y: CGFloat) -> CGFloat {
            (y - center.y) / tanA + center.x
        }
        
        // FIXME: This is a mess
        var start: CGPoint {
            if (rect.minY...rect.maxY).contains(line(x: rect.minX)) {
                return CGPoint(x: rect.minX, y: line(x: rect.minX))
            } else if (rect.minX...rect.maxX).contains(line(y: rect.minY)) {
                return CGPoint(x: line(y: rect.minY), y: rect.minY)
            } else {
                return CGPoint(x: line(y: rect.maxY), y: rect.maxY)
            }
        }
        
        var end: CGPoint {
            if (rect.minY...rect.maxY).contains(line(x: rect.maxX)) {
                return CGPoint(x: rect.maxX, y: line(x: rect.maxX))
            } else if (rect.minX...rect.maxX).contains(line(y: rect.maxY)) {
                return CGPoint(x: line(y: rect.maxY), y: rect.maxY)
            } else {
                return CGPoint(x: line(y: rect.minY), y: rect.minY)
            }
        }
        
        p.move(to: start)
        p.addLine(to: end)
        
        return p
    }
    
    init(at angle: Angle = Angle.zero, offsetBy offset: CGFloat = 0) {
        self.angle = angle == Angle.zero ? Angle.degrees(360) : angle
        self.offset = offset
    }
    
}


struct Line_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ForEach(-5..<6) { i in
                Line(at: Angle.degrees(40), offsetBy: CGFloat(30 * i))
                    .stroke(lineWidth: 5)
            }
            Rectangle().stroke()
        }
        .aspectRatio(16/9, contentMode: .fit)
        .padding(20)
            
    }
}

