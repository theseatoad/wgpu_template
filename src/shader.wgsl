// Vertex shader

struct VertexInput {
    @location(0) position: vec3<f32>,
};

struct TickUniform {
   @align(16) tick : u32
}

struct ResolutionUniform {
    @align(16) resolution: vec4<f32>,
}

@group(0) @binding(0)
var<uniform> tick : TickUniform;

@group(1) @binding(0)
var<uniform> resolution : ResolutionUniform;

struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
    @location(0) position: vec2<f32>,
};

@vertex
fn vs_main(
    model: VertexInput,
) -> VertexOutput {
    var out: VertexOutput;
    out.position = vec2<f32>(model.position.x, model.position.y);
    out.clip_position = vec4<f32>(model.position, 1.0);
    return out;
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    var uv : vec2<f32>= in.position;
    var time = f32(tick.tick) / 40.0;
    // aspect ratio
    uv.x *= resolution.resolution.x / resolution.resolution.y;
    var uv0 : vec2<f32> = uv;
    var finalColor : vec3<f32> = vec3<f32>(0.0,0.0,0.0);
    for ( var i :f32 = 0.0; i < 4.0; i+= 1.0){
        // repeat multi
        uv = fract(uv * 1.5) - 0.5;
        // circle
        var d : f32 = length(uv) * exp(-length(uv0));

        // custom color from pallete, values from dev.thi.ng/gradients/
        var color : vec3<f32> = palette(length(uv0)+ time/2.0 + i*0.25, vec3<f32>(0.66,0.56,0.668),vec3<f32>(0.718,0.438,0.72),vec3<f32>(0.52,0.8,0.52),vec3<f32>(-.43,-0.397,-0.083));

        // time animation + multiple circles
        d = sin(d*8.0 + time)/8.0;

        // wrapping negs
        d = abs(d);
        // Sharp neon look
        d = pow(0.01/d, 1.2);

        // apply color
        finalColor += color * d;
    }
    return vec4<f32>(finalColor,1.0);
}

// from Iquilezlies.org/articles/palettes + kishimisu an introduction to shader art coding
fn palette(t : f32, a : vec3<f32>, b : vec3<f32>, c: vec3<f32>, d: vec3<f32>) -> vec3<f32>{
    return a + b*cos(6.28318*(c*t+d));
}