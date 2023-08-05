//
//  Shaders.metal
//  wenderlickmetal
//
//  Created by Willis Plummer on 8/5/23.
//

#include <metal_stdlib>
using namespace metal;

#import "Definitions.h"

struct Fragment {
    float4 position [[position]];
    float4 color;
};

// set the points
// buffer 1 refers to the index passed when we did commandEncoder.setVertexBytes
vertex float4 vertex_shader(const device packed_float3 *vertices [[buffer(0)]],
                            constant Constants &constants [[buffer(1)]],
                            uint vertexId [[vertex_id]]) {
    float4 position = float4(vertices[vertexId], 1);
    position.x += constants.moveBy;
    return position;
}

// set the color to render the fragments within the shape to red
// a vector4 color is rgb / 255 so a 255 = 1, 0 = 0, and everything else is a float between
fragment half4 fragment_shader() {
//    return half4(1, 0, 0, 1);
    return half4(1, 1, 0, 1);
}
