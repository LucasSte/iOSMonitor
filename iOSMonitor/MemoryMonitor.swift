//
//  MemoryMonitor.swift
//  iOSMonitor
//
//  Created by Lucas Steuernagel on 29/07/20.
//  Copyright © 2020 Lucas Steuernagel. All rights reserved.
//

import Foundation

class MemoryMonitor {
    
    func usedMemory() -> Double? {
        // The `TASK_VM_INFO_COUNT` and `TASK_VM_INFO_REV1_COUNT` macros are too
        // complex for the Swift C importer, so we have to define them ourselves.
        let TASK_VM_INFO_COUNT = mach_msg_type_number_t(MemoryLayout<task_vm_info_data_t>.size / MemoryLayout<integer_t>.size)
        let TASK_VM_INFO_REV1_COUNT = mach_msg_type_number_t(MemoryLayout.offset(of: \task_vm_info_data_t.min_address)! / MemoryLayout<integer_t>.size)
        var info = task_vm_info_data_t()
        var count = TASK_VM_INFO_COUNT
        let kr = withUnsafeMutablePointer(to: &info) { infoPtr in
            infoPtr.withMemoryRebound(to: integer_t.self, capacity: Int(count)) { intPtr in
                task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), intPtr, &count)
            }
        }
        guard
            kr == KERN_SUCCESS,
            count >= TASK_VM_INFO_REV1_COUNT
            else { return nil }

        let usedBytes = Double(info.phys_footprint)
        return usedBytes
    }
    
    func totalMemory() -> Double {
        return Double(ProcessInfo.processInfo.physicalMemory)
    }
}