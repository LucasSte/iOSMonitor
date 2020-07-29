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
    let memMonitor = MemoryMonitor()
    @IBOutlet weak var coreUsage : UILabel!
    @IBOutlet weak var totalMem : UILabel!
    @IBOutlet weak var usedMem : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cpuMonitor.updateInfo(self.cpuMonitor.updateTimer)
        changeText()
    }
    
    func changeText()
    {
        self.coreUsage.numberOfLines = Int(self.cpuMonitor.numCPUs) + 1
        self.totalMem.text = String(format: "%.2f", self.memMonitor.totalMemory() / 1073741824)
        DispatchQueue.global(qos: .background).async {
            while(true)
            {
                    var text : String = ""
                    for i in 0 ..< self.cpuMonitor.numCPUs
                    {
                        text = text + "Core " + i.description + ": " + String(format: "%.2f",self.cpuMonitor.coreUsage[Int(i)]) + "%\n"
                    }
                    DispatchQueue.main.async {
                        self.coreUsage.text = text
                        self.usedMem.text = String(format: "%.2f", self.memMonitor.usedMemory()! / self.memMonitor.totalMemory() * 100)
                    }
                    sleep(1)
            }
            
        }
        
    }
    

}

