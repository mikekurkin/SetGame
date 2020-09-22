//
//  BezierCurve.swift
//  SetGame
//
//  Created by Mike Kurkin on 19.09.2020.
//

import SwiftUI

struct BezierPoint {
    var point: CGPoint
    var control1: CGPoint
    var control2: CGPoint
    
    init(_ point: CGPoint, controlAngle: Angle, controlLength: CGFloat) {
        self.point = point
        self.control1 = CGPoint(
            x: point.x + controlLength * CGFloat(cos(controlAngle.radians)),
            y: point.y + controlLength * CGFloat(sin(controlAngle.radians))
            )
        self.control2 = CGPoint(
            x: point.x - controlLength * CGFloat(cos(controlAngle.radians)),
            y: point.y - controlLength * CGFloat(sin(controlAngle.radians))
            )
    }
    
    init(x: CGFloat, y: CGFloat, controlAngle: Angle, controlLength: CGFloat) {
        self.init(CGPoint(x: x, y: y), controlAngle: controlAngle, controlLength: controlLength)
    }
}

struct BezierCurve {
    var points: [BezierPoint]
    
    var path: Path {
        var p = Path()
        if points.count > 1 {
            p.move(to: points.first!.point)
            
            for index in 1..<points.count {
                p.addCurve(to: points[index].point, control1: points[index - 1].control1, control2: points[index].control2)
            }
            p.addCurve(to: points.first!.point, control1: points.last!.control1, control2: points.first!.control2)
            p.closeSubpath()
        }
        return p
    }
}


