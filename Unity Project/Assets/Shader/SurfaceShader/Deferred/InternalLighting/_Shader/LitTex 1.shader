// Upgrade NOTE: commented out 'float4x4 _CameraToWorld', a built-in variable
// Upgrade NOTE: replaced '_CameraToWorld' with 'unity_CameraToWorld'
// Upgrade NOTE: replaced '_LightMatrix0' with 'unity_WorldToLight'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: commented out 'float4 unity_ShadowFadeCenterAndType', a built-in variable

Shader "Tut/SurfaceShader/Deferred/LitTex1" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
	
	Pass {
		Name "PREPASS"
		Tags { "LightMode" = "Always" }
		ZWrite Off
		CGPROGRAM

		#pragma vertex vert_surf
		#pragma fragment frag_surf
		#pragma fragmentoption ARB_precision_hint_fastest

		#include "UnityCG.cginc"
		#include "Lighting.cginc"

		#define INTERNAL_DATA
		#define WorldReflectionVector(data,normal) data.worldRefl
		#define WorldNormalVector(data,normal) normal
		sampler2D _MainTex;
		struct Input {
			float2 uv_MainTex;
		};
		struct v2f_surf {
		  float4 pos : SV_POSITION;
		  float2 uvTex:TEXCOORD0;
		  float4 uv:TEXCOORD1;
		  float3 ray : TEXCOORD2;
		};
		float4 _MainTex_ST;
		v2f_surf vert_surf (appdata_full v) {
			v2f_surf o;
			o.pos = UnityObjectToClipPos (v.vertex);
			o.uvTex =v.texcoord.xy;
			o.uv=ComputeScreenPos(o.pos);
			o.ray= mul (UNITY_MATRIX_MV, v.vertex).xyz * float3(-1,-1,1);
			o.ray = lerp(o.ray, v.normal, v.normal.z != 0);
			return o;
		}
		sampler2D _CameraNormalsTexture;
		sampler2D _CameraDepthTexture;
		float4 _LightDir;
		float4 _LightPos;
		float4 _LightColor;
		//float4 _LightShadowData;
		float4 unity_LightmapFade;
		// float4 unity_ShadowFadeCenterAndType;
		// float4x4 _CameraToWorld;
		float4x4 unity_WorldToLight;
		sampler2D _LightTextureB0;

		#if defined (POINT_COOKIE)
		samplerCUBE _LightTexture0;
		#else
		sampler2D _LightTexture0;
		#endif
		fixed4 frag_surf (v2f_surf IN) : COLOR {
			float4 atten=1;
			IN.ray =IN.ray * (_ProjectionParams.z / IN.ray.z);
			float2 uv = IN.uv.xy / IN.uv.w;
	
			float depth = UNITY_SAMPLE_DEPTH(tex2D (_CameraDepthTexture, uv));
			depth = Linear01Depth (depth);
			float4 vpos = float4(IN.ray * depth,1);
			float3 wpos = mul (unity_CameraToWorld, vpos).xyz;
			#if defined (POINT_COOKIE)
			atten = texCUBE(_LightTexture0, mul(unity_WorldToLight, half4(IN.wpos,1)).xyz).w;
			atten=float4(1,0,0,1);
			#else
			atten=tex2D(_LightTexture0,IN.uvTex).r;
			#endif //POINT_COOKIE

			return atten;
			}
		ENDCG
		}//end prepass final
	} 
	FallBack Off
}
