//
//  FirstViewController.swift
//  FinalProject
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dataHelper = DataHelper.instance
    @IBOutlet weak var onOffSwitch: UISwitch!
    @IBOutlet weak var sizeTextField: UITextField!
    
    @IBOutlet weak var colLabel: UILabel!
    @IBOutlet weak var rowLabel: UILabel!
    @IBOutlet weak var refreRateLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshRateSlider: UISlider!
    
    var engine : EngineProtocol = StandardEngine.instance
    
    // Notification from GridEditor when save
    private func registerGridEditorSaveNotification() {
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "GridEditorSave")
        nc.addObserver(forName: name, object: nil, queue: nil) { (n) in
            //let g = n.userInfo?["GridView"] as! GridView
            let g = n.userInfo?["GridEditorViewController"] as! GridEditorViewController
            if let size = g.gridView.grid?.size.rows {
                self.sizeTextField.text = String(describing: size)
                self.colLabel.text = self.sizeTextField.text
                self.rowLabel.text = self.sizeTextField.text
                
                // update the table view name
                let indexPath = self.tableView.indexPathForSelectedRow
                if let indexPath = indexPath {
                    let oldName = self.dataHelper.data[indexPath.section][indexPath.row]
                    self.dataHelper.data[indexPath.section][indexPath.row] = g.name
                    self.tableView.reloadData()
                    
                    // update the userdefault
                    if let dData = UserDefaults.standard.array(forKey: "json") {
                        var defaultData = dData as! [Dictionary<String, Any>]
                        if defaultData.count > 1 {
                            for i in 0...defaultData.count - 1 {
                                let defaultTitle = defaultData[i]["title"] as! String
                                if oldName ==  defaultTitle {
                                    defaultData[i]["title"] = g.name
                                    UserDefaults.standard.set(defaultData, forKey: "json")
                                    UserDefaults.standard.synchronize()
                                    break
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Notification from SimulationEditor when save
    private func registerSimulationSaveNotification() {
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "SimulationSave")
        nc.addObserver(forName: name, object: nil, queue: nil) { (n) in
            let newConfigurationName = n.userInfo?["Name"] as! String
            self.addRowToTable(withName: newConfigurationName, source: "SimulationSave")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // To ensure the data is avaaliable
        
        // To ensure the data are back from the network before showing it
        while (!dataHelper.loaded) {
            usleep(1000)
        }
        self.tableView.reloadData()
        registerGridEditorSaveNotification()
        registerSimulationSaveNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //navigationController?.isNavigationBarHidden = true
        
    }
    
    // Action on the On/Off Switch
    @IBAction func switchAction(_ sender: Any, forEvent event: UIEvent) {
        //self.tableView.reloadData()
        if onOffSwitch.isOn {
            if let size = Int(sizeTextField.text!) {
                if engine.size != size {
                    engine.size = size
                }
            }
            let refresh = Double(refreshRateSlider.value)
            if engine.refreshRate != refresh {
                engine.refreshRate = 0.0
                engine.refreshRate = 1/refresh
            }
        } else {
            engine.refreshRate = 0.0
        }
    }
    
    // Action for the refresh bar
    @IBAction func refreshRateSlide(_ sender: Any, forEvent event: UIEvent) {
        let interval = Double(1/refreshRateSlider.value)
        let sInterval = String(format: "%.2f", refreshRateSlider.value)
        print("Value: \(refreshRateSlider.value) and \(interval) and \(sInterval)" )
        refreRateLabel.text = "Ref. Rate \(sInterval) Hz"
        if onOffSwitch.isOn {
            engine.refreshRate = 0.0
            engine.refreshRate = interval
        }
    }
    
    // Action for the TextField size
    @IBAction func editEndOnExit(_ sender: Any, forEvent event: UIEvent) {
        if let size = Int(sizeTextField.text!) {
            colLabel.text = sizeTextField.text
            rowLabel.text = sizeTextField.text
            print("Size=\(size)")
            if onOffSwitch.isOn {
                if engine.size != size {
                    engine.size = size
                }
            }
        }
    }
    // Action for the "+" button
    @IBAction func addRow(_ sender: UIButton) {
        //tableView.reloadData()
        presentAlert()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataHelper.data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataHelper.data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "basic"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let title = cell.contentView.subviews.first as! UILabel
        //        print(data[indexPath.section][indexPath.item])
        title.text = dataHelper.data[indexPath.section][indexPath.item]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataHelper.sectionHeaders[section]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let title = dataHelper.data[indexPath.section][indexPath.row]
            var newData = dataHelper.data[indexPath.section]
            newData.remove(at: indexPath.row)
            dataHelper.data[indexPath.section] = newData
            
            // Updating the data in UserDefault
            if let dData = UserDefaults.standard.array(forKey: "json") {
                var defaultData = dData as! [Dictionary<String, Any>]
                if defaultData.count > 0 {
                    for i in 0...defaultData.count - 1 {
                        let defaultTitle = defaultData[i]["title"] as! String
                        if title ==  defaultTitle {
                            defaultData.remove(at: i)
                            UserDefaults.standard.set(defaultData, forKey: "json")
                            UserDefaults.standard.synchronize()
                            break
                        }
                    }
                }
            }
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPathForSelectedRow
        if let indexPath = indexPath {
            let configureValue = dataHelper.data[indexPath.section][indexPath.row]
            
            let jArray = dataHelper.jsonArray
            for i in 0...jArray.count - 1 {
                let jsonDictionary = jArray[i]
                let title = jsonDictionary["title"] as! String
                if configureValue == title {
                    var maxRowCol = 0
                    if let size = jsonDictionary["size"] {
                        maxRowCol = size as! Int
                    } else {
                        let jsonContents = jsonDictionary["contents"] as! [[Int]]
                        for i in 0...jsonContents.count - 1 {
                            if jsonContents[i][0] > maxRowCol {
                                maxRowCol = jsonContents[i][0]
                            }
                            if (jsonContents[i][1] > maxRowCol) {
                                maxRowCol = jsonContents[i][1]
                            }
                        }
                        maxRowCol = maxRowCol * 2
                    }
                    let cellInitializer : ((GridPosition) -> CellState) = {
                        (pos: GridPosition) -> CellState in
                        if let a = jsonDictionary["contents"] {
                            let alive = a as! [[Int]]
                            if alive.count > 0 {
                                for i in 0...alive.count - 1 {
                                    if (pos.row == alive[i][0]) && (pos.col == alive[i][1]) {
                                        return .alive
                                    }
                                }
                            }
                        }
                        if let b = jsonDictionary["born"] {
                            let born = b as! [[Int]]
                            if born.count > 0 {
                                for i in 0...born.count - 1 {
                                    if (pos.row == born[i][0]) && (pos.col == born[i][1]) {
                                        return .born
                                    }
                                }
                            }
                        }
                        if let d = jsonDictionary["died"] {
                            let died = d as! [[Int]]
                            if died.count > 0 {
                                for i in 0...died.count - 1 {
                                    if (pos.row == died[i][0]) && (pos.col == died[i][1]) {
                                        return .died
                                    }
                                }
                            }
                        }
                        return .empty
                    }
                    
                    print(type(of:segue.destination))
                    if let vc = segue.destination as? GridEditorViewController {
                        vc.grid = Grid(maxRowCol, maxRowCol, cellInitializer: cellInitializer)
                        let indexPath = self.tableView.indexPathForSelectedRow
                        if let indexPath = indexPath {
                            vc.name = self.dataHelper.data[indexPath.section][indexPath.row]
                        }
                    }
                }
                
            }
        }
    }
    
    // Add a new row to table
    private func addRowToTable(withName: String, source: String) {
        /*
        var iArray = [[Int]]()
        var bArray = [[Int]]()
        var dArray = [[Int]]()
        var eArray = [[Int]]()
        let size = engine.size
        for i in 0...size {
            for j in 0...size {
                switch engine.grid[i, j] {
                case .alive:
                    iArray.append([i,j])
                case .born : bArray.append([i,j])
                case .died : dArray.append([i,j])
                default: eArray.append([i,j])
                }
            }
        }
        var dict = Dictionary<String, Any>()
        dict["title"] = withName
        dict["contents"] = iArray
        dict["size"] = engine.size
        if bArray.count > 0 {
            dict["born"] = bArray
        }
        if dArray.count > 0 {
            dict["died"] = dArray
        }
         */

        let dict = DataHelper.instance.formatNewData(title:withName)
        
        // Update the UserDefault
        self.saveUserDefault(title: withName, dict: dict, source:source)
        
        // Update table
        dataHelper.data[0].append(withName)
        dataHelper.jsonArray.append(dict)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: dataHelper.data[0].count-1, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    
    private func saveUserDefault(title:String, dict:Dictionary<String, Any>, source:String) {
        if let mySavedArray = UserDefaults.standard.object(forKey: "json") {
            var array = mySavedArray as! [Dictionary<String, Any>]
            //var newArray = [Dictionary<String, Any>]()
            var foundInExistingArray = false
            for i in 0...array.count - 1 {
                let d = array[i]
                let t = d["title"] as! String
                if title == t {
                    array[i] = dict
                    foundInExistingArray = true
                    break
                }
            }
            if (!foundInExistingArray) {
                array.append(dict)
            }
            UserDefaults.standard.set(array, forKey: "json")
        } else {
            var newArray = [Dictionary<String, Any>]()
            newArray.append(dict)
            UserDefaults.standard.set(newArray, forKey: "json")
            
        }
        
        // This is explictly for Simulation for the latest save.
        if (source == "SimulationSave") {
            UserDefaults.standard.set(dict, forKey: "lastSaveForSimulation")
        }
        UserDefaults.standard.synchronize()
    }
    
    // A new alert that capture the new name of a new configuraion
    private func presentAlert() {
        let alertController = UIAlertController(title: "New Configuation", message: "Please input a name:", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alertController.textFields?[0] {
                // store your data
                let newConfigurationName = field.text!
                self.addRowToTable(withName: newConfigurationName, source:"addRows")
                
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
}
