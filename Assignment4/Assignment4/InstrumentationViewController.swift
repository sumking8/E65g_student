//
//  FirstViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController {
    @IBOutlet weak var cStepper: UIStepper!
    @IBOutlet weak var rStepper: UIStepper!
    @IBOutlet weak var cValues: UITextField!
    @IBOutlet weak var rValues: UITextField!
    @IBOutlet weak var onOffSwitch: UISwitch!
    @IBOutlet weak var refreshRateSlider: UISlider!
    var on = false
    var engine : EngineProtocol = StandardEngine.engine
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(on)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func rStepperAction(_ sender: Any) {
        rValues.text = String(Int(rStepper.value))
        if on {
            cValues.text = rValues.text
            cStepper.value = rStepper.value
            engine.size = Int(rStepper.value)
        }
        
    }
    @IBAction func cStepperAction(_ sender: Any) {
        cValues.text = String(Int(cStepper.value))
        if on {
            rValues.text = cValues.text
            rStepper.value = cStepper.value
            engine.size = Int(cStepper.value)
        }
    }
    @IBAction func refreshRateSliderAction(_ sender: Any) {
        if on {
            engine.refreshRate = 0.0
            engine.refreshRate = Double(1/refreshRateSlider.value)
        }
        print("Value: \(refreshRateSlider.value) and \(1/refreshRateSlider.value)" )
    }

    @IBAction func switchAction(_ sender: Any) {
        //print("before \(on)" )
        on = !on
        if on {
            let row : Int = Int(rStepper.value)
            let col : Int = Int(cStepper.value)
            let size = max(row, col)
            if engine.rows != size {
                engine.size = size
                cValues.text = rValues.text
                cStepper.value = rStepper.value
            }
            if engine.cols != size {
                engine.size = size
                rValues.text = cValues.text
                rStepper.value = cStepper.value
            }
            let refresh = Double(refreshRateSlider.value)
            if engine.refreshRate != refresh {
                engine.refreshRate = 0.0
                engine.refreshRate = 1/refresh
            }
        } else {
            engine.refreshRate = 0.0
        }
        //print("after \(on)" )
    }
   
}
