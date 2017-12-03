// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/ImageEffects/ccCurvesSimple_0" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "" {}
		_rTex ("_rTex (RGB)", 2D) = "" {}
		_gTex ("_gTex (RGB)", 2D) = "" {}
		_bTex ("_bTex (RGB)", 2D) = "" {}
	}
Subshader {
 Pass {
	  ZTest Always Cull Off ZWrite Off
	  Fog { Mode off }      

	CGPROGRAM
	#pragma vertex vert
	#pragma fragment frag
	#pragma fragmentoption ARB_precision_hint_fastest
	#include "UnityCG.cginc"
	struct v2f {
		float4 pos : POSITION;
		half2 uv : TEXCOORD0;
	};
	sampler2D _MainTex;
	sampler2D _rTex;
	sampler2D _gTex;
	sampler2D _bTex;
	v2f vert( appdata_img v ) 
	{
		v2f o;
		o.pos = UnityObjectToClipPos(v.vertex);
		o.uv = v.texcoord.xy;
		return o;
	} 
	fixed4 frag(v2f i) : COLOR 
	{
		fixed4 color = tex2D(_MainTex, i.uv); 
		fixed3 red = tex2D(_rTex, half2(color.r, 0.5)).rgb;
		fixed3 green = tex2D(_gTex, half2(color.g, 0.5)).rgb;
		fixed3 blue = tex2D(_bTex, half2(color.b, 0.5)).rgb;

		color = fixed4(red+green+blue, color.a);
		return color;
	}
      ENDCG
  }
}
Fallback off
}