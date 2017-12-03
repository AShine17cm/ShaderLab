// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shadow/ShadowMapping/ShadowMappingReciever_7" {
	Properties{
	_MainTex("MainTex",2D)="white"{}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		pass{
		Zwrite on
		ZTest Less
		//ZTest Always
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		
		sampler2D _myShadow;
		float4x4 _litMVP;
		
		struct vertOut {
			float4 pos:SV_POSITION;
			float4 litPos:TEXCOORD0;
		};
		vertOut vert(appdata_base v)
		{
			vertOut o;
			o.pos=UnityObjectToClipPos(v.vertex);
			float4 wVertex=mul(unity_ObjectToWorld ,v.vertex);
			o.litPos=mul(_litMVP,wVertex);
			return o;
		}
		float4 frag(vertOut i):COLOR
		{
			float2 shc=0.5*i.litPos.xy/i.litPos.w+float2(0.5,0.5);
			//float oZ=i.litPos.z/i.litPos.w-_ZBufferParams.w/i.litPos.w*4;
			float oZ=i.litPos.z/i.litPos.w-4/i.litPos.w;
			float4 c=tex2D(_myShadow,shc);
			float sZ=DecodeFloatRGBA(c);
			float r=0;
			if(oZ<=sZ)
			r=0.8;
			else
			r=0.5;
			return r;
			//return Linear01Depth(r);
		}
		ENDCG
		}//endpass
	} 
	//FallBack "Diffuse"
}
