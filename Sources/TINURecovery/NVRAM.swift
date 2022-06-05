/*
 TINURecovery: Library with the Recovery Mode, SIP, Sandbox, User detection, nvram and network detection functions used by TINU.
 Copyright (C) 2021-2022 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

import Foundation

#if os(macOS)

import TINUIORegistry

///Object used for convenient access to the NVRAM
public let NVRAM = TINUIORegistry.IONVRAM

/*
 import IOKit
 
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
*/
#endif
