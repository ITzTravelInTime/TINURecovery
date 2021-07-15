//
//  Sandbox.swift
//  
//
//  Created by Pietro Caruso on 29/06/21.
//

import Foundation

#if os(macOS)
///This class manages program sandbox detection code
public final class Sandbox{
    ///Detects is the current program is running as sandboxed
    public static var isEnabled: Bool {
        //Uses a static value to avoid repeting the detection code for each call of the variable
        struct MEM{
            static var state: Bool! = nil
        }
        
        if MEM.state == nil{
            MEM.state = ProcessInfo.processInfo.environment["APP_SANDBOX_CONTAINER_ID"] != nil
            Printer.print("Is Sandbox enabled? \(boolToPrettyStr(MEM.state!))")
        }
        
        return MEM.state
    }
    
    /**
     Determinates if the current program has unrestricted access
     
     Programs with unrestricted access runs as root and are not sandboxed.
     
     */
    public static var hasUnrestrictedAccess: Bool{
        if !isEnabled && CurrentUser.isRoot{
            Printer.print("Keep in mind that this app has unrestricted access now!")
            return true
        }
        Printer.print("Sadly our access is somewhat restricted")
        return false
    }
}

#endif
