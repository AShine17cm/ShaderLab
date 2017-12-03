// Upgrade NOTE: replaced '_Projector' with 'unity_Projector'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Project/Projector_3" {
  Properties {
     _MainTex ("Cookie", 2D) = "" { }
  }
  Subshader {
     pass {
        ZWrite off
       // Blend DstColor One
		Offset -1, -1
       CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		sampler2D _MainTex;
		float4x4 unity_Projector;
		struct vertOut {
			float4 pos:SV_POSITION;
			float4 texc:TEXCOORD0;
		};
		vertOut vert(appdata_base v)
		{
			vertOut o;
			o.pos=UnityObjectToClipPos(v.vertex);
			o.texc=mul(unity_Projector,v.vertex);
			return o;
		}
		float4 frag(vertOut i):COLOR
		{
			float4 c=tex2Dproj(_MainTex,i.texc);
			return c*step(0,i.texc.w);
		}
		ENDCG
	}//endpass
  }
}
