//
//  SwipeView.swift
//  MusicalMatchThe
//
//  Created by Joshua Kuehn on 5/6/15.
//  Copyright (c) 2015 Joshua Kuehn. All rights reserved.
//

import Foundation
import UIKit

class SwipeView: UIView {
    
    var overlay:UIImageView = UIImageView()
    
    enum Direction {
        
        case None
        case Left
        case Right
    }
    
    var direction:Direction?
    
    weak var delegate: SwipeViewDelegate?
    
//    private let card:CardView = CardView()
    
    var innerView:UIView? {
        didSet {
            if let v = innerView {
                self.insertSubview(v, belowSubview: overlay)
                v.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
            }
        }
    }
    
    private var orginalPoint:CGPoint?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        
    }
    
    override init() {
        super.init()
        initialize()
        
    }
    
    private func initialize () {
        self.backgroundColor = UIColor.clearColor()
        
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "dragged:"))
        
        overlay.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        addSubview(overlay)
    }
    
    func dragged(gestureRecognizer: UIPanGestureRecognizer) {
        let distance = gestureRecognizer.translationInView(self)
//        println("Distance x: \(distance.x) y: \(distance.y)")
        
        switch gestureRecognizer.state {
        case UIGestureRecognizerState.Began:
            orginalPoint = center
        case UIGestureRecognizerState.Changed:
            
//            let rotationPercent = min(distance.x/(self.superview!.frame.width/2),1)
//            let rotationAngle = (CGFloat(2*M_PI/16)*rotationPercent)
//            transform = CGAffineTransformMakeRotation(rotationAngle)
            
            var x = orginalPoint!.x + distance.x
            
//            println("original point: \(orginalPoint!.x), distance traveled: \(distance.x)")
//            println(x)
            
            center = CGPointMake(constrainDistanceTraveled(distance.x, originalPoint: orginalPoint!.x), orginalPoint!.y)
            
            updateOverlay(distance.x)
            
        case UIGestureRecognizerState.Ended:
            if abs(distance.x) < frame.width/4 {
                resetViewPositionAndTransformations()
            }
            else {
                swiped(distance.x > 0 ? .Right : .Left)
            }
            
        default:
            println("default triggered for gestureRecognizer")
            break
        }
        
    }
    
    func swiped(s:Direction) {
        
        if s == .None {
            return
        }
        var parentWidth = superview!.frame.size.width
        if s == .Left {
            parentWidth *= -1
        }
        
        UIView.animateWithDuration(0.35, animations: {
            self.center.x = self.frame.origin.x + parentWidth
            }, completion: {
                success in
                if let d = self.delegate {
                    s == .Right ? d.swipedRight() : d.swipedLeft()
                }
        })
    }
    
    private func updateOverlay(distance:CGFloat) {
        
        var newDirection:Direction
        newDirection = distance < 0 ? .Left : .Right
        
        if newDirection != direction {
            direction = newDirection
            overlay.image = direction == .Right ? UIImage(named: "yeah-stamp") : UIImage(named: "nah-stamp")
        }
        overlay.alpha = abs(distance) / (self.superview!.frame.width/2)
        
    }
    
    private func resetViewPositionAndTransformations() {
        UIView.animateWithDuration(0.35, animations: { () -> Void in
            self.center = self.orginalPoint!
            
            self.transform = CGAffineTransformMakeRotation(0)
            self.overlay.alpha = 0
        })
    }
    
    func constrainDistanceTraveled (distanceTraveled:CGFloat, originalPoint: CGFloat) -> CGFloat {
        var x = distanceTraveled
        var max:CGFloat = 50
        var min:CGFloat = -50
        if x > 50 {
            x = max + originalPoint
            println("x > 50")
            return x
        }
        else if x < min {
            x = min + originalPoint
            println("x < -50 ")
            return x
        }
        else {
            println(x + originalPoint)
        }
            return x + originalPoint
    }
    

}

protocol SwipeViewDelegate:class {
    func swipedLeft()
    func swipedRight()
}





