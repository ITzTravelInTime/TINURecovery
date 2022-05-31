/*
 TINURecovery: Library with the Recovery Mode, SIP, Sandbox, User detection, nvram and network detection functions used by TINU.
 Copyright (C) 2021-2022 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

import Foundation
import SwiftPackagesBase

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
        
        Printer.print("Is this app/program running inside a macOS Recovery/Installer OS? \(_state.stringValue() ?? "no value!")")
        
        return _state
    }
}
#endif
