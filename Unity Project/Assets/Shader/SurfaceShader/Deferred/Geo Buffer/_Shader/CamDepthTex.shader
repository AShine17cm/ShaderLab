// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/SurfaceShader/Deferred/CamDepthTex" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
	Pass {
	Name "PREPASS"
	Tags { "LightMode" = "Always" }
	Fog {Mode Off}
	CGPROGRAM
	#pragma vertex vert_surf
	#pragma fragment frag_surf
	#pragma fragmentoption ARB_precision_hint_fastest
	#include "UnityCG.cginc"
	#include "Lighting.cginc"

	#define INTERNAL_DATA
	#define WorldReflectionVector(data,normal) data.worldRefl
	#define WorldNormalVector(data,normal) normal
	sampler2D _CameraDepthTexture;
	struct v2f_surf {
		float4 pos : SV_POSITION;
		float2 uv : TEXCOORD0;
	};
	v2f_surf vert_surf (appdata_full v) {
		  v2f_surf o;
		  o.pos = UnityObjectToClipPos (v.vertex);
		  o.uv = v.texcoord;
		  return o;
	}
	fixed4 frag_surf (v2f_surf IN) : COLOR {
	float4 c=tex2D(_CameraDepthTexture,IN.uv);
	  return c;
	}
	ENDCG
	}//end prepass base
	}
	FallBack Off
}
