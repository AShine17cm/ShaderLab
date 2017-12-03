// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/NewBie/FourthShader" {
	Properties {
		_MyTexture ("Texture (RGB)", 2D) = "white" {}
		_MyColor("Color of Object",Color)=(1,1,1,1)
	}
	SubShader {
	Tags{"Queue"="Geometry" "RenderType"="Opaque" "IgnoreProjector"="True"}
	pass{
	CGPROGRAM
	#pragma vertex vert
	#pragma fragment frag
	#pragma target 2.0
	#include "UnityCG.cginc"

	sampler2D _MyTexture;
	float4 _MyColor;

	struct v2f{
		float4 pos:SV_POSITION;
	};
	v2f vert(appdata_full v)
	{
		v2f o;
		o.pos=UnityObjectToClipPos(v.vertex);
		return o;
	}
	float4 frag(v2f i):COLOR
	{
		return float4(1,1,1,1);
	}
	ENDCG
		}
	} 
	FallBack "Diffuse"
}
