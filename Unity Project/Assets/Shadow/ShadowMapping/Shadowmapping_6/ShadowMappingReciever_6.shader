Shader "Tut/Shadow/ShadowMapping/ShadowMappingReciever_6" {
	Properties{
	_MainTex("MainTex",2D)="white"{}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		pass{
		//Zwrite off
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
			float2 shadowTexc=0.5*i.litPos.xy/i.litPos.w+float2(0.5,0.5);
			float litZ=i.litPos.z/i.litPos.w;
			float4 c=tex2D(_myShadow,shadowTexc);
			float t=DecodeFloatRGBA(c);
			//return Linear01Depth(t);
			if(litZ>t)
			return 0.3;
			else
			return 0.7;
		}
		ENDCG
		}//endpass
	} 
	//FallBack "Diffuse"
}
