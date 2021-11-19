# TINURecovery

Library with the Recovery Mode, SIP, Sandbox, User detection, nvram and network detection functions used by [TINU](https://github.com/ITzTravelInTime/TINU)

# Features and usage

SimulatableDetectable:

- A set of protocols for objects that needs to have simulated debug states. 
    
    Example usage:

```swift

import TINURecovery

class Foo: SimulatableDetectable{

    ///if this property is nil the `actualStatus` property will be returned by the `status` propert, otherwise that will return the value of this property
    static var simulatedStatus: Bool? = nil
    
    ///Returns the actual status
    static func calculateStatus() -> Bool{
        return false
    }
    
    ///Initializer for compliance with the protocol
    public required init(){  }
    
}

print("Testing Foo status: ")

print("Foo status: \(Foo.status)") //returns false
print("Foo actual status: \(Foo.actualStatus)") //returns false

print("Simulating a new status")
Foo.simulatedStatus = true

print("Foo status: \(Foo.status)") //returns true
print("Foo actual status: \(Foo.actualStatus)") //returns false

print("Foo testing is complete")

```

SimpleReachability:

- Provvides a simple way to check if network conenction is available.

Basic example usage

```swift

import TINURecovery

print("Is the computer connected to the network? \(SimpleReachability.status ? "Yes" : "No")")

```

- 

Recovery:

**WARNING**: Requires sandboxing to be disabled.

- [Available only on macOS] detects if the current program is running inside a macOS Installer/Recovery OS and allows for debugabbility inside a normal macOS by creating a subclass and overriding the 'simulatedStatus' value.

    Basic example usage:

```swift

import TINURecovery

print("Is this program running on a macOS Recovery/Installer OS? \((Recovery.status ? "Yes" : "No"))")

```

SIP:

**WARNING**: Requires sandboxing to be disabled.

- [Available only on macOS] detects the status of macOS's SIP (System Integrity Protection) and allows for debugabbility reguardless of the actual status of it on the computer by creating a subclass and overriding the 'simulatedStatus' propery.

    Basic example usage:

```swift

import TINURecovery

if let status = SIP.status.resultsEnabled {
    print("Is SIP activated? \(status ? "Yes" : "No")")
}else{
    print("SIP status is unknown")
}

print("Does SIP use a custom configuration? \(SIP.status.usesCustomConfiguration ? "Yes" : "No")")

```

Sandbox: 

- [Available only on macOS] Used to detect if the current app is running with the app Sandbox enabled or not.

    Example usage:

```swift

import TINURecovery

print("Is this app sandboxed? \(Sandbox.isEnabled ? "Yes" : "No")")

```

User:

- [Available only on macOS] Just a more convenenint way of getting the current user's logon name and if it's the Root user.

    Example usage:

```swift

import TINURecovery

print("Is this user Root? \(CurrentUser.isRoot ? "Yes" : "No")")
print("What's the user name? \(CurrentUser.name)")

```

NVRAM:

**WARNING**: Requires sandboxing to be disabled.

- [Available only on macOS] A simple way to read and write NVRAM values

    Example usage:
    
```swift

import TINURecovery

if let args = NVRAM.getString(name: "boot-args") {
    print("Current boot args: \(args)")
}

```

# Who should use this Library?

This library should be used by swift apps/programs that requires to obtain particular info about the system, things like the SIP status, or particular info about the app/program itself like the if sandboxing is enabled.

This code is intended for macOS only, it might also work on other Apple's OSes for the non-macOS-specific features but it's untested.

# About the project

This code was created as part of my TINU project (https://github.com/ITzTravelInTime/TINU) and has been separated and made into it's own library to make the main project's source less complex and more focused on it's aim. 

Also having it as it's own library allows for code to be updated separately and so various versions of the main TINU app will be able to be compiled all with the latest version of this library.

# Libraries used

 - [ITzTravelInTime/SwiftCPUDetect](https://github.com/ITzTravelInTime/SwiftCPUDetect)
 - [ITzTravelInTime/Command](https://github.com/ITzTravelInTime/Command)
 - [ITzTravelInTime/SwiftLoggedPrint](https://github.com/ITzTravelInTime/SwiftLoggedPrint)

# Credits

 - [ITzTravelInTime (Pietro Caruso)](https://github.com/ITzTravelInTime) - Project creator and main developer
 - [khronokernel](https://github.com/khronokernel) - Help with SIP detection, bit values and their descriptions.
 
  - Source for the SIP bits: 
    https://opensource.apple.com/source/xnu/xnu-7195.121.3/bsd/sys/csr.h.auto.html 
    https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/Resources/Constants.py
  
  - NVRAM Code: https://gist.github.com/hansen-m/3e9632ce6fd5b9e3a768321dc5bb4bdc
 

# Contacts

 - ITzTravelInTime (Pietro Caruso): piecaruso97@gmail.com

# Copyright
TINURecovery: Library with the Recovery Mode, SIP, Sandbox, User detection, nvram and network detection functions used by TINU.
Copyright (C) 2021 Pietro Caruso

This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA



