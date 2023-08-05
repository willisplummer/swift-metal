//
//  Shaders.metal
//  wenderlickmetal
//
//  Created by Willis Plummer on 8/5/23.
//

#include <metal_stdlib>
using namespace metal;

#import "Definitions.h"
#include <simd/simd.h>

struct Fragment {
    float4 position [[position]];
    float4 color;
};

// set the position
vertex Fragment vertex_shader(const device Vertex vertexIn [[stage_in]]) {
    Fragment fragment;
    fragment.position = vertexIn.position;
    fragment.color = vertexIn.color;
    return fragment;
}

// set the color to render the fragments within the shape to red
// a vector4 color is rgb / 255 so a 255 = 1, 0 = 0, and everything else is a float between
fragment half4 fragment_shader(VertexOut vertexIn [[ stage_in ]]) {
    return half4(vertexIn.color);
}
