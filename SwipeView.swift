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
    
    enum Direction {
        
        case None
        case Left
        case Right
    }
    
    weak var delegate: SwipeViewDelegate?
    
//    private let card:CardView = CardView()
    
    var innerView:UIView? {
        didSet {
            if let v = innerView {
                self.addSubview(v)
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
        self.backgroundColor = UIColor.redColor()
        
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "dragged:"))
    }
    
    func dragged(gestureRecognizer: UIPanGestureRecognizer) {
        let distance = gestureRecognizer.translationInView(self)
        println("Distance x: \(distance.x) y: \(distance.y)")
        
        switch gestureRecognizer.state {
        case UIGestureRecognizerState.Began:
            orginalPoint = center
        case UIGestureRecognizerState.Changed:
            
            let rotationPercent = min(distance.x/(self.superview!.frame.width/2),1)
            let rotationAngle = (CGFloat(2*M_PI/16)*rotationPercent)
            transform = CGAffineTransformMakeRotation(rotationAngle)
            
            center = CGPointMake(orginalPoint!.x + distance.x, orginalPoint!.y + distance.y)
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
    
    private func resetViewPositionAndTransformations() {
        UIView.animateWithDuration(0.35, animations: { () -> Void in
            self.center = self.orginalPoint!
            
            self.transform = CGAffineTransformMakeRotation(0)
        })
    }
    
}

protocol SwipeViewDelegate:class {
    func swipedLeft()
    func swipedRight()
}





