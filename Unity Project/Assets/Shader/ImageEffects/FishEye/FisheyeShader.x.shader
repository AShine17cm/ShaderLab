// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Effects/FisheyeShader.x" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "" {}
		_Intensity("Warp Intensity",vector)=(0,0,0,0)
		_Region("Warp Region",vector)=(0,1,0,1)
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
	float4 _Intensity;
	float4 _Region;
	v2f vert( appdata_img v ) 
	{
		v2f o;
		o.pos = UnityObjectToClipPos(v.vertex);
		o.uv = v.texcoord.xy;
		return o;
	} 
	half4 frag(v2f i) : COLOR 
	{
		half2 coords = i.uv;
		coords = (coords - 0.5) * 2.0;		
		float2 intensity=_Intensity.xy;
		half2 realCoordOffs;
		realCoordOffs.x = (1-coords.y * coords.y) * intensity.y * (coords.x); 
		realCoordOffs.y = (1-coords.x * coords.x) * intensity.x * (coords.y);

		float zer1=(i.uv.x-_Region.x)*(_Region.y-i.uv.x)>0?1:0;
		float zer2=(i.uv.y-_Region.z)*(_Region.w-i.uv.y)>0?1:0;

		half4 color = tex2D (_MainTex, i.uv - realCoordOffs*zer1*zer2);	 
		return color;
	}
      ENDCG
  }
}
Fallback off
} // shader