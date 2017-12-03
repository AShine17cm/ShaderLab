// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shadow/ShadowMapping/ShadowMappingReciever_3" {

	SubShader {
		Tags { "RenderType"="Opaque" }
		pass{
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		sampler2D _myShadow;
		float4x4 _myShadowProj;

		struct vertOut {
			float4 pos:SV_POSITION;
			float4 texc:TEXCOORD0;
		};
		vertOut vert(appdata_base v)
		{
			float4x4 proj;
			proj=mul(_myShadowProj,unity_ObjectToWorld);
			vertOut o;
			o.pos=UnityObjectToClipPos(v.vertex);
			o.texc=mul(proj,v.vertex);
			return o;
		}
		float4 frag(vertOut i):COLOR
		{
			float4 c=tex2Dproj(_myShadow,i.texc);
			return c;
		}
		ENDCG
		}//endpass
	} 
	FallBack Off
}
