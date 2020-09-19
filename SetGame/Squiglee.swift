//
//  Squiglee.swift
//  SetGame
//
//  Created by Mike Kurkin on 18.09.2020.
//

import SwiftUI

struct Squiglee: Shape {
    
    func path(in rect: CGRect) -> Path {
        
        func relX(_ multiplier: CGFloat) -> CGFloat {
            return rect.minX + multiplier * rect.width
        }
        
        func relY(_ multiplier: CGFloat) -> CGFloat {
            return rect.minY + multiplier * rect.height
        }
        
        var points: [BezierPoint] = []
        
        points.append(BezierPoint(
                        x: relX(0),
                        y: relY(0.4),
                        controlAngle: Angle.degrees(90),
                        controlLength: relY(0.25))
        )
        points.append(BezierPoint(
                        x: relX(0.25),
                        y: relY(0.95),
                        controlAngle: Angle.degrees(0),
                        controlLength: relX(0.15))
        )
        points.append(BezierPoint(
                        x: relX(0.6),
                        y: relY(0.8),
                        controlAngle: Angle.degrees(0),
                        controlLength: relX(0.15))
        )
        points.append(BezierPoint(
                        x: relX(0.9),
                        y: relY(1),
                        controlAngle: Angle.degrees(0),
                        controlLength: relX(0.07))
        )
        points.append(BezierPoint(
                        x: relX(1),
                        y: relY(0.8),
                        controlAngle: Angle.degrees(270),
                        controlLength: relY(0.16))
        )
        points.append(BezierPoint(
                        x: relX(0.73),
                        y: relY(0.1),
                        controlAngle: Angle.degrees(180),
                        controlLength: relX(0.17))
        )
        points.append(BezierPoint(
                        x: relX(0.4),
                        y: relY(0.25),
                        controlAngle: Angle.degrees(180),
                        controlLength: relX(0.15))
        )
        points.append(BezierPoint(
                        x: relX(0.12),
                        y: relY(0),
                        controlAngle: Angle.degrees(180),
                        controlLength: relX(0.07))
        )
        
        let squigleeCurve = BezierCurve(points: points)
        
        let p = squigleeCurve.path
        
        return p.applying(CGAffineTransform(scaleX: 1, y: -1)).applying(CGAffineTransform(translationX: 0, y: rect.height))
    }
    
}

struct Squiglee_Preview: PreviewProvider {
    static var previews: some View {
        Squiglee()
            .aspectRatio(9 / 4, contentMode: .fit)
    }
}
