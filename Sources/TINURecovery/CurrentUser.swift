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

///This class is a more elegant way of detecting the current user name and is it's root
public final class CurrentUser{
    ///Detects the logon name of the current user.
    public static var name: String{
        return NSUserName()
    }
    
    ///Detects if the current user is Root
    public static var isRoot: Bool{
        //Uses a static value to avoid repeting the detection code for each call of the variable
        struct MEM{
            static var state: Bool? = nil
        }
        
        if MEM.state == nil{
            MEM.state = name == "root"
            Printer.print("Is the current user Root?: \(MEM.state?.stringValue() ?? "unkown (defaults to false)")")
        }
        
        return MEM.state ?? false
    }
}

#endif
