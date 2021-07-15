import Foundation
import TINURecovery
import class Command.Printer

//Disasble library's debug printing for convencience

TINURecovery.Printer.enabled = false
Command.Printer.enabled = false

//This class is an example of a SimulatableDetectable type

class Foo: SimulatableDetectable{

    ///if this property is nil the `actualStatus` property will be returned by the `status` propert, otherwise that will return the value of this property
    static var simulatedStatus: Bool? = nil
    
    ///Returns the actual status
    static var actualStatus: Bool{
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

#if os(macOS)
//This is an example usage for Recovery

print("Is this program running on a macOS Recovery/Installer OS? \((Recovery.status ? "Yes" : "No"))")

//This is an example usage for SIP

if let status = SIP.status.resultsEnabled {
    print("Is SIP activated? \(status ? "Yes" : "No")")
}else{
    print("SIP status is unknown")
}

print("Does SIP use a custom configuration? \(SIP.status.usesCustomConfiguration ? "Yes" : "No")")

//This is an example usage for CurrentUser

print("Is this user Root? \(CurrentUser.isRoot ? "Yes" : "No")")
print("What's the user name? \(CurrentUser.name)")

//This is an example usage for the Sandbox Detection

print("Is this app sandboxed? \(Sandbox.isEnabled ? "Yes" : "No")")

#endif
