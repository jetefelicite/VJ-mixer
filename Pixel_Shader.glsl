uniform vec3      iResolution;           // viewport resolution (in pixels)
uniform float     iTime;                 // shader playback time (in seconds)
uniform float negative;
uniform float zoom;
uniform float rectangles;
uniform float curves;

//uniform float     iTimeDelta;            // render time (in seconds)
//uniform float     iFrameRate;            // shader frame rate
//uniform int       iFrame;                // shader playback frame
//uniform float     iChannelTime[4];       // channel playback time (in seconds)
//uniform vec3      iChannelResolution[4]; // channel resolution (in pixels)
//uniform vec4      iMouse;                // mouse pixel coords. xy: current (if MLB down), zw: click
//uniform samplerXX iChannel0..3;          // input channel. XX = 2D/Cube
//uniform vec4      iDate;                 // (year, month, day, time in seconds)
//uniform float     iSampleRate;           // sound sample rate (i.e., 44100)


out vec4 fragColor;

vec2 fragCoord = vUV.st*iResolution.xy;
#define ITERATIONS 150
#define COLOR_REPEAT 0.6
#define MANDELBROT_SHADE 2072.
#define time iTime
#define HEX_DIST 1.
#define HAIR_DIST 21.
#define PI rectangles
#define _DotsSize 0.213
#define _DotsSmoothness 0.221

