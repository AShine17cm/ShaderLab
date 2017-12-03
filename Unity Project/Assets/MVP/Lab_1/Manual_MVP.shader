Shader "Tut/Matrix/Manual_MVP" {
	SubShader {
		Tags { "RenderType"="Opaque" }
		pass{
		CGPROGRAM
		#pragma  vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		float4x4  Manual_MVP;
		float4 vert(float4 vpos:POSITION):SV_POSITION
		{
			float4 pos;
			pos=mul(Manual_MVP,vpos);
			return pos;
		}
		float4 frag():COLOR
		{
			float4 c;
			c=float4(1,1,1,1);
			return c;
		}
		ENDCG
		}//
	} 
}
