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
        /*
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "EngineUpdate")
        nc.addObserver(forName: name, object: nil, queue: nil) { (n) in
            self.reset()
            let engine = n.userInfo?["StandardEngine"] as! EngineProtocol
            let size = engine.grid.size
            (0 ..< size.rows).forEach { i in
                (0 ..< size.cols).forEach { j in
                    switch engine.grid[i, j] {
                    case .alive :
                        self.add(self.cAlive)
                        break
                    case .born :
                        self.add(self.cBorn)
                        break
                    case .died :
                        self.add(self.cDied)
                        break
                    case .empty :
                        self.add(self.cEmpty)
                        break
                    }

                }
            }

        }
        */
        registerEngineNotification()
        registerViewNotification()
        aView.setNeedsDisplay()
    }
    
    private func registerEngineNotification() {
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "EngineUpdate")
        nc.addObserver(forName: name, object: nil, queue: nil) { (n) in
            //self.reset()
            let engine = n.userInfo?["StandardEngine"] as! EngineProtocol
            let size = engine.grid.size
            self.count(row: size.rows, col: size.cols, g: engine.grid)
            self.aView.setNeedsDisplay()
        }
    }
    

    private func registerViewNotification() {
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "ViweUpdate")
        nc.addObserver(forName: name, object: nil, queue: nil) { (n) in
            //self.reset()
            let gridView = n.userInfo?["GridView"] as! GridView
            let size = gridView.grid?.size
            self.count(row: (size?.rows)!, col: (size?.cols)!, g: gridView.grid!)
            self.aView.setNeedsDisplay()
        }
        
    }

    
    private func count(row: Int, col: Int, g : GridProtocol) {
        (0 ..< row).forEach { i in
            (0 ..< col).forEach { j in
                switch g[i, j] {
                case .alive :
                    self.add(self.cAlive)
                    break
                case .born :
                    self.add(self.cBorn)
                    break
                case .died :
                    self.add(self.cDied)
                    break
                case .empty :
                    self.add(self.cEmpty)
                    break
                }
            }
        }
        print ("Alive: \(cAlive.text ?? "0") Born: \(cBorn.text ?? "0") Died: \(cDied.text ?? "0") Empty: \(cEmpty.text ?? "0")")
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


