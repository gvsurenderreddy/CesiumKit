//
//  CesiumKitController.swift
//  CesiumKit
//
//  Created by Ryan Walklin on 6/01/2016.
//  Copyright © 2016 Test Toast. All rights reserved.
//

import Foundation
import MetalKit
import CesiumKit

class CesiumKitController: NSObject, MTKViewDelegate {
    
    private let _globe: CesiumGlobe!
    
    private let _view: MTKView
    
    private let _viewportOverlay: ViewportQuad
    
    private let _fontName = "HelveticaNeue"
    private let _fontSize: Float = 36
    
    private var _fontAtlas: FontAtlas
    
    init (view: MTKView) {
        
        _view = view
        _view.device = MTLCreateSystemDefaultDevice()
        _view.colorPixelFormat = PixelFormat.BGRA8Unorm.toMetal()
        _view.depthStencilPixelFormat = PixelFormat.Depth32FloatStencil8.toMetal()
        _view.framebufferOnly = false
        _view.preferredFramesPerSecond = 60
        _view.autoResizeDrawable = true
        
        let options = CesiumOptions(
            clock: Clock(clockStep: .SystemClock, isUTC: false),
            imageryProvider: nil,
            terrain: false,
            skyBox: true,
            scene3DOnly: false
        )

        _globe = CesiumGlobe(view: _view, options: options)
        //_globe.scene.imageryLayers.addImageryProvider(BingMapsImageryProvider())
        _globe.scene.imageryLayers.addImageryProvider(TileCoordinateImageryProvider())
        
        _globe.scene.camera.constrainedAxis = Cartesian3.unitZ
        
        //Flat ocean view
        //_globe.scene.camera.setView(positionCartographic: Cartographic(longitude: 0.0, latitude: 0.0, height: 100), heading: 0, pitch: Math.toRadians(-90), roll: 0)
        //
        
        // Everest
        //_globe.scene.camera.lookAt(Cartesian3.fromDegrees(longitude: 86.95278, latitude: 28.288056, height: 10000), offsetCartesian: nil, offsetHPR: HeadingPitchRange(heading: Math.toRadians(180.0), pitch: Math.toRadians(-90), range: 1000))
        
        // Murrumbeena
        //_globe.scene.camera.setView(position: Cartesian3.fromDegrees(longitude: 145.075, latitude: -37.892, height: 1000), heading: 0, pitch: 0, roll: 0)
        
        //Wellington,
        //_globe.scene.camera.setView(position: Cartesian3.fromDegrees(longitude: 174.784356, latitude: -41.438928, height: 1000), heading: 0, pitch: 0, roll: 0)
        //_globe.scene.camera.viewRectangle(Rectangle(fromDegreesWest: 150, south: -90, east: 110, north: 20))
        
        var fontAtlas: FontAtlas? = nil
        /*#if !MBE_FORCE_REGENERATE_FONT_ATLAS
         _fontAtlas = [NSKeyedUnarchiver unarchiveObjectWithFile:fontURL.path];
         #endif*/
        // Cache miss: if we don't have a serialized version of the font atlas, build it now
        
        if fontAtlas == nil {
            _fontAtlas = FontAtlas.fromCache(fontName: _fontName, pointSize: _fontSize)
            //[NSKeyedArchiver archiveRootObject:_fontAtlas toFile:fontURL.path];
        } else {
            _fontAtlas = fontAtlas!
        }
        
        /*
         MTLTextureDescriptor *textureDesc = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:MTLPixelFormatR8Unorm
         width:MBEFontAtlasSize
         height:MBEFontAtlasSize
         mipmapped:NO];
         MTLRegion region = MTLRegionMake2D(0, 0, MBEFontAtlasSize, MBEFontAtlasSize);
         _fontTexture = [_device newTextureWithDescriptor:textureDesc];
         [_fontTexture setLabel:@"Font Atlas"];
         [_fontTexture replaceRegion:region mipmapLevel:0 withBytes:_fontAtlas.textureData.bytes bytesPerRow:MBEFontAtlasSize];*/

        let viewportFabric = ColorFabricDescription(color: Color(fromRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.8))
        _viewportOverlay = ViewportQuad(
            rectangle: BoundingRectangle(x: 20, y: 20, width: 200, height: 200),
            material: Material(fromType: ColorMaterialType(fabric: viewportFabric))
        )
        _globe.scene.primitives.add(_viewportOverlay)
        
        let labels = LabelCollection(scene: _globe.scene)
        labels.add(
            position: Cartesian3(x: 4.0, y: 5.0, z: 6.0),
            text: "A label"
        )
        _globe.scene.primitives.add(labels)
        
        super.init()
    }
    
    func startRendering () {
        _view.paused = false
    }
    
    func stopRendering () {
        _view.paused = true
    }
    
    func drawInMTKView(view: MTKView) {
        #if os(iOS)
            let scaleFactor = view.contentScaleFactor
        #elseif os(OSX)
            let scaleFactor = view.layer?.contentsScale ?? 1.0
        #endif
        let viewBoundsSize = view.bounds.size
        let renderWidth = viewBoundsSize.width * scaleFactor
        let renderHeight = viewBoundsSize.height * scaleFactor
        
        let renderSize = CGSizeMake(renderWidth, renderHeight)
        
        _globe.render(renderSize)
    }
    
    func mtkView(view: MTKView, drawableSizeWillChange size: CGSize) {
        _viewportOverlay.rectangle = BoundingRectangle(x: 20, y: 20, width: Double(size.width)/2-40, height: Double(size.height)/2-40)
        /*let scale = self.v!.backingScaleFactor
         let layerSize = view.bounds.size
         
         _metalView.metalLayer.contentsScale = scale
         _metalView.metalLayer.frame = CGRectMake(0, 0, layerSize.width, layerSize.height)
         _metalView.metalLayer.drawableSize = CGSizeMake(layerSize.width * scale, layerSize.height * scale)*/
    }
    
}