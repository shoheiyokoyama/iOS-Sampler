//: Playground - noun: a place where people can play

//: Playground - noun: a place where people can play

import UIKit
import XCPlayground

public class Graph: UIView{
    
    var functions : [(Double) -> Double] = []
    
    public init(frame: CGRect, function: @escaping (Double) -> Double) {
        self.functions.append(function)
        super.init(frame: frame)
    }
    
    public init(frame: CGRect, functions: [(Double) -> Double]) {
        self.functions = functions
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func draw(_ rect: CGRect) {
        let origin = CGPoint(x: rect.width / 2, y: rect.height / 2)
        var x = rect.width / 2 * -1
        while x <= rect.width / 2 {
            for f in functions {
                let y = -1 * f(Double(x))
                let r : CGFloat = 1
                let oval = UIBezierPath(ovalIn: CGRect(x: CGFloat(x) + origin.x - r / 2, y: CGFloat(y) + origin.y - r / 2, width: r, height: r))
                UIColor.blue.setFill()
                oval.fill()
            }
            x += 0.1
        }
    }
}

public class Grid: UIView{
    
    override public func draw(_ rect: CGRect) {
        
        let origin = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let r : CGFloat = 6
        let oval = UIBezierPath(ovalIn: CGRect(x: origin.x - r / 2, y: origin.y - r / 2, width: r, height: r))
        UIColor.black.setFill()
        oval.fill()
        drawLine(start:CGPoint(x: origin.x, y: 0), end: CGPoint(x: origin.x, y: rect.height), lineWidth: 1)
        drawLine(start:CGPoint(x: 0, y: origin.y), end: CGPoint(x: rect.width, y: origin.y), lineWidth: 1)
        
    }
    
    private func drawLine(start:CGPoint, end:CGPoint, lineWidth: CGFloat){
        let line = UIBezierPath()
        line.move(to: start)
        line.addLine(to: end)
        line.close()
        UIColor.black.setStroke()
        line.lineWidth = lineWidth
        line.stroke()
    }
    
    public func showLabels(rect:CGRect){
        let origin = CGPoint(x: rect.width/2, y: rect.height/2)
        
        let oLabel = UILabel(frame: CGRect(x: rect.width / 2 + 2, y: rect.height / 2 + 2, width: 14, height: 14))
        oLabel.text = "O"
        self.addSubview(oLabel)
        
        let xLabel = UILabel(frame: CGRect(x: rect.width - 16, y: origin.y, width: 14, height: 14 + 2))
        xLabel.text = "t"
        self.addSubview(xLabel)
        
        let yLabel = UILabel(frame: CGRect(x: origin.x + 2, y: 0, width: 14, height: 14))
        yLabel.text = "Y"
        self.addSubview(yLabel)
    }
}

let size = CGSize(width: 300, height: 300)
let view = UIView(frame: CGRect(origin: .zero, size: size))

let grid = Grid(frame: view.frame)
grid.backgroundColor = .white
grid.showLabels(rect: view.frame)

view.addSubview(grid)

func f1(x:Double)->Double{
    return x
}

func f2(x:Double)->Double{
    return sqrt(10000-pow(x,2)) * -1
}

let graph = Graph(frame: view.frame, functions: [f2])
graph.backgroundColor = .clear
view.addSubview(graph)

let preview = view

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
XCPlaygroundPage.currentPage.liveView = preview