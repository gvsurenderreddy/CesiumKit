//
//  DepthFunction.swift
//  CesiumKit
//
//  Created by Ryan Walklin on 13/09/14.
//  Copyright (c) 2014 Test Toast. All rights reserved.
//

import OpenGLES

/**
* Determines the function used to compare two depths for the depth test.
*
* @namespace
* @alias DepthFunction
*/
enum DepthFunction: GLenum {
    /**
    * 0x200.  The depth test never passes.
    *
    * @type {Number}
    * @constant
    */
    case Never = 0x0200,
    
    /**
    * 0x201.  The depth test passes if the incoming depth is less than the stored depth.
    *
    * @type {Number}
    * @constant
    */
    Less = 0x201,
    
    /**
    * 0x202.  The depth test passes if the incoming depth is equal to the stored depth.
    *
    * @type {Number}
    * @constant
    */
    Equal = 0x0202,
    
    /**
    * 0x203.  The depth test passes if the incoming depth is less than or equal to the stored depth.
    *
    * @type {Number}
    * @constant
    */
    LessOrEqual = 0x203, // LEQUAL
    
    /**
    * 0x204.  The depth test passes if the incoming depth is greater than the stored depth.
    *
    * @type {Number}
    * @constant
    */
    Greater = 0x0204,
    
    /**
    * 0x0205.  The depth test passes if the incoming depth is not equal to the stored depth.
    *
    * @type {Number}
    * @constant
    */
    NotEqual = 0x0205, // NOTEQUAL
    
    /**
    * 0x206.  The depth test passes if the incoming depth is greater than or equal to the stored depth.
    *
    * @type {Number}
    * @constant
    */
    GreaterOrAlways = 0x0206, // GEQUAL
    
    /**
    * 0x207.  The depth test always passes.
    *
    * @type {Number}
    * @constant
    */
    Always = 0x0207
}