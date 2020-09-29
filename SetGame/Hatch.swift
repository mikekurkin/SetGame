//
//  Hatch.swift
//  SetGame
//
//  Created by Mike Kurkin on 22.09.2020.
//

import SwiftUI

struct Hatch: View {
    
    var numberOfLines: Int
    var angle: Angle
    var lineWidth: CGFloat
    
    private var sinA: CGFloat
    
    private var linesDistance: Double
    
    private var linePositions: [CGFloat]
    
    private func hatchingWidth(for size: CGSize, at angle: Angle) -> CGFloat {
        
        if sinA == 0 {
            return size.height
        } else if sinA == 1 {
            return size.width
        }
        
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        
        func line(x: CGFloat) -> CGFloat { CGFloat(tan(angle.radians)) * (x - center.x) + center.y }
        func line(y: CGFloat) -> CGFloat { (y - center.y) / CGFloat(tan(angle.radians)) + center.x }

        let height = size.height
        let width = size.width
        let corners = [CGPoint(x: 0, y: 0), CGPoint(x: 0, y: height), CGPoint(x: width, y: 0), CGPoint(x: width, y: height)]
        let distances = corners.map { corner in
            abs(line(y: corner.y) - corner.x) * abs(CGFloat(sin(angle.radians)))
        }.sorted(by: >)
        return distances.prefix(2).reduce(0, +)
    }
    
    var body: some View {
        GeometryReader { geometry in
            let hatchingWidth = self.hatchingWidth(for: geometry.size, at: angle)
            ZStack {
                ForEach(0..<numberOfLines) { i in
                    Line(at: angle, offsetBy: linePositions[i] * hatchingWidth)
                        .stroke(lineWidth: lineWidth)
                }
            }
        }
    }
    
    init(_ numberOfLines: Int, at angle: Angle = Angle(degrees: 45), lineWidth: CGFloat = 2.0) {
        self.numberOfLines = numberOfLines
        self.lineWidth = lineWidth
        self.angle = angle
        self.sinA = CGFloat(sin(angle.radians))
        self.linesDistance =  1 / Double(numberOfLines + 1)
        self.linePositions = Array(1...numberOfLines).map { index in
            CGFloat(index) / CGFloat(numberOfLines + 1) - 0.5
        }
    }
    
//    init(distanceBetweenLines: Int) {
//        self.numberOfLines = Int(size / CGFloat(distanceBetweenLines))
// TODO: Implement variant with fixed distance between lines
//    }
}


struct Hatch_Previews: PreviewProvider {
    static var previews: some View {
            ZStack {
                Hatch(12, at: Angle(degrees: 90), lineWidth: 5)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(lineWidth: 10)
        }
        .frame(width: 270, height: 400, alignment: .center)
        .foregroundColor(.blue)
    }
}
