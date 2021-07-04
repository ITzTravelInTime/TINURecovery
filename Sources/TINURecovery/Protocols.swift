//
//  Protocols.swift
//
//
//  Created by Pietro Caruso on 29/06/21.
//

//import Foundation

///This protocol is used to provvide a standard interface of objects that needs to have simulated states using their subclasses
public protocol SimulatableDetectable {
    associatedtype T
    //static var simulatedStatus: T? { get }
    static var actualStatus: T { get }
    //static var status: T { get }
    init()
}

public extension SimulatableDetectable{
    
    /**
     Used to simulate the status for debugging purposes.
     
     You can change the `simulatedStatus` value for debugging purposes, but to have more control on it and for actual usage is reccommended (but not necessary) using a subclass of this one, and ovverriding the `simulatedStatus` variable to use it with your own debug variables system.
     */
    static var simulatedStatus: T?{
        return nil
    }
    
    /**
     Returns the current status or of the value of `simulatedStatus` if it's not `nil`
 
     It's reccommended to use this to determinate the status, especially if this information is used with the purpose of setting up some user interface.
     
     You should not ovveride this variable.
     */
    static var status: T{
        if let status = simulatedStatus{
            return status
        }
        
        return actualStatus
    }
}

///Standard protocol for objects that creates copies if themselfs.
public protocol Copying{
    func copy() -> Self
}
