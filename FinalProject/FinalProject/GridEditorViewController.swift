//
//  GridEditorViewController.swift
//  Lecture11
//
//  Created by Van Simmons on 4/17/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

class GridEditorViewController : UIViewController {
    
    @IBOutlet weak var gridView: GridView!
    var grid : GridProtocol = Grid(10, 10)
    var name : String = ""
    let sTitle : String = "Grid Editor"
    
    @IBOutlet weak var fruitValueTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        gridView.grid = self.grid
        navigationItem.title = sTitle + ":" + name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Action for the save button
    @IBAction func save(_ sender: UIBarButtonItem) {
        //engine.grid = gridView.grid!
        presentAlert()
    }
    
    private func presentAlert() {
        let alertController = UIAlertController(title: "Configuation", message: "Change the name of the current profile?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alertController.textFields?[0] {
                self.name = field.text!
                let nc = NotificationCenter.default
                let name = Notification.Name(rawValue: "GridEditorSave")
                //let n = Notification(name: name, object: nil, userInfo: ["GridView" : self.gridView])
                let n = Notification(name: name, object: nil, userInfo: ["GridEditorViewController" : self])
                nc.post(n)
                self.navigationController?.popViewController(animated: true)
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
        alertController.textFields?[0].text = self.name
        
        self.present(alertController, animated: true, completion: nil)
    }
}
