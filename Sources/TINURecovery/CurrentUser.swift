//
//  CurrentUser.swift
//
//
//  Created by Pietro Caruso on 29/06/21.
//


import Foundation

///This class is a more elegant way of detecting the current user name and is it's root
public final class CurrentUser{
    ///Detects the logon name of the current user.
    public static var name: String{
        //Uses a static value to avoid repeting the detection code for each call of the variable
        struct MEM{
            static var state: String! = nil
        }
        
        if MEM.state == nil{
            MEM.state = NSUserName()
            print("Current user is: " + MEM.state!)
        }
        
        return MEM.state
    }
    
    ///Detects if the current user is Root
    public static var isRoot: Bool{
        //Uses a static value to avoid repeting the detection code for each call of the variable
        struct MEM{
            static var state: Bool! = nil
        }
        
        if MEM.state == nil{
            MEM.state = name == "root"
            print("Is the current user Root?: \(boolToPrettyStr(MEM.state!))")
        }
        
        return MEM.state
    }
}
