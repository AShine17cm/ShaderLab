// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Effects/NoiseLit" {
Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}
	_GrainTex ("Base (RGB)", 2D) = "gray" {}
}
SubShader {
Pass {
	ZTest Always Cull Off ZWrite Off Fog { Mode off }
	CGPROGRAM
	#pragma vertex vert
	#pragma fragment frag
	#include "UnityCG.cginc"
	struct v2f { 
		float4 pos	: POSITION;
		float2 uv	: TEXCOORD0;
		float2 uvg	: TEXCOORD1;
	}; 
	uniform float4 _GrainOffsetScale;
	v2f vert (appdata_img v)
	{
		v2f o;
		o.pos = UnityObjectToClipPos (v.vertex);
		o.uv = MultiplyUV (UNITY_MATRIX_TEXTURE0, v.texcoord);
		o.uvg =o.uv * _GrainOffsetScale.xy;
		return o;
	}
	uniform sampler2D _MainTex;
	uniform sampler2D _GrainTex;
	sampler2D _LightBuffer;
	fixed4 frag (v2f i) : COLOR
	{
		fixed4 col = tex2D(_MainTex, i.uv);
		fixed4 lt=tex2D(_LightBuffer,i.uv);
		float d=length(lt.rgb);
		fixed4 grain = tex2D(_GrainTex, i.uvg) * 2 - 1;
		col=col+lerp(grain*_GrainOffsetScale.z,0,(d+1)*d/2);
		//return lt;
		return col;
	}
	ENDCG
		}
	}
Fallback off
}