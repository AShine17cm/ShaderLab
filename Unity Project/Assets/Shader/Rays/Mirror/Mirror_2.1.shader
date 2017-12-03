// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Rays/Mirror_2.1" {
	Properties {
		_RefTex ("Reflection Tex", 2D) = "white" {}
	}
	SubShader {
		pass{
		Tags {"LightMode"="Always"}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		sampler2D _RefTex;
		float4x4 _ProjMat;
		struct v2f {
			float4 pos:SV_POSITION;
			float4 texc:TEXCOORD0;
		};
		v2f vert(appdata_base v)
		{
			float4x4 proj;
			proj=mul(_ProjMat,unity_ObjectToWorld);
			v2f o;
			o.pos=UnityObjectToClipPos(v.vertex);
			o.texc=mul(proj,v.vertex);
			o.texc.y=o.texc.y;
			return o;
		}
		float4 frag(v2f i):COLOR
		{
			float4 c=tex2Dproj(_RefTex,i.texc);
			return c;
		}
		ENDCG
		}//endpass
	} 
}
