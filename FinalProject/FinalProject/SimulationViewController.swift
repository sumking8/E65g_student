//
//  SecondViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController
//, EngineDelegate
{

    @IBOutlet weak var stepButton: UIButton!
    @IBOutlet weak var grid: GridView!

    var engine : EngineProtocol = StandardEngine.engine
    
    private func registerEngineNotification() {
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "EngineUpdate")
        nc.addObserver(forName: name, object: nil, queue: nil) { (n) in
            let e = n.userInfo?["StandardEngine"] as! EngineProtocol
            self.updateGridViewGrid(withGrid: e.grid)
        }
    }
    
    private func registerGridViewNotification() {
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "ViweUpdate")
        nc.addObserver(forName: name, object: nil, queue: nil) { (n) in
            let g = n.userInfo?["GridView"] as! GridView
            self.updateEngineGrid(withGrid: g.grid!)
        }
    }

    private func registerGridEditorSaveNotification() {
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "GridEditorSave")
        nc.addObserver(forName: name, object: nil, queue: nil) { (n) in
            //let g = n.userInfo?["GridView"] as! GridView

            let g = n.userInfo?["GridEditorViewController"] as! GridEditorViewController
            self.updateEngineGrid(withGrid: g.gridView.grid!)
            self.updateGridViewGrid(withGrid: g.gridView.grid!)
        }
    }
    
    private func updateEngineGrid(withGrid: GridProtocol) {
        self.engine.grid = withGrid
    }
    
    private func updateGridViewGrid(withGrid: GridProtocol) {
        self.grid.grid = withGrid
        self.grid.setNeedsDisplay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        registerEngineNotification()
        registerGridViewNotification()
        registerGridEditorSaveNotification()
        self.grid.fireNotification = true

        if let lastSave = UserDefaults.standard.object(forKey: "lastSaveForSimulation") {
            let ls = lastSave as! Dictionary<String, Any>
            let size = ls["size"] as! Int
            let cellInitializer = { (pos: GridPosition) -> CellState in
                if let a = ls["contents"] {
                    let alive = a as! [[Int]]
                    for i in 0...alive.count - 1 {
                        if (pos.row == alive[i][0]) && (pos.col == alive[i][1]) {
                        return .alive
                    }
                }
                }
                if let b = ls["born"] {
                    let born = b as! [[Int]]
                    for i in 0...born.count - 1 {
                        if (pos.row == born[i][0]) && (pos.col == born[i][1]) {
                            return .born
                        }
                    }
                }
                if let d = ls["died"] {
                    let died = d as! [[Int]]
                    for i in 0...died.count - 1 {
                        if (pos.row == died[i][0]) && (pos.col == died[i][1]) {
                            return .died
                        }
                    }
                }
                return .empty
            }
            let g = Grid(size, size, cellInitializer: cellInitializer)
            engine.grid = g
            engine.size = size
        }
 
        self.grid.grid = engine.grid as! Grid
        
        
//        grid.delegate = self
//        engine.delegate = self

        /*
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "ViweUpdate")
        nc.addObserver(forName: name, object: nil, queue: nil) { (n) in
            let g = n.userInfo?["GridView"] as! GridView
            self.grid.grid = g.grid!
        }
*/
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


/*
    func viewDidUpdate(withGrid: GridProtocol) {
        engine.grid = withGrid
    }
*/

    func engineDidUpdate(withGrid: GridProtocol) {
        self.grid.grid = withGrid
        self.grid.setNeedsDisplay()
    }
    
    @IBAction func resetButtonAction(_ sender: UIButton, forEvent event: UIEvent) {
        if let currentSize = self.grid.grid?.size.rows {
            let g = Grid(currentSize, currentSize)
            self.updateEngineGrid(withGrid: g)
            self.updateGridViewGrid(withGrid: g)
            self.grid.notify()
        }
    }
    
    @IBAction func saveButtonAction(_ sender: Any, forEvent event: UIEvent) {
        presentAlert()
    }
    
    func presentAlert() {
        let alertController = UIAlertController(title: "New Configuation", message: "Please input a name:", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alertController.textFields?[0] {
                // store your data
                let newConfigurationName = field.text!
                let nc = NotificationCenter.default
                let name = Notification.Name(rawValue: "SimulationSave")
                let n = Notification(name: name, object: nil, userInfo: ["Name" : newConfigurationName])
                nc.post(n)
            } else {
                // user did not fill field
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func stepButtonAction(_ sender: Any) {
        self.grid.grid = engine.step() as! Grid
    }
    

}

