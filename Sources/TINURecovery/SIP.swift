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
    
    ///This struct is used to represent the current SIP status
    public struct SIPStatus: Codable, Equatable{
        
        public init(resultsEnabled: Bool?, usesCustomConfiguration: Bool) {
            self.resultsEnabled = resultsEnabled
            self.usesCustomConfiguration = usesCustomConfiguration
        }
        
        ///The status of SIP, nil signifies it's an unkown status
        public let resultsEnabled: Bool?
        ///If SIP is using a custom configuration
        public let usesCustomConfiguration: Bool
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
                    //SIP is assumed to be enabled on apple silicon
                    if let arch = CpuArchitecture.actualCurrent(){
                        if arch != .intel64{
                            MEM.status = SIPStatus(resultsEnabled: true, usesCustomConfiguration: false)
                            return
                        }
                    }
                    */
                    
                    if let result = (Command.run(cmd: "/usr/bin/csrutil", args: ["status"])){
                    
                        let enabled = result.output.first!.contains("enabled")
                        //let disabled = result.output.first!.contains("disabled")
                        let unkown = result.output.first!.contains("unknown")
                        let custom = result.output.first!.contains("Custom Configuration") ? true : result.outputString().contains("Configuration")
                        
                        //As a backup SIP is assumed to be Enabled even if it's status can't be read, this makes sure that the highsest level of security possible is used in case of detection issues
                        MEM.status = SIPStatus(resultsEnabled: enabled ? true : (unkown ? nil : false), usesCustomConfiguration: custom )
                        
                    }else{
                        Printer.print("Can't get SIP staus, defaulting to an unkown status")
                        MEM.status = SIPStatus(resultsEnabled: nil, usesCustomConfiguration: false)
                    }
                    
                }
            }else{
                //SIP was introduced with 10.11
                Printer.print("Running on an old OS X version, SIP wasn't implemented yet, so this library will behave like if it was dissbled")
                MEM.status = SIPStatus(resultsEnabled: false, usesCustomConfiguration: false)
            }
            
            if let stat = MEM.status?.resultsEnabled {
                Printer.print("Is SIP Enabled? \(boolToPrettyStr(stat)).")
            }else{
                Printer.print("Is SIP Enabled? We don't know.")
            }
            Printer.print("Does SIP use a custom configuration? \(boolToPrettyStr(MEM.status!.usesCustomConfiguration)).")
        }
        
        
        
        return MEM.status ?? SIPStatus(resultsEnabled: true, usesCustomConfiguration: false)
    }
    
}
#endif
