//
//  Print.swift
//  
//
//  Created by Pietro Caruso on 04/07/21.
//

import Foundation
import SwiftLoggedPrint

///Used to manage the printed messanges for this library, check the ITzTravelInTime/SwiftLoggedPrint Library for more info
internal class Log: LoggedPrinter{
    override class var prefix: String{
        self.allowsLogging = false
        return "[TINURecovery]"
    }
    
    override class var printerID: String{
        return "TINURecoveryPrinter"
    }
}
