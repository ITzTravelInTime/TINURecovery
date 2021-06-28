//Created By ITzTravelInTime (Pietro Caruso) 2021

import Foundation

/**
 Little function to make our prints prettyer

    - Parameter val: the boolean value to convert for our pretty print.
 
    - Returns: if val is true a string saying `"Yes"` is returned, otherwise a string saying `"No"` is returned
 */
@inline(__always) fileprivate func boolToPrettyStr( _ val: Bool) -> String{
    return val ? "Yes" : "No"
}

///This protocol is used to provvide a standard interface of objects that needs to have simulated states using their subclasses
public protocol Simulatable {
    associatedtype T
    static var simulatedStatus: T? { get }
}

#if os(macOS)

/**This class manages the macOS Recovery/Installer OS detection functions.
 
 You must override this class in order to change the `simulateRecovery` value for debugging purposes, so for actual usage is reccommended (but not necessary) using a subclass of this one.
 
 */
open class TINURecovery: Simulatable{
    
    private static var storedSimulatedStatus: Bool? = nil
    
    /**
     Used to simulate the detection of a macOS Recover/Installer OS for debugging purposes.
     
     Simulating the recovery OS allows for debugging of things like dedicated UI using your normal development tools like Xcode.
     You must override this value inside a subclass of `TINURecovery` in order to change it's value, therefor it's reccomended that this class is used with a subclass instead.
     */
    open class var simulatedStatus: Bool?{
        set{
            storedSimulatedStatus = newValue
        }
        get{
            return storedSimulatedStatus
        }
    }
    
    /**
     Detects if the app is actually running on a macOS Recovery/Installer OS.
     
     Use this to only if this information is needed to perform tasks that only works inside the macOS Recovery/Installer OS evironment.
     */
    public static var isActuallyOn: Bool{
        //Uses a static value to avoid repeting the detection code for each call of the variable
        struct MEM{
            static var state: Bool! = nil
        }
        
        if MEM.state == nil{
            MEM.state = false
            
            if Sandbox.hasUnrestrictedAccess{
                //Recovery/Installer OSes don't have the sudo executable and the use is just Root
                MEM.state = !FileManager.default.fileExists(atPath: "/usr/bin/sudo")
            }
            
            print("Are we actually into a macOS Recovery/Installer OS? \(boolToPrettyStr(MEM.state!))")
        }
        
        return MEM.state
    }
    
    /**
     Detects if the app is running on a macOS Recovery/Installer OS or in a simulated recovery os.
     
     It's reccommended to use this to determinate if the recovery mode is active, especially if this information is used with the purpose of setting up some user interface.
     
     */
    public static var isOn: Bool{
        //Uses a static value to avoid repeting the detection code for each call of the variable
        struct MEM{
            static var state: Bool! = nil
        }
        
        if MEM.state == nil{
            
            MEM.state = simulatedStatus ?? false || isActuallyOn
            
            if simulatedStatus ?? false{
                print("macOS Recovery/Installer OS simulation activated")
            }
            
            print("Are we either into a real or simulated macOS Recovery/Installer OS? \(boolToPrettyStr(MEM.state!))")
        }
        
        return MEM.state
    }
}

#endif

///This class manages program sandbox detection code
public final class Sandbox{
    ///Detects is the current program is running as sandboxed
    public static var isEnabled: Bool {
        //Uses a static value to avoid repeting the detection code for each call of the variable
        struct MEM{
            static var state: Bool! = nil
        }
        
        if MEM.state == nil{
            MEM.state = ProcessInfo.processInfo.environment["APP_SANDBOX_CONTAINER_ID"] != nil
            print("Is Sandbox enabled? \(boolToPrettyStr(MEM.state!))")
        }
        
        return MEM.state
    }
    
    /**
     Determinates if the current program has unrestricted access
     
     Programs with unrestricted access runs as root and are not sandboxed.
     
     */
    public static var hasUnrestrictedAccess: Bool{
        if !isEnabled && CurrentUser.isRoot{
            print("Keep in mind that this app has unrestricted access now!")
            return true
        }
        print("Sadly our access is somewhat restricted")
        return false
    }
}

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
            print("Running on this user: " + MEM.state!)
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
            print("Is Root user?: \(boolToPrettyStr(MEM.state!))")
        }
        
        return MEM.state
    }
}
