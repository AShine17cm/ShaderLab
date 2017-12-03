// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Effects/BlitRegion" {
	Properties {
		_OriTex("Ori Texture",2D)="white"{}
		_MainTex("Main Texture",2D)="white"{}
		_MaskTex("Mask",2D)="white"{}
	}
Subshader {
 Pass {
	ZTest Always Cull Off ZWrite Off
	Fog { Mode off }      
	CGPROGRAM
	#pragma fragmentoption ARB_precision_hint_fastest 
	#pragma vertex vert
	#pragma fragment frag
	#include "UnityCG.cginc"
	struct v2f {
		float4 pos : POSITION;
		float2 uv : TEXCOORD0;
	};
	sampler2D _MainTex;
	sampler2D _OriTex;
	sampler2D _MaskTex;
	v2f vert( appdata_img v ) 
	{
		v2f o;
		o.pos = UnityObjectToClipPos(v.vertex);
		o.uv = v.texcoord.xy;
		return o;
	} 
	half4 frag(v2f i) : COLOR 
	{
		half mask=tex2D(_MaskTex,i.uv).r;
		return lerp(tex2D(_OriTex,i.uv),tex2D(_MainTex,i.uv),mask);
	}
      ENDCG
  }
}
Fallback off
} // shader