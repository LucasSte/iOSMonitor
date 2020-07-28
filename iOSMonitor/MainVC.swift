//
//  ViewController.swift
//  iOSMonitor
//
//  Created by Lucas Steuernagel on 28/07/20.
//  Copyright © 2020 Lucas Steuernagel. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    let cpuMonitor = CpuMonitor()
    weak var coreUsage : UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cpuMonitor.updateInfo(self.cpuMonitor.updateTimer, action: changeText(usage:))
    }
    
    func changeText(usage : [Float])
    {
        var text : String = ""
        for i in 0 ..< usage.count {
            text = text + "Core " + i.description + ": " + String(format: ".2%f", usage[i]) + "\n"
        }
        DispatchQueue.main.async {
            self.coreUsage.text = text
        }
    }
    

}

