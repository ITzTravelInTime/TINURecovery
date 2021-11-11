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
open class Recovery: SimulatableDetectableOneTime{
    public static var storedStatus: Bool? = nil
    
    /**
     Used to simulate the status for debugging purposes.
     
     You can change the `simulatedStatus` value for debugging purposes, but to have more control on it and for actual usage is reccommended (but not necessary) using a subclass of this one, and ovverriding the `simulatedStatus` variable to use it with your own debug variables system.
     */
    open class var simulatedStatus: Bool?{
        return nil
    }
    
    ///Initializer for compliance with the protocol
    public required init(){
        //Litterally does nothing since this class is used more like a namespe and so it doesn't contain any stored values to intialize
    }
    
    /**
     Detects if the app is actually running on a macOS Recovery/Installer OS.
     
     Use this only if this information is needed to perform tasks that only works inside the macOS Recovery/Installer OS evironment.
     */
    public static func calculateStatus() -> Bool {
        
        var _state = false
        
        //This check is worth making only if the app has access to the system files
        if Sandbox.hasUnrestrictedAccess{
            //Recovery/Installer OSes don't have the sudo executable and the user is always Root
            _state = !FileManager.default.fileExists(atPath: "/usr/bin/sudo") && CurrentUser.isRoot
        }
        
        Printer.print("Is this app/program running inside a macOS Recovery/Installer OS? \(boolToPrettyStr(_state))")
        
        return _state
    }
}
#endif
