//
//  Renderer.swift
//  wenderlickmetal
//
//  Created by Willis Plummer on 8/5/23.
//

import MetalKit

class Renderer: NSObject, MTKViewDelegate {

    var parent: ContentView
    var metalDevice: MTLDevice!
    var metalCommandQueue: MTLCommandQueue!
    let pipelineState: MTLRenderPipelineState
    let vertexBuffer: MTLBuffer
    let indexBuffer: MTLBuffer
    let indices: [UInt16]

    init(_ parent: ContentView) {
        self.parent = parent
        if let metalDevice = MTLCreateSystemDefaultDevice() {
            self.metalDevice = metalDevice
        }
        self.metalCommandQueue = metalDevice.makeCommandQueue()

        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        let library = metalDevice.makeDefaultLibrary()
        pipelineDescriptor.vertexFunction = library?.makeFunction(name: "vertex_shader")
        pipelineDescriptor.fragmentFunction = library?.makeFunction(name: "fragment_shader")
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        do {
            try pipelineState = metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError()
        }

//        before i had the indexbuffer
//        let vertices: [Float] = [
//            0, 1, 0,
//            -1, -1, 0,
//            1, -1, 0,
//            -1, 1, 1,
//            1, 1, 1,
//            -1, -1, 1,
//            1, -1, 1,
//        ]
        let vertices: [Float] = [
            -1, 1, 0,
            1, 1, 0,
            -1, -1, 0,
            1, -1, 0,
            0, 1, 0,
        ]

        indices = [
            0, 1, 2, // left half of triangle strip
            1, 2, 3, // right half of triangle strip
            2, 3, 4, // middle triangle
        ]
        
        self.vertexBuffer = metalDevice.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Float>.stride, options: [])!
        self.indexBuffer = metalDevice.makeBuffer(bytes: indices, length: indices.count * MemoryLayout<UInt16>.stride, options: [])!
        super.init()
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {

    }

    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable else {
            return
        }

        let commandBuffer = metalCommandQueue.makeCommandBuffer()

        let renderPassDescriptor = view.currentRenderPassDescriptor

        var constants = Constants()
        constants.moveBy = 0.5

        // this will be the background color
        renderPassDescriptor?.colorAttachments[0].clearColor = MTLClearColorMake(0, 0, 0, 1.0)
        renderPassDescriptor?.colorAttachments[0].loadAction = .clear
        renderPassDescriptor?.colorAttachments[0].storeAction = .store

        let  commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor!)

        commandEncoder?.setRenderPipelineState(pipelineState)
        commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder?.setVertexBytes(&constants, length: MemoryLayout<Constants>.stride, index: 1)

//        with indices, this...
//         commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
//         commandEncoder?.drawPrimitives(type: .triangleStrip, vertexStart: 3, vertexCount: 4)
//        becomes this:

        commandEncoder?.drawIndexedPrimitives(type: .triangle, indexCount: indices.count, indexType: .uint16, indexBuffer: indexBuffer, indexBufferOffset: 0)
        
        commandEncoder?.endEncoding()

        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
