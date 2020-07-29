//
//  ViewController.swift
//  iOSMonitor
//
//  Created by Lucas Steuernagel on 28/07/20.
//  Copyright © 2020 Lucas Steuernagel. All rights reserved.
//

import Foundation
import UIKit

class MainVC: UIViewController {
    let cpuMonitor = CpuMonitor()
    let memMonitor = MemoryMonitor()
    @IBOutlet weak var coreUsage : UILabel!
    @IBOutlet weak var totalMem : UILabel!
    @IBOutlet weak var usedMem : UILabel!
    @IBOutlet weak var execPath : UILabel!
    var networkInfo = DataUsageInfo()
    
    @IBOutlet weak var wifiSent: UILabel!
    @IBOutlet weak var wifiRec: UILabel!
    @IBOutlet weak var cellSent : UILabel!
    @IBOutlet weak var cellRec: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cpuMonitor.updateInfo(self.cpuMonitor.updateTimer)
        changeText()

    }
    
    func changeText()
    {
        self.coreUsage.numberOfLines = Int(self.cpuMonitor.numCPUs) + 1
        self.totalMem.text = String(format: "%.2f", self.memMonitor.totalMemory() / 1073741824)
        self.execPath.lineBreakMode = NSLineBreakMode.byCharWrapping
        self.execPath.numberOfLines = 0
        self.execPath.text = Bundle.main.executablePath!
        DispatchQueue.global(qos: .background).async {
            while(true)
            {
                self.networkInfo.updateInfoByAdding(info: DataUsage.getDataUsage())
                var text : String = ""
                for i in 0 ..< self.cpuMonitor.numCPUs
                {
                    text = text + "Core " + i.description + ": " + String(format: "%.2f",self.cpuMonitor.coreUsage[Int(i)]) + "%\n"
                }
                DispatchQueue.main.async {
                    self.coreUsage.text = text
                    self.usedMem.text = String(format: "%.2f", self.memMonitor.usedMemory()! / self.memMonitor.totalMemory() * 100)
                    self.wifiSent.text = self.networkInfo.wifiSent.description
                    self.wifiRec.text = self.networkInfo.wifiReceived.description
                    self.cellRec.text = self.networkInfo.wirelessWanDataReceived.description
                    self.cellSent.text = self.networkInfo.wirelessWanDataSent.description
                }
                sleep(1)
            }
            
        }
        
    }
    

}

