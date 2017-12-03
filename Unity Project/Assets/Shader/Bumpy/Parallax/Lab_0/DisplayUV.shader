// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shader/Bumpy/DisplayUV" {
	Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		pass{
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"

		sampler2D _MainTex;
		float4 _MainTex_ST;
		struct v2f {
			float4 pos:SV_POSITION;
			float2 uv:TEXCOORD0;
		};

		v2f vert (appdata_full v) {
			v2f o;
			o.pos=UnityObjectToClipPos(v.vertex);
			o.uv=TRANSFORM_TEX(v.texcoord,_MainTex);
			return o;
		}
		float4 frag(v2f i):COLOR
		{
			float4 c=1;
			c=i.uv.y;
			return c;
		}
		ENDCG
		}
	} 
	FallBack "Diffuse"
}
