//
//  AnyShape.swift
//  SetGame
//
//  Created by Mike Kurkin on 22.09.2020.
//

import SwiftUI

struct AnyShape: Shape {
    init<S: Shape>(_ wrapped: S) {
        _path = { rect in
            let path = wrapped.path(in: rect)
            return path
        }
    }

    func path(in rect: CGRect) -> Path {
        return _path(rect)
    }

    private let _path: (CGRect) -> Path
}

struct AnyInsettableShape: InsettableShape {
    
    init<S: InsettableShape>(_ wrapped: S) {
        
        _path = { rect in
            let path = wrapped.path(in: rect)
            return path
        }
        
        _inset = { amount -> AnyInsettableShape in
            let inset = wrapped.inset(by: amount)
            return AnyInsettableShape(inset)
        }
    }

    func path(in rect: CGRect) -> Path {
        return _path(rect)
    }
    
    func inset(by amount: CGFloat) -> AnyInsettableShape {
        return _inset(amount)
    }

    private let _path: (CGRect) -> Path
    private let _inset: (CGFloat) -> AnyInsettableShape
}
