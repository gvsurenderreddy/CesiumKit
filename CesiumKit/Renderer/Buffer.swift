//
//  Buffer.swift
//  CesiumKit
//
//  Created by Ryan Walklin on 26/05/2015.
//  Copyright (c) 2015 Test Toast. All rights reserved.
//

import Metal

class Buffer {
    
    let metalBuffer: MTLBuffer
    
    var componentDatatype: ComponentDatatype
    
    // bytes
    let length: Int
    
    private let _entireRange: NSRange
    
    var count: Int {
        return length / componentDatatype.elementSize
    }
    
    /**
     Creates a Metal GPU buffer. If an allocated memory region is passed in, it will be
     copied to the buffer and can be released (or automatically released via ARC). 
    */
    init (device: MTLDevice, array: UnsafePointer<Void> = nil, componentDatatype: ComponentDatatype, sizeInBytes: Int, label: String? = nil) {
        assert(sizeInBytes > 0, "bufferSize must be greater than zero")
        
        length = sizeInBytes
        self.componentDatatype = componentDatatype
        _entireRange = NSMakeRange(0, length)
        
        if array != nil {
            #if os(OSX)
                metalBuffer = device.newBufferWithBytes(array, length: length, options: .StorageModeManaged)
            #elseif os(iOS)
                metalBuffer = device.newBufferWithBytes(array, length: length, options: .StorageModeShared)
            #endif
        } else {
            #if os(OSX)
                metalBuffer = device.newBufferWithLength(length, options: .StorageModeManaged)
            #elseif os(iOS)
                metalBuffer = device.newBufferWithLength(length, options: .StorageModeShared)
            #endif
        }
        if let label = label {
            metalBuffer.label = label
        }
    }
    
    func read (into data: UnsafeMutablePointer<Void>, length readLength: Int, offset: Int = 0) {
        assert(offset + readLength <= length, "This buffer is not large enough")
        memcpy(data, metalBuffer.contents()+offset, readLength)
    }
    
    func write (from data: UnsafePointer<Void>, length writeLength: Int, offset: Int = 0) {
        assert(offset + writeLength <= length, "This buffer is not large enough")
        memcpy(metalBuffer.contents()+offset, data, writeLength)
    }
    
    func copy (from other: Buffer, length copyLength: Int, sourceOffset: Int = 0, targetOffset: Int = 0) {
        assert(sourceOffset + copyLength <= other.length, "source buffer not large enough")
        assert(targetOffset + copyLength <= length, "This buffer is not large enough")
        memcpy(metalBuffer.contents()+targetOffset, other.metalBuffer.contents()+sourceOffset, copyLength)
    }
    
    func signalWriteComplete (range: NSRange? = nil) {
        #if os(OSX)
            metalBuffer.didModifyRange(range ?? _entireRange)
        #endif
    }
    
}