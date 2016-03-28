//
//  RenderPipeline.swift
//  CesiumKit
//
//  Created by Ryan Walklin on 31/05/2015.
//  Copyright (c) 2015 Test Toast. All rights reserved.
//

import Metal

class RenderPipeline {
    
    let state: MTLRenderPipelineState!
    
    let shaderProgram: ShaderProgram
    
    var keyword: String {
        return state.label ?? ""
    }
    
    var blendingState: BlendingState? = nil
    
    var count: Int = 0
    
    private var _descriptor: MTLRenderPipelineDescriptor
    
    init (device: MTLDevice, shaderProgram: ShaderProgram, descriptor: MTLRenderPipelineDescriptor) {
        
        self.shaderProgram = shaderProgram
        _descriptor = descriptor
        do {
            let state = try device.newRenderPipelineStateWithDescriptor(_descriptor)
            self.state = state
        } catch let error as NSError  {
            state = nil
            assertionFailure("newRenderPipelineStateWithDescriptor failed: \(error.localizedDescription)")
        }
    }
    
    static func fromCache (context context: Context, vertexShaderSource vss: ShaderSource, fragmentShaderSource fss: ShaderSource, vertexDescriptor vd: VertexDescriptor?, colorMask: ColorMask? = nil, depthStencil: Bool, blendingState: BlendingState? = nil) -> RenderPipeline {

        return context.pipelineCache.getRenderPipeline(vertexShaderSource: vss, fragmentShaderSource: fss, vertexDescriptor: vd, colorMask: colorMask, depthStencil: depthStencil, blendingState: blendingState)
    }
    
    static func replaceCache (context: Context,  pipeline: RenderPipeline?, vertexShaderSource vss: ShaderSource, fragmentShaderSource fss: ShaderSource, vertexDescriptor vd: VertexDescriptor?, colorMask: ColorMask? = nil, depthStencil: Bool, blendingState: BlendingState? = nil) -> RenderPipeline? {
        
        return context.pipelineCache.replaceRenderPipeline(pipeline, vertexShaderSource: vss, fragmentShaderSource: fss, vertexDescriptor: vd, colorMask: colorMask, depthStencil: depthStencil, blendingState: blendingState)
    }
    
    static func withCompiledShader(context: Context, shaderSourceName: String, compiledMetalVertexName vertex: String, compiledMetalFragmentName fragment: String, uniformStructSize: Int, vertexDescriptor vd: VertexDescriptor?, colorMask: ColorMask? = nil, depthStencil: Bool, blendingState: BlendingState? = nil) -> RenderPipeline? {
        return context.pipelineCache.getRenderPipeline(shaderSourceName: shaderSourceName, compiledMetalVertexName: vertex, compiledMetalFragmentName: fragment, uniformStructSize: uniformStructSize, vertexDescriptor: vd, colorMask: colorMask, depthStencil: depthStencil, blendingState: blendingState)
    }
    
    func setUniforms(command: DrawCommand, device: MTLDevice, uniformState: UniformState) -> (buffer: Buffer, fragmentOffset: Int, texturesValid: Bool, textures: [Texture]) {
        if command.uniformBufferProvider == nil {
            command.uniformBufferProvider = shaderProgram.createUniformBufferProvider(device)
            command.automaticUniformBufferProvider = UniformBufferProvider(device: device, capacity: 3, bufferSize: strideof(AutomaticUniformBufferLayout))
            command.frustumUniformBufferProvider = UniformBufferProvider(device: device, capacity: 3, bufferSize: strideof(FrustumUniformBufferLayout))
        }
        return shaderProgram.setUniforms(command, uniformState: uniformState)
    }
}