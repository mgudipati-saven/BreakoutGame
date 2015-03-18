//
//  BezierPathsView.swift
//  BreakoutGame
//
//  Created by Murty Gudipati on 3/18/15.
//  Copyright (c) 2015 Murty Gudipati. All rights reserved.
//

import UIKit

class BezierPathsView: UIView
{
    private var bezierPaths = [String:UIBezierPath]()
    
    func setPath(path: UIBezierPath?, named name: String) {
        bezierPaths[name] = path
        setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        for (_, path) in bezierPaths {
            path.stroke()
        }
    }
}
