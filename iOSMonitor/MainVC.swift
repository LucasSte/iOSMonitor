//
//  ViewController.swift
//  iOSMonitor
//
//  Created by Lucas Steuernagel on 28/07/20.
//  Copyright © 2020 Lucas Steuernagel. All rights reserved.
//

import Foundation
import UIKit
import GPUUtilization

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
    @IBOutlet weak var gpuUsage : UILabel!
    
    @IBOutlet weak var totalSpace : UILabel!
    @IBOutlet weak var freeSpace : UILabel!
    
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
        if let totalSpaceInBytes = FileManagerUility.getFileSize(for: .systemSize) {
            let totalSpaceInGB = FileManagerUility.convert(totalSpaceInBytes)
            self.totalSpace.text = totalSpaceInGB!
            
            if let freeSpaceInBytes = FileManagerUility.getFileSize(for: .systemFreeSize) {
                let freePercentage = Double(freeSpaceInBytes) / Double(totalSpaceInBytes) * 100
                self.freeSpace.text = String(format: "%.2f", freePercentage)
            }
            
        }
        
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
                    self.gpuUsage.text = String(format: "%.2f", GPUUtilization.gpuUsage)
                }
                sleep(1)
            }
            
        }
        
    }
    

}

