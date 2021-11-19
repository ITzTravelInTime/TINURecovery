/*
 TINURecovery: Library with the Recovery Mode, SIP, Sandbox, User detection, nvram and network detection functions used by TINU.
 Copyright (C) 2021 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

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
