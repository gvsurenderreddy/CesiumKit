//
//  Imagery.swift
//  CesiumKit
//
//  Created by Ryan Walklin on 16/08/14.
//  Copyright (c) 2014 Test Toast. All rights reserved.
//

/**
* Stores details about a tile of imagery.
*
* @alias Imagery
* @private
*/
class Imagery {
    
    var imageryLayer: ImageryLayer

    var level: Int
    
    var x: Int
    
    var y: Int
    
    var parent: ImageryLayer? = nil
    
    var rectangle: Rectangle? = nil
    
    var image: AnyObject? = nil
    
    var imageUrl: String? = nil
    
    var state: ImageryState = ImageryState.Unloaded
    
    var texture: Texture? = nil
    
    var referenceCount = 0
    
    var credits: Credit? = nil

    init(imageryLayer, level, x, y, rectangle) {
        
        self.imageryLayer = imageryLayer
        self.level = level
        self.x = x
        self.y = y
        
        if (level != 0) {
            var parentX = x / 2 | 0
            var parentY = y / 2 | 0
            var parentLevel = level - 1
            parent = imageryLayer.getImageryFromCache(parentX, parentY, parentLevel);
        }
        
        if self.rectangle = nil && imageryLayer.imageryProvider.ready {
            var tilingScheme = imageryLayer.imageryProvider.tilingScheme
            self.rectangle = tilingScheme.tileXYToRectangle(x, y, level)
        }
    }

    /*Imagery.createPlaceholder = function(imageryLayer) {
    var result = new Imagery(imageryLayer, 0, 0, 0);
    result.addReference();
    result.state = ImageryState.PLACEHOLDER;
    return result;
    };
    
    Imagery.prototype.addReference = function() {
    ++this.referenceCount;
    };
    
    Imagery.prototype.releaseReference = function() {
    --this.referenceCount;
    
    if (this.referenceCount === 0) {
    this.imageryLayer.removeImageryFromCache(this);
    
    if (defined(this.parent)) {
    this.parent.releaseReference();
    }
    
    if (defined(this.image) && defined(this.image.destroy)) {
    this.image.destroy();
    }
    
    if (defined(this.texture)) {
    this.texture.destroy();
    }
    
    destroyObject(this);
    
    return 0;
    }
    
    return this.referenceCount;
    };
    
    return Imagery;
    });*/
}