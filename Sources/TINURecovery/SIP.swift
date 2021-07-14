//
//  SIP.swift
//  
//
//  Created by Pietro Caruso on 29/06/21.
//

import Foundation
import Command
import SwiftCPUDetect


#if os(macOS)
/**This class manages the SIP detection functions.
 
 You can change the `simulatedStatus` value for debugging purposes, but to have more control, for actual usage is reccommended (but not necessary) using a subclass of this one, and ovverriding the `simulatedStatus` variable to use it with your own debug variables system.
 
 */
open class SIP: SimulatableDetectable{
    
    ///This struct is used to represent the current SIP status
    public struct SIPStatus: Codable, Equatable{
        
        public init(resultsEnabled: Bool, usesCustomConfiguration: Bool) {
            self.resultsEnabled = resultsEnabled
            self.usesCustomConfiguration = usesCustomConfiguration
        }
        
        ///The status of SIP
        public let resultsEnabled: Bool
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
                    
                    
                    let result = (Command.run(cmd: "/usr/bin/csrutil", args: ["status"]))
                    
                    //As a backup SIP is assumed to be Enabled even if it's status can't be read, this makes sure that the highsest level of security possible is used in case of detection issues
                    MEM.status = SIPStatus(resultsEnabled: result?.output.first?.contains("enabled") ?? true, usesCustomConfiguration: result?.outputString().contains("Configuration") ?? false)
                    
                }
            }else{
                //SIP was introduced with 10.11
                Log.print("Running on an old OS X version, SIP wasn't implemented yet, so this library will behave like if it was dissbled")
                MEM.status = SIPStatus(resultsEnabled: false, usesCustomConfiguration: false)
            }
            
            Log.print("Is SIP Enabled? \(boolToPrettyStr(MEM.status!.resultsEnabled))")
            Log.print("Does SIP use a custom configuration? \(boolToPrettyStr(MEM.status!.usesCustomConfiguration))")
        }
        
        
        
        return MEM.status ?? SIPStatus(resultsEnabled: true, usesCustomConfiguration: false)
    }
    
}
#endif
