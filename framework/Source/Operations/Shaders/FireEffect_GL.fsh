precision highp float;

#define PI 3.14159265
#define WAVELENGTH 26.0
#define AMPLITUDE 0.0125
#define SPEED 3.0

varying vec2 textureCoordinate;
uniform sampler2D inputImageTexture;
uniform sampler2D inputImageTexture2;
uniform sampler2D inputImageTexture3;
uniform sampler2D inputImageTexture4;
uniform sampler2D inputImageTexture5;
uniform sampler2D inputImageTexture6;
uniform float intensity;

float time = 0.0;

const vec3 fire = vec3(0.9, 0.18, 0.0);

vec3 mod289(vec3 x)
{
    return x - floor(x *(1.0 / 289.0)) *289.0;
}
vec4 mod289(vec4 x)
{
    return x - floor(x *(1.0 / 289.0)) *289.0;
}
vec4 permute(vec4 x)
{
    return mod289(((x *34.0) + 1.0) *x);
}
vec4 taylorInvSqrt(vec4 r)
{
    return 1.79284291400159 - 0.85373472095314 * r;
}
vec3 fade(vec3 t)
{
    return t *t *t *(t *(t *6.0 - 15.0) + 10.0);
}
float noise(vec3 P)
{
    vec3 Pi0 = floor(P), Pi1 = Pi0 + vec3(1.0);
    Pi0 = mod289(Pi0);
    Pi1 = mod289(Pi1);
    vec3 Pf0 = fract(P), Pf1 = Pf0 - vec3(1.0);
    vec4 ix = vec4(Pi0.x, Pi1.x, Pi0.x, Pi1.x), iy = vec4(Pi0.yy, Pi1.yy), iz0 = Pi0.zzzz, iz1 = Pi1.zzzz, ixy = permute(permute(ix) + iy), ixy0 = permute(ixy + iz0), ixy1 = permute(ixy + iz1), gx0 = ixy0 *(1.0 / 7.0), gy0 = fract(floor(gx0) *(1.0 / 7.0)) - 0.5;
    gx0 = fract(gx0);
    vec4 gz0 = vec4(0.5) - abs(gx0) - abs(gy0), sz0 = step(gz0, vec4(0.0));
    gx0 -= sz0 *(step(0.0, gx0) - 0.5);
    gy0 -= sz0 *(step(0.0, gy0) - 0.5);
    vec4 gx1 = ixy1 *(1.0 / 7.0), gy1 = fract(floor(gx1) *(1.0 / 7.0)) - 0.5;
    gx1 = fract(gx1);
    vec4 gz1 = vec4(0.5) - abs(gx1) - abs(gy1), sz1 = step(gz1, vec4(0.0));
    gx1 -= sz1 *(step(0.0, gx1) - 0.5);
    gy1 -= sz1 *(step(0.0, gy1) - 0.5);
    vec3 g000 = vec3(gx0.x, gy0.x, gz0.x), g100 = vec3(gx0.y, gy0.y, gz0.y), g010 = vec3(gx0.z, gy0.z, gz0.z), g110 = vec3(gx0.w, gy0.w, gz0.w), g001 = vec3(gx1.x, gy1.x, gz1.x), g101 = vec3(gx1.y, gy1.y, gz1.y), g011 = vec3(gx1.z, gy1.z, gz1.z), g111 = vec3(gx1.w, gy1.w, gz1.w);
    vec4 norm0 = taylorInvSqrt(vec4(dot(g000, g000), dot(g010, g010), dot(g100, g100), dot(g110, g110)));
    g000 *= norm0.x;
    g010 *= norm0.y;
    g100 *= norm0.z;
    g110 *= norm0.w;
    vec4 norm1 = taylorInvSqrt(vec4(dot(g001, g001), dot(g011, g011), dot(g101, g101), dot(g111, g111)));
    g001 *= norm1.x;
    g011 *= norm1.y;
    g101 *= norm1.z;
    g111 *= norm1.w;
    float n000 = dot(g000, Pf0), n100 = dot(g100, vec3(Pf1.x, Pf0.yz)), n010 = dot(g010, vec3(Pf0.x, Pf1.y, Pf0.z)), n110 = dot(g110, vec3(Pf1.xy, Pf0.z)), n001 = dot(g001, vec3(Pf0.xy, Pf1.z)), n101 = dot(g101, vec3(Pf1.x, Pf0.y, Pf1.z)), n011 = dot(g011, vec3(Pf0.x, Pf1.yz)), n111 = dot(g111, Pf1);
    vec3 fade_xyz = fade(Pf0);
    vec4 n_z = mix(vec4(n000, n100, n010, n110), vec4(n001, n101, n011, n111), fade_xyz.z);
    vec2 n_yz = mix(n_z.xy, n_z.zw, fade_xyz.y);
    return mix(n_yz.x, n_yz.y, fade_xyz.x);
}
float diff(vec3 c1, vec3 c2)
{
    c1 = (c1 - c2);
    return clamp(c1.r + c1.g + c1.b, 0.2, 1.2) - 0.2;
}
void main()
{
    vec2 texCoord = textureCoordinate;
    vec2 p = texCoord + sin(vec2(noise(vec3(texCoord, time * SPEED) *WAVELENGTH) *PI *AMPLITUDE, noise(vec3(texCoord, (1.0 + time) * SPEED) *WAVELENGTH) *PI *AMPLITUDE));
    vec3 c0 = texture2D(inputImageTexture, p).rgb, c1 = texture2D(inputImageTexture6, p).rgb, c2 = texture2D(inputImageTexture6, p).rgb, c3 = texture2D(inputImageTexture5, p).rgb, c4 = texture2D(inputImageTexture4, p).rgb, c5 = texture2D(inputImageTexture3, p).rgb, c6 = texture2D(inputImageTexture2, p).rgb;
    float c = diff(c0, c1) *2.0;
    c += diff(c1, c2);
    c += diff(c2, c3);
    c += diff(c3, c4);
    c += diff(c4, c5) *0.5;
    c += diff(c5, c6) *0.125;
    
    vec3 fireEffect = fire;
    
    gl_FragColor = vec4(texture2D(inputImageTexture, texCoord).rgb * 0.7  + c * fireEffect * intensity, 1.0);
}

