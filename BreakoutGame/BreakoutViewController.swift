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

    var ballSize: CGSize {
        return CGSize(width: 20, height: 20)
    }
    
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
                var view = UIView()
                view.backgroundColor = UIColor.blueColor()
                bricks[row].append(view)
                gameView.addSubview(view)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        println("viewDidLayoutSubviews")
        super.viewDidLayoutSubviews()
        
        // layout bricks...
        var brickFrame = CGRect(x: pad, y: pad, width: brickSize.width, height: brickSize.height)
        for row in 0 ..< numRows {
            brickFrame.origin.x = gameView.frame.minX + pad
            brickFrame.origin.y = gameView.frame.minY + 100 + (brickSize.height + pad) * CGFloat(row)
            for col in 0 ..< bricksPerRow {
                brickFrame.origin.x = pad + (brickSize.width + pad) * CGFloat(col)
                bricks[row][col].frame = brickFrame
            }
        }
        breakoutBehavior.setBricks(bricks)
        
        if paddle == nil {
            paddle = addPaddle()
            paddle!.backgroundColor = UIColor.blackColor()
            var path = UIBezierPath(rect: paddle!.frame)
            breakoutBehavior.addBarrier(path, named: BoundaryNames.Paddle)
        }
        
        if ball == nil {
            ball = addBall()
            ball!.backgroundColor = UIColor.redColor()
        }

        // add the wall barriers...
        var path = UIBezierPath()
        path.moveToPoint(CGPoint(x: gameView.frame.minX, y: gameView.frame.maxY))
        path.addLineToPoint(CGPoint(x: gameView.frame.minX, y: gameView.frame.minY))
        breakoutBehavior.addBarrier(path, named: BoundaryNames.LeftWall)
        
        path = UIBezierPath()
        path.moveToPoint(CGPoint(x: gameView.frame.minX, y: gameView.frame.minY))
        path.addLineToPoint(CGPoint(x: gameView.frame.maxX, y: gameView.frame.minY))
        breakoutBehavior.addBarrier(path, named: BoundaryNames.TopWall)

        path = UIBezierPath()
        path.moveToPoint(CGPoint(x: gameView.frame.maxX, y: gameView.frame.minY))
        path.addLineToPoint(CGPoint(x: gameView.frame.maxX, y: gameView.frame.maxY))
        breakoutBehavior.addBarrier(path, named: BoundaryNames.RightWall)
    }
    
    struct Constants {
        static let BallSize = CGSize(width: 20, height: 20)
        static let PaddleSize = CGSize(width: 60, height: 15)
        static let Padding = CGFloat(40)
    }
    
    var paddle: UIView?

    func addPaddle() -> UIView {
        let paddle = UIView(frame: CGRect(origin: CGPointZero, size: Constants.PaddleSize))
        paddle.center = CGPoint(x: gameView.bounds.midX, y: gameView.bounds.maxY - Constants.Padding)
        gameView.addSubview(paddle)
        return paddle
    }
  
    var ball: UIView?
  
    func addBall() -> UIView {
        let ball = UIView(frame: CGRect(origin: CGPointZero, size: Constants.BallSize))
        if paddle != nil {
            ball.center = CGPoint(x: paddle!.center.x, y: paddle!.frame.minY - paddle!.frame.size.height)
        }
        gameView.addSubview(ball)

        return ball
    }
    
    struct BoundaryNames {
        static let Paddle = "Paddle Boundary"
        static let LeftWall = "Left Wall Boundary"
        static let RightWall = "Right Wall Boundary"
        static let TopWall = "Top Wall Boundary"
        static let BottomWall = "Bottom Wall Boundary"
        static let AllWalls = "All Wall Boundary"
        static let LeftTopRightWall = "Left Top Right Wall Boundary"
    }

    @IBAction func breakout(sender: UITapGestureRecognizer) {
        breakoutBehavior.addBall(ball!)
    }
    
    var attachment: UIAttachmentBehavior? {
        willSet {
            animator.removeBehavior(attachment)
        }
        didSet {
            if attachment != nil {
                animator.addBehavior(attachment)
                attachment?.action = { [unowned self] in
                    if self.paddle?.frame.maxX > self.gameView.frame.maxX {
                        self.paddle?.frame = CGRect(x: self.gameView.frame.maxX - self.paddleSize.width - self.pad,
                            y: self.gameView.frame.maxY - self.paddleSize.height - self.pad, width: self.paddleSize.width, height: self.paddleSize.height)
                    } else if self.paddle?.frame.minX < self.gameView.frame.minX {
                        self.paddle?.frame = CGRect(x: self.gameView.frame.minX + self.pad,
                            y: self.gameView.frame.maxY - self.paddleSize.height - self.pad, width: self.paddleSize.width, height: self.paddleSize.height)
                    }
                    let path = UIBezierPath(rect: self.paddle!.frame)
                    self.breakoutBehavior.addBarrier(path, named: BoundaryNames.Paddle)
                }
            }
        }
    }
    
    @IBAction func movePaddle(sender: UIPanGestureRecognizer) {
        var gesturePoint = sender.locationInView(gameView)
        var anchorPoint = CGPoint(x: gesturePoint.x, y: paddle!.center.y)

        switch sender.state {
        case .Began:
            attachment = UIAttachmentBehavior(item: paddle!, attachedToAnchor: anchorPoint)
        case .Changed:
            attachment?.anchorPoint = anchorPoint
        case .Ended:
            attachment = nil
        default: break
        }
    }
    
    @IBOutlet weak var gameView: BezierPathsView!
}
