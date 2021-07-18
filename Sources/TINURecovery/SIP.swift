//
//  SIP.swift
//  
//
//  Created by Pietro Caruso on 29/06/21.
//

import Foundation
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
        
        ///A mask integer wth all the flags expected to be set for SIP to be on or off
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
    public static var actualStatus: SIPStatus{
        struct MEM{
            static var status: SIPStatus? = nil
        }
        
        if MEM.status == nil{
            //SIP wasn't a thing until OS X El Capitan
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
                    
                    guard let num: SIPStatus = NVRAM.getInteger(name: "csr-active-config") else{
                        Printer.print(" [SIP] Can't get SIP staus, due to a problem while converting the nvram output to a valid integer")
                        return
                    }
                    
                    MEM.status = num
                    
                }
            }else{
                //SIP was introduced with 10.11
                Printer.print(" [SIP] Running on an old OS X version, SIP wasn't implemented yet")
            }
            
            if let stat = MEM.status?.resultsEnabled {
                Printer.print(" [SIP] Is SIP Enabled? \(boolToPrettyStr(stat)).")
            }else{
                Printer.print(" [SIP] Is SIP Enabled? We don't know.")
            }
            
            Printer.print(" [SIP] Does SIP use a custom configuration? \(boolToPrettyStr(MEM.status!.usesCustomConfiguration)).")
            Printer.print(" [SIP] Obtained SIP configuration bits: \(MEM.status!.detailedConfiguration)")
        }
        
        return MEM.status ?? 0 //Defaults to enabled SIP
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
        return (self & (~SIP.SIPBits.CSR_VALID_FLAGS)) != 0
    }
    
    ///Indicates if SIP is fully enabled, fully disabled or uses an undeterminated configuration
    var resultsEnabled: Bool!{
        switch (self & SIP.SIPBits.CSR_DISABLE_FLAGS) {
        case SIP.SIPBits.CSR_DISABLE_FLAGS:
            return false
        case 0:
            return true
        default:
            return nil
        }
    }
    
    ///Returns the SIP configuration as an integer
    var detailedConfigurationInteger: SIP.SIPStatus{
        return self
    }
    
}

#endif
