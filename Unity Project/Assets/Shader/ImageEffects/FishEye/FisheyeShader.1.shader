// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Effects/FisheyeShader.1" {
Properties {
	_MainTex ("Base (RGB)", 2D) = "" {}
	_Intensity("Warp Intensity",vector)=(0,0,0,0)
}
Subshader {
 Pass {
	ZTest Always Cull Off ZWrite Off
	Fog { Mode off }      
	CGPROGRAM
	#pragma vertex vert
	#pragma fragment frag
	#include "UnityCG.cginc"
	struct v2f {
		float4 pos : POSITION;
		float2 uv : TEXCOORD0;
	};
	v2f vert( appdata_img v ) 
	{
		v2f o;
		o.pos = UnityObjectToClipPos(v.vertex);
		o.uv = v.texcoord.xy;
		return o;
	} 
	sampler2D _MainTex;
	float4 _Intensity;
	half4 frag(v2f i) : COLOR 
	{
		half2 coords = i.uv;
		coords = (coords - 0.5) * 2.0;		
		float2 intensity=_Intensity.xy;
		half2 realCoordOffs;
		realCoordOffs.x = (1-coords.y * coords.y) * intensity.y * (coords.x); 
		realCoordOffs.y = (1-coords.x * coords.x) * intensity.x * (coords.y);
		half4 color = tex2D (_MainTex, i.uv - realCoordOffs);	 
		return color;
	}
      ENDCG
  }
}
Fallback off
} // shader