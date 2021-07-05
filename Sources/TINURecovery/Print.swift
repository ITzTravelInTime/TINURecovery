//
//  Print.swift
//  
//
//  Created by Pietro Caruso on 04/07/21.
//

import Foundation
import SwiftLoggedPrint

internal class Log: LoggedPrinter{
    override class var prefix: String{
        return "[TINURecovery]"
    }
    
    override class var debugPrefix: String{
        return "[Debug]"
    }
    
    override class var printerID: String{
        return "TINURecoveryPrinter"
    }
}
