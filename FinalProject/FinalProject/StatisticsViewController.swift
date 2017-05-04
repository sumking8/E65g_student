//
//  StatisticsViewController.swift
//  Assignment4
//
//  Created by iMac on 21/4/2017.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    @IBOutlet weak var cAlive: UILabel!
    @IBOutlet weak var cBorn: UILabel!
    @IBOutlet weak var cDied: UILabel!
    @IBOutlet weak var cEmpty: UILabel!
    
    @IBOutlet weak var aView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        registerEngineNotification()
        registerGridViewNotification()
        registerGridEditorSaveNotification()
        
        let engine = StandardEngine.instance
        self.reset()
        self.count(row: engine.grid.size.rows, col: engine.grid.size.cols, g: engine.grid)
        aView.setNeedsDisplay()
    }
    
    // Notification from Engine
    private func registerEngineNotification() {
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "EngineUpdate")
        nc.addObserver(forName: name, object: nil, queue: nil) { (n) in
            self.reset()
            let e = n.userInfo?["StandardEngine"] as! EngineProtocol
            let size = e.grid.size
            self.count(row: size.rows, col: size.cols, g: e.grid)
            self.aView.setNeedsDisplay()
        }
    }
    
    // Notification from GridView
    private func registerGridViewNotification() {
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "ViweUpdate")
        nc.addObserver(forName: name, object: nil, queue: nil) { (n) in
            self.reset()
            let gridView = n.userInfo?["GridView"] as! GridView
            let size = gridView.grid?.size
            self.count(row: (size?.rows)!, col: (size?.cols)!, g: gridView.grid!)
            self.aView.setNeedsDisplay()
        }
    }
    
    private func registerGridEditorSaveNotification() {
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "GridEditorSave")
        nc.addObserver(forName: name, object: nil, queue: nil) { (n) in
            //let g = n.userInfo?["GridView"] as! GridView
            
            let g = n.userInfo?["GridEditorViewController"] as! GridEditorViewController
            let size = g.gridView.grid?.size
            
            self.reset()
            self.count(row: (size?.rows)!, col: (size?.cols)!, g: g.gridView.grid!)
            self.aView.setNeedsDisplay()
        }
    }

    private func count(row: Int, col: Int, g : GridProtocol) {
        //print ("Before Alive: \(cAlive.text ?? "0") Born: \(cBorn.text ?? "0") Died: \(cDied.text ?? "0") Empty: \(cEmpty.text ?? "0")")
        (0..<row).forEach { i in
            (0..<col).forEach { j in
                switch g[i, j] {
                case .alive :
                    self.add(self.cAlive)
                case .born :
                    self.add(self.cBorn)
                case .died :
                    self.add(self.cDied)
                default :
                    self.add(self.cEmpty)
                }
            }
        }
        //print ("After Alive: \(cAlive.text ?? "0") Born: \(cBorn.text ?? "0") Died: \(cDied.text ?? "0") Empty: \(cEmpty.text ?? "0")")
    }
    
    private func reset() {
        cAlive.text = "0"
        cBorn.text = "0"
        cDied.text = "0"
        cEmpty.text = "0"
    }
    
    private func add(_ label : UILabel) {
        label.text = String(Int(label.text!)! + 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


