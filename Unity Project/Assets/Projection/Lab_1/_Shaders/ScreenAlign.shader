// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Project/ScreenAlign" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_imgWidth("image width",Float)=128
		_imgheight("image height",Float)=128
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		pass{
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"

		sampler2D _MainTex;
		float _imgWidth;
		float _imgHeight;

		struct vertOut {
			float4 oPos:SV_POSITION;
			float4 oTexc:TEXCOORD0;
			//float4 oPos:TEXCOORD1;
		};
		vertOut vert(appdata_base v)
		{
			vertOut o;
			float4 pos=UnityObjectToClipPos(v.vertex);
			float4 sr=float4(v.vertex.x,v.vertex.y,v.vertex.z,1.0);
			o.oPos=sr;
			o.oTexc=float4(0.5*(1.0+sr.x/sr.w)+(0.5/_imgWidth),0.5*(1.0+sr.y/sr.w)+(0.5/_imgHeight),0.5*(1.0+sr.z/sr.w),1.0);
			return o;
		}
		float4 frag(vertOut i):COLOR
		{
			float4 c=tex2Dproj(_MainTex,i.oTexc);
			return c;
		}
		ENDCG
		}//endpass
	} 
}
