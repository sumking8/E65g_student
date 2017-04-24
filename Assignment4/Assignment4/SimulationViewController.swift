//
//  SecondViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController, EngineDelegate, ViewDelegate {

    @IBOutlet weak var stepButton: UIButton!
    @IBOutlet weak var grid: GridView!

    var engine : EngineProtocol = StandardEngine.engine
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        grid.delegate = self
        engine.delegate = self
        grid.grid = engine.grid as! Grid
/*
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "EngineUpdate")
        nc.addObserver(forName: name, object: nil, queue: nil) { (n) in
                self.grid.setNeedsDisplay()
        }
*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewDidUpdate(withGrid: GridProtocol) {
        engine.grid = withGrid
    }

    func engineDidUpdate(withGrid: GridProtocol) {
        self.grid.grid = withGrid
        self.grid.setNeedsDisplay()
    }
    
    @IBAction func stepButtonAction(_ sender: Any) {
        self.grid.grid = engine.step() as! Grid
    }
}

