// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Effects/ConeTap_0x" {
Properties {
	_MainTex ("", 2D) = "white" {}
}
Subshader {
ZTest Always Cull Off ZWrite Off Fog { Mode Off }
Pass {
CGPROGRAM
	#pragma vertex vert
	#pragma fragment frag
	#include "UnityCG.cginc"
	struct v2f {
		float4 pos : POSITION;
		float2 uv:TEXCOORD0;
	};
	v2f vert (appdata_img v)
	{
		v2f o;
		o.uv=v.texcoord;
		o.pos = UnityObjectToClipPos (v.vertex);
		return o;
	}
	sampler2D _MainTex;
	fixed4 frag( v2f i ) : COLOR
	{
		fixed4 c;
		c  = tex2D( _MainTex, i.uv);
		return c;
	}
ENDCG
}
}
Fallback off
}
