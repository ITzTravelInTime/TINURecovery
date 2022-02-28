import Foundation
import TINURecovery

//Disasble library's debug printing for convencience

TINURecovery.Printer.enabled = false

//This class is an example of a SimulatableDetectable type

class Foo: SimulatableDetectable{

    ///if this property is nil the `actualStatus` property will be returned by the `status` propert, otherwise that will return the value of this property
    static var simulatedStatus: Bool? = nil
    
    ///Returns the actual status
    static func calculateStatus() -> Bool {
        return false
    }
    
    ///Initializer for compliance with the protocol
    public required init(){ }
    
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

print("SIP raw status: 0x\(String(SIP.status, radix: 16) )")

print("Is SIP fully disabled? \(SIP.status.resultsFullyDisabled ? "Yes" : "No")")

if let status = SIP.status.resultsEnabled {
    print("Is SIP activated? \(status ? "Yes" : "No")")
}else{
    print("SIP status is unknown")
}

print("Does SIP use a custom configuration? \(SIP.status.usesCustomConfiguration ? "Yes" : "No")")

print("Detailed SIP Configuration")
print(SIP.status.detailedConfiguration)

if let args = NVRAM.getString(forKey: "boot-args") {
    print("Current boot args: \(args)")
}

//This is an example usage for CurrentUser

print("Is this user Root? \(CurrentUser.isRoot ? "Yes" : "No")")
print("What's the user name? \(CurrentUser.name)")

//This is an example usage for the Sandbox Detection

print("Is this app sandboxed? \(Sandbox.isEnabled ? "Yes" : "No")")

//This is an example usage for SimpleReachability

print("Is the computer connected to the network? \(SimpleReachability.status ? "Yes" : "No")")


#endif
