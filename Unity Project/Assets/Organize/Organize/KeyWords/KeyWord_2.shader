// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Organize/KeyWords/KeyWord_2" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		pass{
		CGPROGRAM
		#define MY_Condition_2
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		struct vertOut{
			float4 pos:SV_POSITION;
		};
		vertOut vert(appdata_base v)
		{
			vertOut o;
			o.pos=UnityObjectToClipPos(v.vertex);
			return o;
		}
		float4 frag(vertOut i):COLOR
		{
			float4 c=float4(0,0,0,0);
			#ifdef MY_Condition_2
			c=float4(0,1,0,0);
			#endif
			return c;
		}
		ENDCG
		}//end pass
	} 
}
