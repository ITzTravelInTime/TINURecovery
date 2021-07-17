//
//  SIP.swift
//  
//
//  Created by Pietro Caruso on 29/06/21.
//

import Foundation
import Command

//import SwiftCPUDetect

#if os(macOS)
/**This class manages the SIP detection functions.
 
 You can change the `simulatedStatus` value for debugging purposes, but to have more control, for actual usage is reccommended (but not necessary) using a subclass of this one, and ovverriding the `simulatedStatus` variable to use it with your own debug variables system.
 
 */
open class SIP: SimulatableDetectable{
    
    public typealias SIPIntegerFormat = UInt32
    
    //Source for the SIP bits: https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/Resources/Constants.py
    
    ///Enum representing the bits and the related names for SIP values
    public enum SIPBits: SIPIntegerFormat, Codable, Equatable, CaseIterable, RawRepresentable{
        case CSR_ALLOW_UNTRUSTED_KEXTS = 0x1 //  - Allows Unsigned Kexts           - Introduced in El Capitan  # noqa: E241
        case CSR_ALLOW_UNRESTRICTED_FS = 0x2 //  - File System Access              - Introduced in El Capitan  # noqa: E241
        case CSR_ALLOW_TASK_FOR_PID = 0x4 //   - Unrestricted Debugging          - Introduced in El Capitan  # noqa: E241
        case CSR_ALLOW_KERNEL_DEBUGGER = 0x8  //  - Allow Kernel Debugger           - Introduced in El Capitan  # noqa: E241
        case CSR_ALLOW_APPLE_INTERNAL = 0x10 // - Set AppleInternal Features      - Introduced in El Capitan  # noqa: E241
        case CSR_ALLOW_UNRESTRICTED_DTRACE = 0x20 // - Unrestricted DTrace usage       - Introduced in El Capitan  # noqa: E241
        case CSR_ALLOW_UNRESTRICTED_NVRAM = 0x40 // - Unrestricted NVRAM write        - Introduced in El Capitan  # noqa: E241
        case CSR_ALLOW_DEVICE_CONFIGURATION = 0x80 // - Allow Device Configuration(?)   - Introduced in El Capitan  # noqa: E241
        case CSR_ALLOW_ANY_RECOVERY_OS = 0x100 // - Disable BaseSystem Verification - Introduced in Sierra      # noqa: E241
        case CSR_ALLOW_UNAPPROVED_KEXTS = 0x200 // - Allow Unapproved Kexts          - Introduced in High Sierra # noqa: E241
        case CSR_ALLOW_EXECUTABLE_POLICY_OVERRIDE = 0x400 // - Override Executable Policy      - Introduced in Mojave      # noqa: E241
        case CSR_ALLOW_UNAUTHENTICATED_ROOT = 0x800 // - Allow Root Volume Mounting      - Introduced in Big Sur     # noqa: E241
    }
    
    ///This struct is used to represent the current SIP status
    public struct SIPStatus: Codable, Equatable{
        
        internal init(resultsEnabled: Bool?, usesCustomConfiguration: Bool, detailedConfiguration: [SIP.SIPBits : Bool], detailedConfigurationInteger: SIP.SIPIntegerFormat) {
            self.resultsEnabled = resultsEnabled
            self.usesCustomConfiguration = usesCustomConfiguration
            self.detailedConfiguration = detailedConfiguration
            self.detailedConfigurationInteger = detailedConfigurationInteger
        }
        ///The status of SIP, nil signifies it's an unkown status
        public let resultsEnabled: Bool?
        ///If SIP is using a custom configuration
        public let usesCustomConfiguration: Bool
        ///The SIP bit names and their status, in case or error this is an empty dictionary
        public let detailedConfiguration: [SIPBits: Bool]
        ///The SIP integer value readed from nvram, in case of errors this defaults to 0
        public let detailedConfigurationInteger: SIPIntegerFormat
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
                    
                    guard let hexStatus = (Command.run(cmd: "/usr/sbin/nvram", args: ["csr-active-config"]))?.outputString() else{
                        Printer.print(" [SIP] Can't get SIP staus, due to a problem while reading nvram info, defaulting to an unkown status")
                        MEM.status = SIPStatus(resultsEnabled: nil, usesCustomConfiguration: false, detailedConfiguration: [:], detailedConfigurationInteger: 0)
                        return
                    }
                    
                    guard let reportedStatus = (Command.run(cmd: "/usr/bin/csrutil", args: ["status"])) else{
                        Printer.print(" [SIP] Can't get SIP crsutil reported staus, defaulting to an unkown status")
                        MEM.status = SIPStatus(resultsEnabled: nil, usesCustomConfiguration: false, detailedConfiguration: [:], detailedConfigurationInteger: 0)
                        return
                    }
                    
                    var numberString = ""
                    
                    for i in hexStatus.split(separator: "%").dropFirst().reversed(){
                        numberString += String(i)
                    }
                    
                    var bits: [SIPBits: Bool] = [:]
                    
                    guard let num = SIPIntegerFormat(numberString, radix: 16) else {
                        Printer.print(" [SIP] Can't get SIP staus, due to a problem while converting the nvram output to a valid integer")
                        MEM.status = SIPStatus(resultsEnabled: nil, usesCustomConfiguration: false, detailedConfiguration: [:], detailedConfigurationInteger: 0)
                        return
                    }
                    
                    for bit in SIPBits.allCases{
                        bits[bit] = num & (bit.rawValue) != 0
                    }
                    
                    let resultsEnabled = reportedStatus.output.first!.contains("enabled") ? true : (reportedStatus.output.first!.contains("unknown") ? nil : false)
                    let usesCustomConfiguration = reportedStatus.output.first!.contains("Custom Configuration") ? true : reportedStatus.outputString().contains("Configuration")
                        
                    MEM.status = SIPStatus(resultsEnabled: resultsEnabled == nil ? nil : (resultsEnabled! || num == 0), usesCustomConfiguration: usesCustomConfiguration, detailedConfiguration: bits, detailedConfigurationInteger: num)
                    
                }
            }else{
                //SIP was introduced with 10.11
                Printer.print(" [SIP] Running on an old OS X version, SIP wasn't implemented yet, so this library will just return an unkown status")
                MEM.status = SIPStatus(resultsEnabled: nil, usesCustomConfiguration: false, detailedConfiguration: [:], detailedConfigurationInteger: 0)
            }
            
            if let stat = MEM.status?.resultsEnabled {
                Printer.print(" [SIP] Is SIP Enabled? \(boolToPrettyStr(stat)).")
            }else{
                Printer.print(" [SIP] Is SIP Enabled? We don't know.")
            }
            
            Printer.print(" [SIP] Does SIP use a custom configuration? \(boolToPrettyStr(MEM.status!.usesCustomConfiguration)).")
            Printer.print(" [SIP] Obtained SIP configuration bits: \(MEM.status!.detailedConfiguration)")
        }
        
        return MEM.status ?? SIPStatus(resultsEnabled: nil, usesCustomConfiguration: false, detailedConfiguration: [:], detailedConfigurationInteger: 0)
    }
    
}
#endif
