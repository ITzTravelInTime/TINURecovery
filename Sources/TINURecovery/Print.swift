//
//  Print.swift
//  
//
//  Created by Pietro Caruso on 04/07/21.
//

import Foundation
import SwiftLoggedPrint

///Used to manage the printed messanges for this library, check the ITzTravelInTime/SwiftLoggedPrint Library for more info
public class Printer: LoggedPrinter{
    public override class var prefix: String{
        self.allowsLogging = false
        return "[TINURecovery]"
    }
    
    public override class var printerID: String{
        return "TINURecoveryPrinter"
    }
}
