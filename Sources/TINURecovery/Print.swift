/*
 TINURecovery: Library with the Recovery Mode, SIP, Sandbox, User detection, nvram and network detection functions used by TINU.
 Copyright (C) 2021 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

import Foundation
import SwiftLoggedPrint

///Used to manage the printed messanges for this library, check the ITzTravelInTime/SwiftLoggedPrint Library for more info
public class Printer: LoggedPrinter{
    
    public override class var prefix: String{
        return "[TINURecovery]"
    }
    
    public override class var printerID: String{
        return "TINURecoveryPrinter"
    }
    
}
