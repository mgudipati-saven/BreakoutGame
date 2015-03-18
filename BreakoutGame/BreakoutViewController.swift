//
//  BreakoutViewController.swift
//  BreakoutGame
//
//  Created by Murty Gudipati on 3/18/15.
//  Copyright (c) 2015 Murty Gudipati. All rights reserved.
//

import UIKit

class BreakoutViewController: UIViewController
{
    let breakoutBehavior = BreakoutBehavior()
    
    var bricks = [[UIView]]()

    var bricksPerRow = 6
    var numRows = 4
    var brickHeight: CGFloat = 25
    var pad: CGFloat = 6
    
    var brickSize: CGSize {
        let w = (gameView.bounds.size.width - CGFloat(bricksPerRow+1) * pad) / CGFloat(bricksPerRow)
        let h = brickHeight
        return CGSize(width: w, height: h)
    }

    var ball: UIView?
    var ballSize: CGSize {
        return CGSize(width: 20, height: 20)
    }
    
    var paddle: UIView?
    var paddleSize: CGSize {
        let w = gameView.bounds.size.width / 4
        let h = brickHeight / 2
        return CGSize(width: w, height: h)
    }
    
    lazy var animator: UIDynamicAnimator = { return UIDynamicAnimator(referenceView: self.gameView) }()

    override func viewDidLoad() {
        super.viewDidLoad()
        animator.addBehavior(breakoutBehavior)
        
        // add bricks...
        for row in 0 ..< numRows {
            bricks.append([])
            for col in 0 ..< bricksPerRow {
                bricks[row].append(UIView())
                gameView.addSubview(bricks[row][col])
            }
        }
        
        // add ball...
        ball = UIView()
        gameView.addSubview(ball!)
        
        // add paddle...
        paddle = UIView()
        gameView.addSubview(paddle!)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // layout bricks...
        var brickFrame = CGRect(x: pad, y: pad, width: brickSize.width, height: brickSize.height)
        for row in 0 ..< numRows {
            brickFrame.origin.x = gameView.frame.minX + pad
            brickFrame.origin.y = gameView.frame.minY + 100 + (brickSize.height + pad) * CGFloat(row)
            for col in 0 ..< bricksPerRow {
                brickFrame.origin.x = pad + (brickSize.width + pad) * CGFloat(col)
                bricks[row][col].frame = brickFrame
                bricks[row][col].backgroundColor = UIColor.blueColor()
            }
        }
        
        // layout ball and paddle...
        var ballFrame = CGRect(x: gameView.frame.midX - ballSize.width/2,
            y: gameView.frame.maxY - ballSize.height - paddleSize.height - pad,
            width: ballSize.width, height: ballSize.height)
        ball!.backgroundColor = UIColor.redColor()
        ball?.frame = ballFrame

        var paddleFrame = CGRect(x: gameView.frame.midX - paddleSize.width/2,
            y: gameView.frame.maxY - paddleSize.height - pad,
            width: paddleSize.width, height: paddleSize.height)
        paddle!.backgroundColor = UIColor.blackColor()
        paddle?.frame = paddleFrame
    }
    
    @IBOutlet weak var gameView: BezierPathsView!
}