vec2 rot(vec2 p, vec2 pivot, float a)
{
    float s = sin(a);
    float c = cos(a);

    p -= pivot;
    p = vec2(p.x*c - p.y*s, p.x*s + p.y*c);
    p += pivot;

    return p;
}
float HexDist(vec2 p) {
    p = abs(p);

    float c = dot(p, normalize(vec2(1,1.73)));
    c = max(c, p.x);

    return c;
}
vec4 HexCoords(vec2 UV) 
{
    vec2 r = vec2(1, 1.73);
    vec2 h = r*.5;

    vec2 a = mod(UV, r)-h;
    vec2 b = mod(UV-h, r)-h;

    vec2 gv = dot(a, a) < dot(b,b) ? a : b;

    float x = atan(gv.x, gv.y);
    float y = .5-HexDist(gv);
    vec2 id = UV - gv;
    return vec4(x, y, id.x,id.y);
}
float TriangleDist(vec2 p, vec2 q )
{
    p.x = abs(p.x);
    vec2 a = p - q*clamp( dot(p,q)/dot(q,q), 0.0, 1.0 );
    vec2 b = p - q*vec2( clamp( p.x/q.x, 0.0, 1.0 ), 1.0 );
    float k = sign( q.y );
    float d = min(dot( a, a ),dot(b, b));
    float s = max( k*(p.x*q.y-p.y*q.x),k*(p.y-q.y)  );
    return sqrt(d)*sign(s);
}
vec3 iterate(vec2 UV , float distance_type)
{
    //cool shit: https://www.shadertoy.com/view/wdBfDK
    //UV = _MandelbrotArea.xy + (UV-0.5)*_MandelbrotArea.zw;
    //UV = rot(UV, _MandelbrotArea.xy, _MandelbrotAngle);

    vec3 col;

    float dots_dist = 1e20f;
    vec2 z = UV;
    // shape = z for regular mandelbrot set
    // a; 0       ; (GOLDEN-2); 0.285; 0.285; 0.45  ; -0.70176; -0.835 ; -0.8 ; -0.7269; -0.754
    // b; 1-GOLDEN; (GOLDEN-1); 0    ; 0.01 ; 0.1428; -0.3842 ; -0.2321; 0.156; 0.1889; -0.066
    //float[1] shapes;
    //float2 shapes[11] = {z, float2(0, 1-GOLDEN), float2(GOLDEN-2, GOLDEN-1), float2(0.285, 0.), float2(0.285, 0.01), float2(0.45, 0.1428), float2(-0.70176, -0.3842), float2(-0.835, -0.2321),
        //float2(-0.8, 0.156), float2(-0.7269, 0.1889), float2(-0.754, -0.066)};
    vec2 shape;
    shape = vec2(0.285, zoom);
    //shape = float2(_fractal_shape_a, _fractal_shape_b);
    //if(shape.x == 0 && shape.y == 0)
    //    shape = z;
    vec2 prev_z;
    vec2 z_dots;
    vec4 z_hc;
    float dist_from_mandelbrot = 1e20f;
    float r = 20.;

    vec2 hc2;
    int i = 0;
    for(i = 0; i<ITERATIONS; i++ )
    {
        prev_z = z;
        if(distance_type == HEX_DIST)
        {
            vec2 z2 = rot(z, vec2(0.), time*0.4);
            r = 1. + 10.*HexDist(0.5 + 2.*sin(cos(z2)*0.5)*cos(cos(z2*3.)));
        }
        if(distance_type == HAIR_DIST)
        {   
            //vec2 z1 = 13.*z/dot(z,z+0.1*sin(z));
            //z1 +=time;
            vec2 z2 = rot(z, vec2(0.), time*0.4);
            r = 10. + negative *TriangleDist(sin(cos(z2*PI + PI)*0.5 + 5.)*sin(cos(z2*PI)), vec2(100.,3.2));
            //float r2 = 5 + 15*TriangleDist(sin(cos(z2*PI+time*1)*0.5 + 5)*cos(cos(z2*PI)), float2(50,-0.6));
            //r = lerp(r,r2, 0.4 + 0.4*sin(time));
            //r = 5+TriangleDist(z*3, float2(_test1,_test2));
        }

        //r = HexCoords(0.5 + 0.25*sin(cos(z*2 + time)*0.1)*cos(cos(z*3) + 0.25*sin(cos(prev_z*2)) )).y*10;
        z = vec2(z.x * z.x - z.y * z.y, 2. * z.x * z.y) + shape;
        //float z_hash = N22(z);
        if(length(z) > r)
            //if(dot(z, prev_z) > r)
            break;
        //return 0.0;


        z_dots = z + rot(z,prev_z,time*0.2);
        z_dots = vec2(HexDist(z_dots));
        z_hc = HexCoords(z_dots);

        //z_dots = pMod2(z_dots,4);

        dots_dist = min( dots_dist, dot(z_dots,z_dots) );
        //dots_dist = min( dots_dist, dot(z_hc.x,z_hc.y) );
        dist_from_mandelbrot = min(dist_from_mandelbrot, dot(z,z));

        //hc2 = min(hc2, HexCoords(prev_z).xy);
    }

    if(i >= ITERATIONS)
        return vec3(0.);

    float fraciter = log2( log(length(z)) / log(r) );
    float j = float(i);
    //j -= fraciter;

    //float2 hc = HexCoords(dots_dist).xy;

    //col = smoothstep(0,dist, sin(hc.y*15)*cos(hc.y*15));
    //float dots_size = 1;
    //float dots_smoothness = 0.9;
    float dots = smoothstep(_DotsSize - _DotsSmoothness, _DotsSize, dots_dist);
    //dots = smoothstep(0.9, 1, dots_dist);
    dots = clamp(0.,1.,dots);

    //col = smoothstep(0,dist, );
    //float3 tex = tex2D(_MainTex, hc2);
    //col = tex;
    //col = dots;

    vec3 beat = vec3(time*0.4);//(_smooth_bass2 + _smooth_mid2 + _smooth_treb2)*0.001 + (_bass2 + _mid2 + _treb2)*0.003;
    // Color 1
    vec3 a1 = vec3(0.5, 0.5, 0.5);
    vec3 b1 = vec3(0.75, 0.55, 0.85);
    vec3 c1 = beat; // animate \ offset
    vec3 d1 = vec3(0.0, 0.1, 0.2);
    // Color 2
    vec3 a2 = vec3(0.5, 0.5, 0.5);
    vec3 b2 = vec3(0.75, 0.55, 0.85);
    vec3 c2 = vec3(1.0, 1.0, 0.5); // animate \ offset
    vec3 d2 = vec3(0.8, 0.9, 0.3);
    // Color 3 - blue to gray
    vec3 a3 = vec3(0.5, .5, 1.);
    vec3 b3 = vec3(0.5, 0.5, 0.);
    vec3 c3 = vec3(0., 0., 0.); // animate \ offset
    vec3 d3 = vec3(0., 0., 0.);
    // Color 4 - black and white
    vec3 a4 = vec3(1, 1, 1);
    vec3 b4 = vec3(1.0, 1.0, 1.0);
    vec3 c4 = vec3(1.0, 1.0, 1.0); // animate \ offset
    vec3 d4 = vec3(1.0, 1.0, 1.0);
    
    vec3 a5 = vec3(0.3, 0.27, 0.5);
    vec3 b5 = vec3(0.9, 0.45, 0.75);
    vec3 c5 = vec3(beat); // animate \ offset
    vec3 d5 = vec3(.8, 0.9, 0.25);
    
    // Color choise
    //vec3 a = mix(a1, a2, 0.*time*0.02);
    //vec3 b = mix(b1, b2, 0.*time*0.02);
    //vec3 c = mix(c1, c2, 0.*time*0.02);
    //vec3 d = mix(d1, d2, 0.*time*0.02);

    vec3 col1 = a1 + b1 * cos(2.*PI*(sqrt(j) * COLOR_REPEAT + d1 + c1));
    vec3 col2 = a2 + b2 * cos(2.*PI*(sqrt(j) * COLOR_REPEAT + d2 + time*0.2));
    vec3 col3 = a3 + b3 * cos(2.*PI*(sqrt(j) * COLOR_REPEAT + d3 + c3 ));
    vec3 col4 = a4 + b4 * cos(2.*PI*(sqrt(j) * COLOR_REPEAT + d4 + c4));
    vec3 col5 = a5 + b5 * cos(2.*PI*(sqrt(j) * COLOR_REPEAT + d5 + c5));
	vec3 col6 = mix(col1, col5, abs(col1-col5));
    col = col1;
    
    
    //col = mix(col1, col4, 0.5 + 0.5*sin(float(i)));
    //col = vec3(clamp(0.,1.,fraciter));
    //col = mix(col, col2, fraciter);
    //col = col2;
    //col = vec3(dist_from_mandelbrot);

    dist_from_mandelbrot = smoothstep(0., j/(MANDELBROT_SHADE), dist_from_mandelbrot);
    //dist_from_mandelbrot = smoothstep(0, (_MandelbrotArea.z)*0.1, dist_from_mandelbrot); // shade depends on the zoom 

    dist_from_mandelbrot = clamp(0.,1.,dist_from_mandelbrot);

    if(distance_type == HEX_DIST)
    {
        float leaves = smoothstep(0.,0.7,fraciter);
        float leaves_edges = smoothstep(0.3,0.,fraciter);
        //float leaves_edges_tips = smoothstep(-0.02,0.03,fraciter);
        //leaves_edges *= leaves_edges_tips;
        col *= leaves;
        //col += leaves_edges;
        //col *= dist_from_mandelbrot;

    }
    if(distance_type == HAIR_DIST)
    {
        float hair = smoothstep(0.,1.5,fraciter);
        float hair_edges = smoothstep(0.18,0.,fraciter);
        float hair_edges_tips = smoothstep(-0.02,0.03,fraciter);
        //hair_edges *= hair_edges_tips; // to avoid pxieli edges of the hairs
        col *= hair;
        //col += hair_edges;

        // add dots
        //col *= (dist_from_mandelbrot);

        //float id = j;
        //float hash = N11(id + floor(-time*2));
        //col += 0.1*(1-dist_from_mandelbrot) * (col3);
        //col = col3;
    }



    //col = hash+0.1;


    //col *= hair_edges2*dist_from_mandelbrot;
    //col = col4;
    //col = fraciter;

    //col *= dots;
    //col += (1-dots)*dist_from_mandelbrot*col3;
    //col *= smoothstep(0.8,0.,fraciter);
    //col = dots;
    //col = fraciter;
    //col = 1-dots;

    return col;
}
void main()
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv;// = fragCoord/iResolution.xy;
    
    float zoom = curves;

    //uv += 0.4;
    //uv = 0.7*uv/dot(uv,uv);
    //uv += vec2(cos(0.1*iTime), sin(0.1*iTime));

    #if 1
    int AA = 2;
    vec3 col = vec3(0.);
    // anti-aliasing from https://www.shadertoy.com/view/Mss3R8
	for( int j=0; j<AA; j++ )
	for( int i=0; i<AA; i++ )
	{
		vec2 of = -0.5 + vec2( float(i), float(j) )/float(AA);

        uv = (fragCoord+of)/iResolution.xy;
        uv*=zoom;
        uv.x-= zoom/2.;
        uv.y -= zoom/2.;
	   col += iterate( uv, HAIR_DIST );
	}
	col /= float(AA*AA);
    
    #else
    
    uv = fragCoord/iResolution.xy;
    uv*=zoom;
    uv.x-= zoom/2.;
    uv.y -= zoom/2.;
	vec3 col = iterate(uv, HAIR_DIST);
    
    #endif
    

    fragColor = vec4(col,1.0);
}