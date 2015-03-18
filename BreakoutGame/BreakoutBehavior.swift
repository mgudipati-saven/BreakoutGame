//
//  BreakoutBehavior.swift
//  BreakoutGame
//
//  Created by Murty Gudipati on 3/18/15.
//  Copyright (c) 2015 Murty Gudipati. All rights reserved.
//

import UIKit

class BreakoutBehavior: UIDynamicBehavior
{
    var gravity = UIGravityBehavior()
    
    override init() {
        super.init()
        addChildBehavior(gravity)
    }

    func addBall(ball: UIView) {
        dynamicAnimator?.referenceView?.addSubview(ball)
        gravity.addItem(ball)
    }
}
