// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Effects/RectRegion" {
	Properties {
		_OriTex("Ori Texture",2D)="white"{}
		_MainTex("Main Texture",2D)="white"{}
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
	sampler2D _OriTex;
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
		float zer1=(i.uv.x-_Region.x)*(_Region.y-i.uv.x)>0?1:0;
		float zer2=(i.uv.y-_Region.z)*(_Region.w-i.uv.y)>0?1:0;
		return zer1*zer2*tex2D(_MainTex,i.uv)+(1-zer1*zer2)*tex2D(_OriTex,i.uv);
	}
      ENDCG
  }
}
Fallback off
} // shader