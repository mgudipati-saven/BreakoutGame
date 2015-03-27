//
//  BreakoutBehavior.swift
//  BreakoutGame
//
//  Created by Murty Gudipati on 3/18/15.
//  Copyright (c) 2015 Murty Gudipati. All rights reserved.
//

import UIKit

class BreakoutBehavior: UIDynamicBehavior, UICollisionBehaviorDelegate
{
    lazy var gravity: UIGravityBehavior = {
        let lazyGravity = UIGravityBehavior()
        lazyGravity.gravityDirection = CGVector(dx: 0.5, dy: -0.5)
        return lazyGravity
    }()
    
    lazy var collider: UICollisionBehavior = {
        let lazyCollider = UICollisionBehavior()
        lazyCollider.collisionDelegate = self
        lazyCollider.action = { [unowned self] in
            if let ball = lazyCollider.items.first as? UIView {
                if let rect1 = lazyCollider.dynamicAnimator?.referenceView?.frame {
                    let rect2 = ball.frame
                    if !CGRectContainsRect(rect1, rect2) {
                        self.removeBall(ball)
                    }
                }
            }
        }
        return lazyCollider
    }()

    lazy var pusher: UIPushBehavior = {
        let lazyPusher = UIPushBehavior(items: [], mode: UIPushBehaviorMode.Instantaneous)
        lazyPusher.angle = CGFloat(M_PI / 4)
        lazyPusher.magnitude = CGFloat(-0.1)
        return lazyPusher
        }()

    lazy var ballBehavior: UIDynamicItemBehavior = {
        let lazyBehavior = UIDynamicItemBehavior()
        lazyBehavior.elasticity = 1.0
        lazyBehavior.allowsRotation = false
        lazyBehavior.friction = 0.0
        lazyBehavior.resistance = 0.0
        return lazyBehavior
    }()

    override init() {
        super.init()
        addChildBehavior(collider)
        addChildBehavior(pusher)
        addChildBehavior(ballBehavior)
    }

    func addBall(ball: UIView) {
        dynamicAnimator?.referenceView?.addSubview(ball)
        pusher.addItem(ball)
        collider.addItem(ball)
        ballBehavior.addItem(ball)
    }
    
    func removeBall(ball: UIView) {
        collider.removeItem(ball)
        pusher.removeItem(ball)
        ballBehavior.removeItem(ball)
        ball.removeFromSuperview()
    }
    
    var bricks = [String:UIView]()
    
    func setBricks(newBricks: [[UIView]]) {
        for brick in bricks {
            collider.removeBoundaryWithIdentifier(brick.0)
        }
        
        for row in 0 ..< newBricks.count {
            for col in 0 ..< newBricks[row].count {
                var name = "Brick \(row),\(col)"
                var view = newBricks[row][col]
                bricks[name] = view
                if view.hidden != true {
                    var path = UIBezierPath(rect: view.frame)
                    addBarrier(path, named: name)
                }
            }
        }
    }
    
    func addBarrier(path: UIBezierPath, named name: String) {
        collider.removeBoundaryWithIdentifier(name)
        collider.addBoundaryWithIdentifier(name, forPath: path)
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying, atPoint p: CGPoint) {
        if let boundary = identifier as? String {
            if boundary.rangeOfString("Brick") != nil {
                collider.removeBoundaryWithIdentifier(boundary)
                if let view = bricks[boundary] {
                    view.hidden = true
                }
            }
        }
    }
}
