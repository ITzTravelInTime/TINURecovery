//Created By ITzTravelInTime (Pietro Caruso) 2021

import Foundation

#if os(macOS)
/**This class manages the macOS Recovery/Installer OS detection functions.
 
 You must override this class in order to change the simulateRecovery value for debugging purpose, so for actual usage is reccommended using a subclass of this one*/
public class TINURecovery{
    
    /**Used to simulate the detection of a macOS Recover/Installer OS for debugging purposes*/
    public class var simulateRecovery: Bool{
        //This implementation allows for overridability by subsclasses
        return false
    }
    
    /**Detects if the app is actually running on a macOS Recovery/Installer OS or not*/
    public static var isActuallyOn: Bool{
        //Uses a static value to avoid repeting the detection code for each call of the variable
        struct MEM{
            static var tempReallyRecovery: Bool! = nil
        }
        
        if MEM.tempReallyRecovery == nil{
            var really = false
            
            if User.isRoot && !Sandbox.isEnabled{
                really = !FileManager.default.fileExists(atPath: "/usr/bin/sudo")
            }
            
            MEM.tempReallyRecovery = really
        }
        
        return MEM.tempReallyRecovery
    }
    
    /**Detects if the app is running on a macOS Recovery/Installer OS or in a simulated recovery os (Simulating the recovery OS allows for debugging of thinks like dedicated UI using your normal development tools like Xcode)*/
    public static var isOn: Bool{
        //Uses a static value to avoid repeting the detection code for each call of the variable
        struct MEM{
            static var state: Bool! = nil
        }
        
        if MEM.state == nil{
            if isActuallyOn{
                print("Running on the root user on a mac os recovery")
                MEM.state = true
            }else{
                print("Running on this user: " + User.name)
                
                if simulateRecovery{
                    print("Recovery mode simulation activated")
                }
                
                MEM.state = simulateRecovery
            }
        }
        
        return MEM.state
    }
}

#endif

/**This class manages app sandbox detection code*/
public final class Sandbox{
    /**Detects is the current program is running as sandboxed or not*/
    public static var isEnabled: Bool {
        //Uses a static value to avoid repeting the detection code for each call of the variable
        struct MEM{
            static var state: Bool! = nil
        }
        
        if MEM.state == nil{
            let environment = ProcessInfo.processInfo.environment
            MEM.state = environment["APP_SANDBOX_CONTAINER_ID"] != nil
        }
        
        return MEM.state
    }
}

/**This class is a more elegant way of detecting the current user name and is it's root*/
public final class User{
    /**Detects the logon name of the current user.*/
    public static var name: String{
        return NSUserName()
    }
    
    /**Detects if the current user is Root*/
    public static var isRoot: Bool{
        return name == "root"
    }
}
