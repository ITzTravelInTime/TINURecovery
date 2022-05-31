/*
 TINURecovery: Library with the Recovery Mode, SIP, Sandbox, User detection, nvram and network detection functions used by TINU.
 Copyright (C) 2021-2022 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

import Foundation
import SwiftPackagesBase
//import Command

//import SwiftCPUDetect

#if os(macOS)

/**This class manages the SIP detection functions.
 
 You can change the `simulatedStatus` value for debugging purposes, but to have more control, for actual usage is reccommended (but not necessary) using a subclass of this one, and ovverriding the `simulatedStatus` variable to use it with your own debug variables system.
 
 */
open class SIP: SimulatableDetectable{
    
    public typealias SIPIntegerFormat = UInt32
    public typealias SIPStatus = SIPIntegerFormat
    
    //Source for the SIP bits:
    //https://opensource.apple.com/source/xnu/xnu-7195.121.3/bsd/sys/csr.h.auto.html
    //https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/Resources/Constants.py
    
    ///Enum representing the bits and the related names for SIP values
    public enum SIPBits: SIPIntegerFormat, Codable, Equatable, CaseIterable, RawRepresentable{
        case CSR_ALLOW_UNTRUSTED_KEXTS = 0x1 //              - Allows Unsigned Kexts           - Introduced in El Capitan
        case CSR_ALLOW_UNRESTRICTED_FS = 0x2 //              - File System Access              - Introduced in El Capitan
        case CSR_ALLOW_TASK_FOR_PID = 0x4 //                 - Unrestricted Debugging          - Introduced in El Capitan
        case CSR_ALLOW_KERNEL_DEBUGGER = 0x8  //             - Allow Kernel Debugger           - Introduced in El Capitan
        case CSR_ALLOW_APPLE_INTERNAL = 0x10 //              - Set AppleInternal Features      - Introduced in El Capitan
        case CSR_ALLOW_UNRESTRICTED_DTRACE = 0x20 //         - Unrestricted DTrace usage       - Introduced in El Capitan
        case CSR_ALLOW_UNRESTRICTED_NVRAM = 0x40 //          - Unrestricted NVRAM write        - Introduced in El Capitan
        case CSR_ALLOW_DEVICE_CONFIGURATION = 0x80 //        - Allow Device Configuration(?)   - Introduced in El Capitan
        case CSR_ALLOW_ANY_RECOVERY_OS = 0x100 //            - Disable BaseSystem Verification - Introduced in Sierra
        case CSR_ALLOW_UNAPPROVED_KEXTS = 0x200 //           - Allow Unapproved Kexts          - Introduced in High Sierra
        case CSR_ALLOW_EXECUTABLE_POLICY_OVERRIDE = 0x400 // - Override Executable Policy      - Introduced in Mojave
        case CSR_ALLOW_UNAUTHENTICATED_ROOT = 0x800 //       - Allow Root Volume Mounting      - Introduced in Big Sur
        
        ///A mask integer with all the known SIP values
        public static var bitMask: SIPIntegerFormat{
            var ret: SIPIntegerFormat = 0
            
            for bit in SIPBits.allCases{
                ret |= bit.rawValue
            }
                
            return ret
        }
        
        ///A mask integer with all the valid flags for the current OS
        public static var CSR_VALID_FLAGS: SIPIntegerFormat{
            var ret = CSR_ALLOW_UNTRUSTED_KEXTS.rawValue | CSR_ALLOW_UNRESTRICTED_FS.rawValue | CSR_ALLOW_TASK_FOR_PID.rawValue | CSR_ALLOW_KERNEL_DEBUGGER.rawValue | CSR_ALLOW_APPLE_INTERNAL.rawValue | CSR_ALLOW_UNRESTRICTED_DTRACE.rawValue | CSR_ALLOW_UNRESTRICTED_NVRAM.rawValue | CSR_ALLOW_DEVICE_CONFIGURATION.rawValue
            
            if #available(macOS 10.12, *){
                ret |= CSR_ALLOW_ANY_RECOVERY_OS.rawValue
            }
                
            if #available(macOS 10.13, *){
                ret |= CSR_ALLOW_UNAPPROVED_KEXTS.rawValue
            }
            
