//
//  GridView.swift
//  Assignment3
//
//  Created by andre on 22/3/2017.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class GridView : UIView {
   
    @IBInspectable var size : Int = 20 {
        didSet {
            grid = Grid(size, size)
        }
    }

    @IBInspectable var livingColor : UIColor = UIColor.red
    @IBInspectable var bornColor : UIColor = UIColor.blue
    @IBInspectable var emptyColor : UIColor = UIColor.green
    @IBInspectable var diedColor : UIColor = UIColor.yellow
    @IBInspectable var gridColor : UIColor = UIColor.black
    @IBInspectable var gridWidth : CGFloat = 2

    var grid : Grid = Grid(20, 20, cellInitializer: gliderInitializer)
    
    override func draw(_ rect: CGRect) {
        //draw all the lines first
        (0 ..< size + 1).forEach {
            drawLine(
                start: CGPoint(x: CGFloat($0)/CGFloat(size) * rect.size.width, y: 0.0),
                end:   CGPoint(x: CGFloat($0)/CGFloat(size) * rect.size.width, y: rect.size.height),
                lineWidth: gridWidth, lineColor: gridColor
            )
            drawLine(
                start: CGPoint(x: 0.0, y: CGFloat($0)/CGFloat(size) * rect.size.height ),
                end: CGPoint(x: rect.size.width, y: CGFloat($0)/CGFloat(size) * rect.size.height),
                lineWidth: gridWidth, lineColor: gridColor
            )
        }

        // draw rectangle
        let cgSize = CGSize(
            width: rect.size.width / CGFloat(size),
            height: rect.size.height / CGFloat(size)
        )
        let base = rect.origin

        (0 ..< size).forEach { i in
            (0 ..< size).forEach { j in
                let origin = CGPoint(
                    x: base.x + (CGFloat(i) * cgSize.width),
                    y: base.y + (CGFloat(j) * cgSize.height)
                )
                let subRect = CGRect(
                    origin: origin,
                    size: cgSize
                )

                switch grid[Position(i, j)] {
                case .alive :
                    drawCircle(position: subRect, color: livingColor)
                    break
                case .born :
                    drawCircle(position: subRect, color: bornColor)
                    break
                case .died :
                    drawCircle(position: subRect, color: diedColor)
                    break
                case .empty :
                    drawCircle(position: subRect, color: emptyColor)
                    break
                }
            }
        }
    }

    func drawCircle(position: CGRect, color:UIColor) {
        let path = UIBezierPath(ovalIn: position)
        color.setFill()
        path.fill()
    
    }
    
    func drawLine(start:CGPoint, end: CGPoint, lineWidth:CGFloat, lineColor:UIColor) {
        let path = UIBezierPath()
        
        //set the path's line width to the height of the stroke
        path.lineWidth = lineWidth
        
        //move the initial point of the path
        //to the start of the horizontal stroke
        path.move(to: start)
        
        //add a point to the path at the end of the stroke
        path.addLine(to: end)
        
        lineColor.setFill()
        
        //draw the stroke
        lineColor.setStroke()
        path.stroke()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //lastTouchedPosition = process(touches: touches)
        processTouch(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //lastTouchedPosition = process(touches: touches)
        processTouch(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //lastTouchedPosition = nil
    }
    
    private func processTouch(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation : CGPoint = touch.location(in:self)

            let ansX = Float(touchLocation.x) * Float(size) / Float(self.frame.size.width)
            let ansY = Float(touchLocation.y) * Float(size) / Float(self.frame.size.height)
            let rX : Int = Int(Float(touchLocation.x).truncatingRemainder(dividingBy:Float(size)))
            let rY : Int = Int(Float(touchLocation.y).truncatingRemainder(dividingBy: Float(size)))
            let x : Int = (ansX < 1) ? 0 : ((rX > 0) ? Int(floor(ansX)) : Int(ansX))
            let y : Int = (ansY < 1) ? 0 : ((rY > 0) ? Int(floor(ansY)) : Int(ansY))
            grid[Position(x, y)] = grid[Position(x, y)].toggle(value:grid[Position(x, y)])
        }
        setNeedsDisplay()
    }

}


