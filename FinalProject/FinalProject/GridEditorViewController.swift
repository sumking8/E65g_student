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
//    var saveClosure: ((String) -> Void)?
    var grid : GridProtocol = Grid(10, 10)
    //var engine : EngineProtocol = StandardEngine.engine
    
    @IBOutlet weak var fruitValueTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        gridView.grid = self.grid
/*
        if let fruitValue = fruitValue {
            fruitValueTextField.text = fruitValue
        }
*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func save(_ sender: UIBarButtonItem) {
        //engine.grid = gridView.grid!
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "GridEditorSave")
        let n = Notification(name: name, object: nil, userInfo: ["GridView" : self.gridView])
        nc.post(n)
        self.navigationController?.popViewController(animated: true)
    }
    
/*
    func showErrorAlert(withMessage msg:String, action: (() -> Void)? ) {
        let alert = UIAlertController(
            title: "Alert",
            message: msg,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            alert.dismiss(animated: true) { }
            OperationQueue.main.addOperation { action?() }
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
*/
/*
    @IBAction func save(_ sender: UIButton) {
        if let newValue = fruitValueTextField.text,
           let saveClosure = saveClosure {
            saveClosure(newValue)
            self.navigationController?.popViewController(animated: true)
        }
    }
*/

}
