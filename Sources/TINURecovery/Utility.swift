//
//  Utility.swift
//  
//
//  Created by Pietro Caruso on 29/06/21.
//

import Foundation

/**
 Little function to make our prints prettyer

    - Parameter val: the boolean value to convert for our pretty print.
 
    - Returns: if val is true a string saying `"Yes"` is returned, otherwise a string saying `"No"` is returned
 */
@inline(__always) internal func boolToPrettyStr( _ val: Bool) -> String{
    return val ? "Yes" : "No"
}
