//
//  Engine.swift
//  FinalProject
//
//  Created by iMac on 30/4/2017.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import Foundation

protocol EngineDelegate {
    func engineDidUpdate(withGrid: GridProtocol)
}

protocol EngineProtocol {
    var delegate : EngineDelegate? { get set }
    var grid : GridProtocol { get set }
    var refreshRate : Double { get set }
    var refreshTimer : Timer? { get set }
    var rows : Int { get set }
    var cols : Int { get set }
    var size : Int { get set }
    func step() -> GridProtocol
}

class StandardEngine : EngineProtocol {
    static var instance : EngineProtocol = StandardEngine(rows:10, cols:10)
    
    var delegate: EngineDelegate?
    var grid : GridProtocol
    var refreshRate : Double = 0.0 {
        didSet {
            if refreshRate > 0.0 {
                refreshTimer = Timer.scheduledTimer(
                    withTimeInterval: refreshRate,
                    repeats: true) {
                        (t: Timer) in
                        _ = self.step()
                }
            }
            else {
                refreshTimer?.invalidate()
                refreshTimer = nil
            }
        }
    }
    var refreshTimer : Timer?
    var rows : Int
    var cols : Int
    var size : Int {
        didSet {
            self.rows = size
            self.cols = size
        }
    }
    
    init (rows: Int, cols: Int) {
        self.size = rows
        self.rows = rows
        self.cols = cols
        
        self.grid = Grid(rows, cols, cellInitializer: Grid.gliderInitializer)
        
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "GridEditorSave")
        nc.addObserver(forName: name, object: nil, queue: nil) { (n) in
            print("At Engine before size = \(self.grid.size)")
            //let g = n.userInfo?["GridView"] as! GridView
            let g = n.userInfo?["GridEditorViewController"] as! GridEditorViewController
            self.grid = g.gridView.grid!
            self.size = (g.gridView.grid?.size.rows)!
            print("At Engine after size = \(self.grid.size)")
        }
        
    }
    
    convenience init (rows: Int, cols: Int, delegate: EngineDelegate) {
        self.init(rows: rows, cols: cols)
        
        self.delegate = delegate
    }
    
    func createNewGrid() {
        self.grid = Grid(rows, cols, cellInitializer: Grid.gliderInitializer)
        notify(withGrid: self.grid)
    }
    
    func step() -> GridProtocol {
        grid = grid.next()
        notify(withGrid: grid)
        
        return grid
    }
    private func notify(withGrid: GridProtocol) {
        //print("Grid.size: r-\(withGrid.size.rows) c-\(withGrid.size.cols)")
        //delegate?.engineDidUpdate(withGrid: withGrid)
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "EngineUpdate")
        let n = Notification(name: name, object: withGrid, userInfo: ["StandardEngine" : self])
        nc.post(n)
        
    }
}