            if #available(macOS 10.14, *){
                ret |= CSR_ALLOW_EXECUTABLE_POLICY_OVERRIDE.rawValue
            }

            if #available(macOS 11.0, *){
                ret |= CSR_ALLOW_UNAUTHENTICATED_ROOT.rawValue
            }
            
            return ret
        }
        
        ///A mask integer wth all the flags expected to be set for SIP by csrutil when sip is enabled or disabled using the system recovery
        public static var CSR_DISABLE_FLAGS: SIPIntegerFormat{
            
            return CSR_ALLOW_UNTRUSTED_KEXTS.rawValue | CSR_ALLOW_UNRESTRICTED_FS.rawValue | CSR_ALLOW_TASK_FOR_PID.rawValue | CSR_ALLOW_KERNEL_DEBUGGER.rawValue | CSR_ALLOW_APPLE_INTERNAL.rawValue | CSR_ALLOW_UNRESTRICTED_DTRACE.rawValue | CSR_ALLOW_UNRESTRICTED_NVRAM.rawValue
            
        }
        
    }
    
    /**
     Used to simulate the status for debugging purposes.
     
     You can change the `simulatedStatus` value for debugging purposes, but to have more control on it and for actual usage is reccommended (but not necessary) using a subclass of this one, and ovverriding the `simulatedStatus` variable to use it with your own debug variables system.
     */
    open class var simulatedStatus: SIPStatus?{
        return nil
    }
    
    
    ///Initializer for compliance with the protocol
    public required init(){
        //Litterally does nothing since this class is used more like a namespe and so it doesn't contain any stored values to intialize
    }
    
    /**
     Returns the actual current status of SIP reguardless of the value of `simulatedStatus`
        
     Use this only if this information is needed to perform tasks that only works with either SIP turned On or Off.
     
     */
    public static func calculateStatus() -> UInt32 {
        //SIP wasn't a thing until OS X El Capitan
        
        var ret: SIPStatus = 0
        
        if #available(OSX 10.11, *){
            DispatchQueue.global(qos: .background).sync {
                /*
                guard let hexStatus = (Command.run(cmd: "/usr/sbin/nvram", args: ["csr-active-config"]))?.outputString() else{
                    Printer.print(" [SIP] Can't get SIP staus, due to a problem while reading nvram info")
                    return
                }

                var numberString = ""
                
                print("hexStatus: \(hexStatus)")
                
                //Byte endianess flip
                for i in hexStatus.split(separator: "%").dropFirst().reversed(){
                    numberString += String(i)
                }
                
                guard let num = SIPIntegerFormat(numberString, radix: 16) else {
                    Printer.print(" [SIP] Can't get SIP staus, due to a problem while converting the nvram output to a valid integer")
                    return
                }
                 */
                /*
                guard let num = NVRAM.getData(forKey: "csr-active-config") else{
                    Printer.print(" [SIP] Can't get SIP staus, due to a problem while converting the nvram output to a valid integer")
                    return
                }
                
                ret = num.withUnsafeBytes({(rawPtr: UnsafeRawBufferPointer) in
                    return rawPtr.load(as: SIPStatus.self)
                })*/
                
                
                guard let num: SIPStatus = NVRAM.getIntegerData(forKey: "csr-active-config") else{
                    Printer.print(" [SIP] Can't get SIP staus, due to a problem while converting the nvram output to a valid integer")
                    return
                }
                
                ret = num
            }
        }else{
            //SIP was introduced with 10.11
            Printer.print(" [SIP] Running on an old OS X version, SIP wasn't implemented yet")
        }
        
        if let stat = ret.resultsEnabled {
            Printer.print(" [SIP] Is SIP Enabled? \(stat.stringValue() ?? "No idea!").")
        }else{
            Printer.print(" [SIP] Is SIP Enabled? We don't know because the SIP status is either unsupported or unkown.")
        }
        
        Printer.print(" [SIP] Obtained SIP configuration bits: \(ret.detailedConfiguration )")
        Printer.print(" [SIP] Does SIP use a custom configuration? \(ret.usesCustomConfiguration.stringValue() ?? "No idea!").")
        
        return ret
    }
    
}

public extension SIP.SIPStatus{
    ///The SIP bit names and their status, in case or error this is an empty dictionary
    var detailedConfiguration: [SIP.SIPBits: Bool]{
        var bits: [SIP.SIPBits: Bool] = [:]
        
        for bit in SIP.SIPBits.allCases{
            bits[bit] = self & (bit.rawValue) != 0
        }
        
        return bits
    }
    
    ///Indicates if SIP is using a custom configuration or not
    var usesCustomConfiguration: Bool{
        
        let check = self & ~SIP.SIPBits.CSR_ALLOW_APPLE_INTERNAL.rawValue
        
        return check != 0 && check != (SIP.SIPBits.CSR_DISABLE_FLAGS & SIP.SIPBits.CSR_VALID_FLAGS & ~SIP.SIPBits.CSR_ALLOW_APPLE_INTERNAL.rawValue)
        
    }
    
    ///Indicates if SIP has enabled all the valus that csrutil will change when it sets the SIP enabled, or disabled or uses a mixed configuration
    var resultsEnabled: Bool!{
        let ref = (SIP.SIPBits.CSR_DISABLE_FLAGS & (~SIP.SIPBits.CSR_ALLOW_APPLE_INTERNAL.rawValue) )
        
        switch (self & ref) {
        case ref:
            return false
        case 0:
            return true
        default:
            return nil
        }
    }
    
    ///Indicates if SIP has all the valus supported by the current OS all enabled
    var resultsFullyDisabled: Bool{
        let ref = SIP.SIPBits.CSR_VALID_FLAGS & (~SIP.SIPBits.CSR_ALLOW_APPLE_INTERNAL.rawValue)
        
        return (self & ref == ref)
        
    }
    
    ///Returns the SIP configuration as an integer
    var detailedConfigurationInteger: SIP.SIPStatus{
        return self
    }
    
}

#endif
