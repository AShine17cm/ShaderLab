Shader "Unlit/Receiver" {
    Properties {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader {
        Tags { "RenderType"="Opaque" "DisableBatching"="false" "IgnoreProjector"="True"}
        LOD 200
    Pass {
        Name "FORWARD"
        Tags { "LightMode" = "ForwardBase" }

CGPROGRAM
// compile directives
#pragma vertex vert_surf
#pragma fragment frag_surf
#pragma target 3.0
#pragma multi_compile_fog
#pragma multi_compile_fwdbase
#include "HLSLSupport.cginc"
#include "UnityShaderVariables.cginc"
#include "UnityShaderUtilities.cginc"

//#define UNITY_PASS_FORWARDBASE
#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "UnityPBSLighting.cginc"
#include "AutoLight.cginc"

#define INTERNAL_DATA
#define WorldReflectionVector(data,normal) data.worldRefl
#define WorldNormalVector(data,normal) normal

sampler2D _MainTex;
struct Input {
    float2 uv_MainTex;
};
// vertex-to-fragment interpolation data
// no lightmaps:
struct v2f_surf {
  float4 pos : SV_POSITION;
  float2 pack0 : TEXCOORD0; // _MainTex
  half3 worldNormal : TEXCOORD1;
  float3 worldPos : TEXCOORD2;
  #if UNITY_SHOULD_SAMPLE_SH
  half3 sh : TEXCOORD3; // SH
  #endif
  UNITY_SHADOW_COORDS(4)
  UNITY_FOG_COORDS(5)
  //UNITY_VERTEX_INPUT_INSTANCE_ID
  //UNITY_VERTEX_OUTPUT_STEREO
};
float4 _MainTex_ST;

// vertex shader
v2f_surf vert_surf (appdata_full v) {
  //UNITY_SETUP_INSTANCE_ID(v);
  v2f_surf o;
  UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
  //UNITY_TRANSFER_INSTANCE_ID(v,o);
  //UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
  o.pos = UnityObjectToClipPos(v.vertex);
  o.pack0.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
  float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
  fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
  o.worldPos = worldPos;
  o.worldNormal = worldNormal;

  // SH/ambient and vertex lights
   #if UNITY_SHOULD_SAMPLE_SH
      o.sh = ShadeSHPerVertex (worldNormal, o.sh);
    #endif

  UNITY_TRANSFER_SHADOW(o,v.texcoord1.xy); // pass shadow coordinates to pixel shader
  UNITY_TRANSFER_FOG(o,o.pos); // pass fog coordinates to pixel shader
  return o;
}

// fragment shader
fixed4 frag_surf (v2f_surf IN) : SV_Target {
  float3 worldPos = IN.worldPos;
  fixed3 lightDir = _WorldSpaceLightPos0.xyz;

  half3 Albedo = tex2D(_MainTex,IN.pack0.xy).rgb;
  half3 Normal = IN.worldNormal;

    fixed atten = UNITY_SHADOW_ATTENUATION(IN, worldPos);
    half3 litColor=atten;// _LightColor0.rgb;
    //half3 sh = ShadeSHPerPixel (Normal, giInput.ambient, giInput.worldPos);
    Normal = normalize(Normal);

    half outputAlpha;
    half nl = saturate(dot(Normal, lightDir));
    //litColor=litColor* nl;
    //litColor=max(0.2,litColor);
    half4 c4=half4(litColor*Albedo,1);
    c4.a = outputAlpha;
  UNITY_APPLY_FOG(IN.fogCoord, c4); // apply fog
  //UNITY_OPAQUE_ALPHA(c4.a);
  return c4;
}

ENDCG
}

    }
    FallBack "Diffuse"
}
