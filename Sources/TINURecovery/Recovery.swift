//
//  Recovery.swift
//  
//
//  Created by Pietro Caruso on 29/06/21.
//

import Foundation

#if os(macOS)
/**This class manages the macOS Recovery/Installer OS detection functions.
 
 You can change the `simulatedStatus` value for debugging purposes, but to have more control on it and for actual usage is reccommended (but not necessary) using a subclass of this one, and ovverriding the `simulatedStatus` variable to use it with your own debug variables system.
 
 */
open class Recovery: SimulatableDetectable{
    
    /**
     Detects if the app is actually running on a macOS Recovery/Installer OS.
     
     Use this only if this information is needed to perform tasks that only works inside the macOS Recovery/Installer OS evironment.
     */
    public static var actualStatus: Bool{
        //Uses a static value to avoid repeting the detection code for each call of the variable
        struct MEM{
            static var state: Bool! = nil
        }
        
        if MEM.state == nil{
            MEM.state = false
            
            if Sandbox.hasUnrestrictedAccess{
                //Recovery/Installer OSes don't have the sudo executable and the use is just Root
                MEM.state = !FileManager.default.fileExists(atPath: "/usr/bin/sudo")
            }
            
            print("Is this app/program running inside a macOS Recovery/Installer OS? \(boolToPrettyStr(MEM.state!))")
        }
        
        return MEM.state
    }
}
#endif
