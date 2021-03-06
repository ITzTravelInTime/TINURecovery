/*
 TINURecovery: Library with the Recovery Mode, SIP, Sandbox, User detection, nvram and network detection functions used by TINU.
 Copyright (C) 2021-2022 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

#if os(macOS)

import Foundation
import AppKit

public extension SIP.SIPStatus{
    ///Returns a user-friendly string reporting the current SIP status
    func statusStrig() -> String{
        var ret = ""
        
        let fully = self.resultsFullyDisabled
        
        if let stat = self.resultsEnabled{
            ret += "SIP is \(fully ? "fully " : "")\(stat ? "enabled" : "disabled")"
        }else{
            ret += "SIP status unknown"
        }
        
        if self & SIP.SIPBits.CSR_ALLOW_APPLE_INTERNAL.rawValue != 0{
            ret += " (Apple Internal)"
        }else{
            ret += self.usesCustomConfiguration ? " (custom config.)" : ""
        }
        
        //print(self.json(prettyPrinted: false)!)
        
        return ret
    }
}

public extension SIP.SIPBits{
    
    ///The user-friendly description of the current value
    ///
    ///Credits to  [khronokernel]("https://github.com/khronokernel")
    var userDescription: String{
        switch self {
        case .CSR_ALLOW_UNTRUSTED_KEXTS:
            return "This bit, if enabled, indicates that the system will allow loading unsigned KEXTs."
        case .CSR_ALLOW_UNRESTRICTED_FS:
            return "This bit, if enabled, indicates that the system will allow modifications to macOS ROOT/BOOT volumes."
        case .CSR_ALLOW_TASK_FOR_PID:
            return "This bit, if enabled, indicates that the system will allow the usage of the `task_for_pid()` function (Debugging related feature)"
        case .CSR_ALLOW_KERNEL_DEBUGGER:
            return "This bit, if enabled, indicates that the system will allow the usage of the kernel debugger (Debugging related feature)"
        case .CSR_ALLOW_APPLE_INTERNAL:
            return "This bit, if enabled, indicates that the system will allow the usage of private 'Apple Internal' software and repositories (WARNING: may break system updates and bring other system issues, don't enable it unless you know what you do)"
        case .CSR_ALLOW_UNRESTRICTED_DTRACE:
            return "This bit, if enabled, indicates that the system will allow unrestricted usage of the `DTrace` function (Debugging related feature)"
        case .CSR_ALLOW_UNRESTRICTED_NVRAM:
            return "This bit, if enabled, indicates that the system will allow for unrestricted NVRAM usage (Mainly being able to edit or not some NVRAM values) (WARNING: Messing with the contents of NVRAM could break your system)"
        case .CSR_ALLOW_DEVICE_CONFIGURATION:
            return "This bit, if enabled, indicates that the system will allow custom Device Trees (Applicable to iOS and Apple Silicon only)"
        case .CSR_ALLOW_ANY_RECOVERY_OS:
            return "This bit, if enabled, indicates that the system will allow the usage of Recovery OSes different from the one that cames with the installed system"
        case .CSR_ALLOW_UNAPPROVED_KEXTS:
            return "This bit, if enabled, indicates that the system will allow loading non-notarized KEXTs."
        case .CSR_ALLOW_EXECUTABLE_POLICY_OVERRIDE:
            return "This bit, if enabled, indicates that the system will allow the usage of modified/unapproved system binaries"
        case .CSR_ALLOW_UNAUTHENTICATED_ROOT:
            return "This bit, if enabled, indicates that the system will allow booting from non-sealed system snapshots"
        }
    }
    
    ///The string name of the current value
    var name: String{
        switch self {
        case .CSR_ALLOW_UNTRUSTED_KEXTS:
            return "CSR_ALLOW_UNTRUSTED_KEXTS"
        case .CSR_ALLOW_UNRESTRICTED_FS:
            return "CSR_ALLOW_UNRESTRICTED_FS"
        case .CSR_ALLOW_TASK_FOR_PID:
            return "CSR_ALLOW_TASK_FOR_PID"
        case .CSR_ALLOW_KERNEL_DEBUGGER:
            return "CSR_ALLOW_KERNEL_DEBUGGER"
        case .CSR_ALLOW_APPLE_INTERNAL:
            return "CSR_ALLOW_APPLE_INTERNAL"
        case .CSR_ALLOW_UNRESTRICTED_DTRACE:
            return "CSR_ALLOW_UNRESTRICTED_DTRACE"
        case .CSR_ALLOW_UNRESTRICTED_NVRAM:
            return "CSR_ALLOW_UNRESTRICTED_NVRAM"
        case .CSR_ALLOW_DEVICE_CONFIGURATION:
            return "CSR_ALLOW_DEVICE_CONFIGURATION"
        case .CSR_ALLOW_ANY_RECOVERY_OS:
            return "CSR_ALLOW_ANY_RECOVERY_OS"
        case .CSR_ALLOW_UNAPPROVED_KEXTS:
            return "CSR_ALLOW_UNAPPROVED_KEXTS"
        case .CSR_ALLOW_EXECUTABLE_POLICY_OVERRIDE:
            return "CSR_ALLOW_EXECUTABLE_POLICY_OVERRIDE"
        case .CSR_ALLOW_UNAUTHENTICATED_ROOT:
            return "CSR_ALLOW_UNAUTHENTICATED_ROOT"
        }
    }
}

#endif
