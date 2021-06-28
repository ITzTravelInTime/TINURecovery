# TINURecovery

Library with the Recovery Mode, Sandbox and User detection functions used by TINU (https://github.com/ITzTravelInTime/TINU)

# Features and usage:

Simulatable:

- A protocol for objects that needs to have simulated debug states. 
    
    Example code:

```swift

import TINURecovery

open class Foo: Simulatable{
    
    //Provvided by the protocol, you should override this
    public static var simulatedStatus: Bool? = nil
    
    public class func bar() -> Bool{
        if let status = simulatedStatus{
            return status
        }
        
        return false
    }
}

print("Testing status: ")

print("Foo status: \(Foo.bar())") //returns false

Foo.simulatedStatus = true

print("Bar status: \(Foo.bar())") //returns true

```

TINURecovery:

- [Available only on macOS] Offers values to detect if the current program is running inside a macOS Installer/Recovery OS and allows for debugabbility inside a normal macOS by creating a subclass and overriding the 'simulateRecovery' value.

    Basic example usage:

```swift

import TINURecovery

//You can simulate recovery mode to test UI
TINURecovery.simulatedStatus = true

print("Is this program running on a macOS Recovery/Installer? \((TINURecovery.isOn ? "Yes" : "No"))")

print("Is this program actually running on a macOS Recovery/Installer? \((TINURecovery.isActuallyOn ? "Yes" : "No"))")

```

Sandbox: 

- Used to detect if the current app is running with the app Sandbox enabled or not.

    Example usage:

```swift

import TINURecovery

print("Is this app sandboxed? \(Sandbox.isEnabled ? "Yes" : "No")")

```

User:

- Just a more convenenint way of getting the current user's logon name and if it's the Root user.

    Example usage:

```swift

import TINURecovery

print("Is this user Root? \(CurrentUser.isRoot ? "Yes" : "No")")
print("What's the user name? \(CurrentUser.name)")

```

# Who should use this Library?

This library should be used by swift apps/programs that are intended to run inside the macOS Recovery/Installer OS and normal macOS, therefor apps that needs to detect which envirnoment they are running on, and that's the aim of this project.

This code is intended for macOS only, it might also work on iOS for detecting the root user and Sandbox presence but it's un tested.

# About the project:

This code was created as part of my TINU project (https://github.com/ITzTravelInTime/TINU) and has been separated and made into it's own library to make the main project's source less complex and more focused on it's aim. 

Also having it as it's own library allows for code to be updated separately and so various versions of the main TINU app will be able to be compiled all with the latest version of this library.

# Credits:

ITzTravelInTime (Pietro Caruso) - Project creator



