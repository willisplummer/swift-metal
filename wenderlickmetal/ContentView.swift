//
//  ContentView.swift
//  wenderlickmetal
//
//  Created by Willis Plummer on 8/5/23.
//

import SwiftUI
import MetalKit

struct ContentView: UIViewRepresentable {
//    typealias UIViewType = UIView
    
    func makeCoordinator() -> Renderer {
        Renderer(self)
    }

    func makeUIView(context: UIViewRepresentableContext<ContentView>) -> UIView {
        let mtkView = MTKView()
        mtkView.delegate = context.coordinator
        mtkView.preferredFramesPerSecond = 60
        mtkView.enableSetNeedsDisplay = false
        
        if let metalDevice = MTLCreateSystemDefaultDevice() {
            mtkView.device = metalDevice
        }
        
        mtkView.framebufferOnly = false
        mtkView.drawableSize = mtkView.frame.size
        
        return mtkView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
