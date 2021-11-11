//Credits:
//http://www.opensource.apple.com/source/system_cmds/system_cmds-643.30.1/nvram.tproj/nvram.c

import IOKit
import Foundation

///Class used for NVRAM management
public class NVRAM {
    
    private static let optionsRef = IORegistryEntryFromPath(IOServiceGetMatchingService(kIOMasterPortDefault, nil), "IODeviceTree:/options")

    ///Sets a string into NVRAM
    public class func setString(name: String, value: String) {
        assert(!Sandbox.isEnabled, "NVRAM function works only for non-sandboxed apps")
        
        let nameRef = CFStringCreateWithCString(kCFAllocatorDefault, name, CFStringBuiltInEncodings.UTF8.rawValue)
        
        // As CFString (Switched to NSData due to issues with trailing %00 characters in values after reboot)
        //let valueRef = CFStringCreateWithCString(kCFAllocatorDefault, value, CFStringBuiltInEncodings.UTF8.rawValue)
        
        // CFData is “toll-free bridged” with its Cocoa Foundation counterpart, NSData.
        let valueRef = NSData(data: value.data(using: .ascii)!)//.dataUsingEncoding(NSASCIIStringEncoding)
        
        IORegistryEntrySetCFProperty(optionsRef, nameRef, valueRef)
    }
    
    ///Sets an integer value into NVRAM
    public class func setInteger<T: FixedWidthInteger>(name: String, value: T) {
        assert(!Sandbox.isEnabled, "NVRAM function works only for non-sandboxed apps")
        let nameRef = CFStringCreateWithCString(kCFAllocatorDefault, name, CFStringBuiltInEncodings.UTF8.rawValue)
        
        var val = T(value)
        let valueRef = NSData(bytes: &val, length: MemoryLayout<T>.size)
        
        IORegistryEntrySetCFProperty(optionsRef, nameRef, valueRef)
    }

    ///Reads an string value from NVRAM
    public class func getString(name: String) -> String? {
        assert(!Sandbox.isEnabled, "NVRAM function works only for non-sandboxed apps")
        let nameRef = CFStringCreateWithCString(kCFAllocatorDefault, name, CFStringBuiltInEncodings.UTF8.rawValue)
        
        guard let valueRef = IORegistryEntryCreateCFProperty(optionsRef, nameRef, kCFAllocatorDefault, 0) else{
            return nil
        }
        
        print(valueRef)

        if let data = valueRef.takeUnretainedValue() as? NSData {
            print(data)
            return String(data: Data(data), encoding: .ascii)
        }
            
        return valueRef.takeRetainedValue() as? String
    }
    
    ///Reads an integer value from NVRAM
    public class func getInteger<T: FixedWidthInteger>(name: String) -> T?{
        assert(!Sandbox.isEnabled, "NVRAM function works only for non-sandboxed apps")
        let nameRef = CFStringCreateWithCString(kCFAllocatorDefault, name, CFStringBuiltInEncodings.UTF8.rawValue)
        
        guard let valueRef = IORegistryEntryCreateCFProperty(optionsRef, nameRef, kCFAllocatorDefault, 0) else{
            return nil
        }
        
        if let data = valueRef.takeUnretainedValue() as? NSData {
            
            if data.length != MemoryLayout<T>.size{
                return nil
            }
            
            let ret = Data(data).withUnsafeBytes({
                
                (rawPtr: UnsafeRawBufferPointer) in
                return rawPtr.load(as: T.self)
                
            })
            
            return ret
        }
            
        return valueRef.takeRetainedValue() as? T
    }
    
}
