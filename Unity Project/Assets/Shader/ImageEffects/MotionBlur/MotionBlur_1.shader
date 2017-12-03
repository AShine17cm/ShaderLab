// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Effects/MotionBlur_1" {
Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}
	_AccumTex("Accum Tex",2D)="white"{}
	_AccumAmt("AccumOrig", Float) = 0.65
}
SubShader { 
	ZTest Always Cull Off ZWrite Off
	Fog { Mode off }
	Pass {
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		struct v2f {
			float4 vertex : POSITION;
			float2 uv : TEXCOORD;
		};
		v2f vert (appdata_base v)
		{
			v2f o;
			o.vertex = UnityObjectToClipPos(v.vertex);
			o.uv =v.texcoord;
			return o;
		}
		sampler2D _MainTex;
		sampler2D _AccumTex;
		float _AccumAmt;
		half4 frag (v2f i) : COLOR
		{
			half4 acc=tex2D(_AccumTex,i.uv);
			half4 current=tex2D(_MainTex, i.uv);
			acc=acc*_AccumAmt+current*(1.0-_AccumAmt);
			return acc;
		}
		ENDCG 
	} 
}
Fallback off
}