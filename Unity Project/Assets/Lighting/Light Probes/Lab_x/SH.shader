// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Lighting/LightProbes/SH" {
 Properties {
 _SHAr ("First Order Harmonic", Vector) = (0.0,0.0,0.0,0.0) 
_SHAg ("First Order Harmonic", Vector) = (0.0,0.0,0.0,0.0) 
_SHAb ("First Order Harmonic", Vector) = (0.0,0.0,0.0,0.0) 

_SHBr ("Second Order Harmonic", Vector) = (0.0,0.0,0.0,0.0) 
_SHBg ("Second Order Harmonic", Vector) = (0.0,0.0,0.0,0.0) 
_SHBb ("Second Order Harmonic", Vector) = (0.0,0.0,0.0,0.0) 

_SHC ("Third OrderHarmonic", Vector) = (0.0,0.0,0.0,0.0)
 _A ("Alpha", Float) = 0.5
 }

 SubShader {
 Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" } 
Blend SrcAlpha OneMinusSrcAlpha
 Cull Off 
Lighting Off 
ZWrite On
 
Pass{
 CGPROGRAM
 #pragma vertex vert
 #pragma fragment frag
 #pragma exclude_renderers
 #pragma target 2.0
 
#include "UnityCG.cginc"
 #include "Lighting.cginc"
 
uniform float4 _SHAr;
 uniform float4 _SHAg;
 uniform float4 _SHAb; 

uniform float4 _SHBr;
 uniform float4 _SHBg;
 uniform float4 _SHBb;

 uniform float4 _SHC;

 uniform float _A; 


struct appdata_t {
 float4 vertex : POSITION;
 fixed4 color : COLOR; 
float3 normal : TEXCOORD0;
 float4 tangent : TEXCOORD1;
 };

 struct v2f {
 float4 pos : SV_POSITION;
 fixed4 color : COLOR;
 };

 v2f vert (appdata_t v)
 {
 v2f o; 

UNITY_DIRBASIS; 

//This is the spherical harmonic lookup, it takes in the world normal and spits out the appropriate value in that direction
 //It comes from appendix 10 of Peter Pike Sloan's paper "Stupid Spherical Harmonic Tricks"
 //It's a bit more complex than the simpliest transform so it can be more efficient
 //http://www.ppsloan.org/publications/StupidSH36.pdf

 //It takes 12 coefficients (the numbers in the _SHA,_SHB and _SHC vectors) multiplies them against eachother to construct the harmonic
 //Each coefficient represents a cosine wave (which in turn are used to describe the sphere, axis by axis)
 //Each level _SHA - _SHB etc divides the sphere into two sub spheres, and each contains more detail (higher frequency data) about the final wave/sphere 

//It can be thought of as sound
 //Each seperate frequency is a different pitch, and the final sound is all these pieces blended together

 float4 wN = v.vertex; //Here I'm using the vertex position since this is for a sphere around the origin 
//It's very similar to a fourier transform, but across the surface of a sphere
 half3 x1, x2, x3;

 // Linear + constant polynomial terms
 x1.r = dot(_SHAr,wN);
 x1.g = dot(_SHAg,wN);
 x1.b = dot(_SHAb,wN);

 // 4 of the quadratic polynomials
 half4 vB = wN.xyzz * wN.yzzx;
 x2.r = dot(_SHBr,vB);
 x2.g = dot(_SHBg,vB);
 x2.b = dot(_SHBb,vB);

 // Final quadratic polynomial
 float vC = wN.x*wN.x - wN.y*wN.y;
 x3 = _SHC.rgb * vC;

 float3 shC = x1 + x2 + x3;

 //Setup the vertices 
o.pos = UnityObjectToClipPos(v.vertex);
 
//the vectors the rgba colors also work as xyzw in space (color is a space, afterall...)
 //i.e. positive and negative red translates verts left and right along the x axis 
//o.pos = mul(UNITY_MATRIX_MVP, float4(shC.rgb, 1.0f)); //Comment this in to see the shape of the spherical harmonic
 
//Set the out color 
//o.color = float4(mul(shC, unity_DirBasis), _A); //What was I doing with this?! :O
 o.color = float4(shC, _A);

 return o;
 }

 fixed4 frag (v2f i) : COLOR
 {
 float4 c = float4(1.0f,1.0f,1.0f,1.0f);
 return i.color;
 }
 ENDCG 
} 
}
 } 