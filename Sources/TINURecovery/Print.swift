//
//  Print.swift
//  
//
//  Created by Pietro Caruso on 04/07/21.
//

import Foundation
import SwiftLoggedPrint

internal class Log: LoggedPrinter{
    static var prefix: String{
        return "[TINURecovery]"
    }
    
    static var debugPrefix: String{
        return "[Debug]"
    }
    
    class func print( _ str: String){
        
        //allowsLogging = false
        
        super.print(str)
    }
}
