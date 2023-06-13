// Vertex shader

struct VertexInput {
    @location(0) position: vec3<f32>,
};

struct TickUniform {
   @align(16) tick : u32
}

@group(0) @binding(0)
var<uniform> tick : TickUniform;

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
    var position : vec2<f32> = in.position;
    position.x = sin(f32(tick.tick) / 60.0);
    return vec4<f32>(position, 0.5, 1.0);
}