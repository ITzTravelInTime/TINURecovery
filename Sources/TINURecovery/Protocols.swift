//
//  Protocols.swift
//
//
//  Created by Pietro Caruso on 29/06/21.
//

/*
 TINURecovery: Library with the Recovery Mode, SIP, Sandbox, User detection, nvram and network detection functions used by TINU.
 Copyright (C) 2021 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */
import Foundation

///Standard protocol for objects that creates copies if themselfs.
public protocol Copying{
    func copy() -> Self
}

///This protocol is used to provvide a standard interface of objects that needs to have simulated states using their subclasses
public protocol SimulatableDetectableBase {
    associatedtype T
    static var simulatedStatus: T? { get }
    static func calculateStatus() -> T
    static var actualStatus: T { get }
    //static var status: T { get }
    init()
}

public extension SimulatableDetectableBase{
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

///This protocol is used to provvide a standard interface of objects that needs to have simulated states using their subclasses
public protocol SimulatableDetectable: SimulatableDetectableBase {}

public extension SimulatableDetectable{
    /**
     Returns the current status or of the value
     */
    static var actualStatus: T{
        return calculateStatus()
    }
    
}

///This protocol is used to provvide a standard interface of objects that needs to have simulated states using their subclasses and have time intervals between each sample collection
public protocol SimulatableDetectableTemporized: SimulatableDetectableBase{
    static var  expirationInterval: TimeInterval { get }
    
    static var expiration: Date { get set }
    static var storedStatus: T? { get set }
}

///This protocol is used to provvide a standard interface of objects that needs to have simulated states using their subclasses and have time intervals between each sample collection
public extension SimulatableDetectableTemporized{
    
    private static var statusManager: T?{
        get{
            if storedStatus == nil{
                Printer.debug("Currently stored status is invalid, recalculating ...")
                return nil
            }
            
            let difference = Date().timeIntervalSince(expiration)
            
            Printer.debug("Time since last status check: \(difference) seconds/s")
            
            if difference < expirationInterval  {
                return storedStatus
            }else{
                Printer.debug("Currently stored status is expired, recalculating ...")
                return nil
            }
            
        }
        set{
            storedStatus = newValue
            expiration = Date()
        }
    }
    
    /**
    Returns the actual current status with temporization between status calculations
     */
    static var actualStatus: T {
        
        if let current = statusManager {
            return current
        }
        
        let current = calculateStatus()
        statusManager = current
        return current
        
    }
}

///This protocol is used to provvide a standard interface of objects that needs to have simulated states using their subclasses and have time intervals between each sample collection
public protocol SimulatableDetectableOneTime: SimulatableDetectableBase{
    static func calculateStatus() -> T
    
    static var storedStatus: T? { get set }
}

///This protocol is used to provvide a standard interface of objects that needs to have simulated states using their subclasses and have time intervals between each sample collection
public extension SimulatableDetectableOneTime{
    
    /**
    Returns the actual current status with temporization between status calculations
     */
    static var actualStatus: T {
        
        if let current = storedStatus {
            return current
        }
        
        let current = calculateStatus()
        storedStatus = current
        return current
        
    }
}
