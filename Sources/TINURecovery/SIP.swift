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
    
    /**
     Returns the actual current status of SIP reguardless of the value of `simulatedStatus`
        
     Use this only if this information is needed to perform tasks that only works with either SIP turned On or Off.
     */
    public static var actualStatus: Bool{
        struct MEM{
            static var status: Bool? = nil
        }
        
        if MEM.status == nil{
            //SIP wasn't a thing until OS X El Capitan
            if #available(OSX 10.11, *){
                DispatchQueue.global(qos: .background).sync {
                    
                    //into a Recovery/Installer os the programs runs as root, so it's pretty safe to assume that we have full access
                    if Recovery.actualStatus{
                        MEM.status = false
                        return
                    }
                    
                    //SIP is assumed to be enabled on apple silicon
                    if let arch = CpuArchitecture.actualCurrent(){
                        if arch != .intel64{
                            MEM.status = true
                            return
                        }
                    }
                    
                    //As a backup this is assumed to be true
                    MEM.status = (Command.getOut(cmd: "csrutil status")?.contains("enabled") ?? true)
                }
            }else{
                MEM.status = false
            }
            
            print("Is SIP Enabled? \(boolToPrettyStr(MEM.status!))")
        }
        
        
        
        return MEM.status ?? true
    }
    
}
#endif
