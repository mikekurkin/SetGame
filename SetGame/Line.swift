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
    
    private var sinA: CGFloat
    private var tanA: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        
        // Special cases that require less calculations
        if sinA == 1 {
            let lineX = rect.midX + offset
            if rect.minX <= lineX && lineX <= rect.maxX {
                p.move(to: CGPoint(x: lineX, y: rect.minY))
                p.addLine(to: CGPoint(x: lineX, y: rect.maxY))
            }
            return p
        } else if sinA == 0 {
            let lineY = rect.midY + offset
            if rect.minY <= lineY && lineY <= rect.maxY {
                p.move(to: CGPoint(x: rect.minX, y: lineY))
                p.addLine(to: CGPoint(x: rect.maxX, y: lineY))
            }
            return p
        }
        
        let center = CGPoint(x: rect.midX + offset / sinA, y: rect.midY)
        
        func lineY(x: CGFloat) -> CGFloat {
            tanA * (x - center.x) + center.y
        }

        /// Returns an intersection point of `line` and `edge` within `edge` if it exists.
        func intersection(line: (p1: CGPoint, p2: CGPoint), edge: (p1: CGPoint, p2: CGPoint)) -> CGPoint? {
            
            let (x1, y1) = (line.p1.x, line.p1.y),
                (x2, y2) = (line.p2.x, line.p2.y),
                (x3, y3) = (edge.p1.x, edge.p1.y),
                (x4, y4) = (edge.p2.x, edge.p2.y)
            
            let den = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
            
            if den == 0 { // means parallel
                return nil
            }
            
            let enU = -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3))
            
            let pU = enU / den
            
            if !(0 <= pU && pU <= 1) { // means no intersection within the edge
                return nil
            }
            
            let pX = x3 + pU * (x4 - x3)
            let pY = y3 + pU * (y4 - y3)
            
            return CGPoint(x: pX, y: pY)
        }
        
        let line = (p1: CGPoint(x: center.x, y: center.y), p2: CGPoint(x: rect.maxX, y: lineY(x: rect.maxX)))

        let lEdge = (p1: CGPoint(x: rect.minX, y: rect.minY), p2: CGPoint(x: rect.minX, y: rect.maxY))
        let rEdge = (p1: CGPoint(x: rect.maxX, y: rect.minY), p2: CGPoint(x: rect.maxX, y: rect.maxY))
        let tEdge = (p1: CGPoint(x: rect.minX, y: rect.maxY), p2: CGPoint(x: rect.maxX, y: rect.maxY))
        let bEdge = (p1: CGPoint(x: rect.minX, y: rect.minY), p2: CGPoint(x: rect.maxX, y: rect.minY))
        
        // Points of intersections of line with each edge of containing rectangle
        let intersections = [lEdge, rEdge, tEdge, bEdge].compactMap { edge in
            intersection(line: line, edge: edge)
        }
        
        // If there are exactly two intersections, draw the line
        if intersections.count == 2 {
            p.move(to: intersections[0])
            p.addLine(to: intersections[1])
        }
        
        return p
    }
    
    init(at angle: Angle = Angle.zero, offsetBy offset: CGFloat = 0) {
        self.angle = angle == Angle.zero ? Angle.degrees(360) : angle
        self.sinA = CGFloat(sin(angle.radians))
        self.tanA = CGFloat(tan(angle.radians))
        self.offset = offset
    }
}


struct Line_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ForEach(0..<4) { i in
                Line(at: Angle.degrees(90), offsetBy: CGFloat(40 * i))
                    .stroke(lineWidth: 5)
            }
            Rectangle().stroke()
        }
        .aspectRatio(16/9, contentMode: .fit)
        .padding(20)
            
    }
}

