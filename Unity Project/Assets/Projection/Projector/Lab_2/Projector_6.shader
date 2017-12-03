// Upgrade NOTE: replaced '_Projector' with 'unity_Projector'
// Upgrade NOTE: replaced '_ProjectorClip' with 'unity_ProjectorClip'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Project/Projector_6" {
  Properties {
     _MainTex ("Cookie", 2D) = "" { TexGen ObjectLinear }
	 _FalloffTex("Falloff Tex",2D)="white"{TexGen ObjectLinear }
  }
  Subshader {
     pass {
        ZWrite off
		//Cull front
        //Blend DstColor One
		Offset -1, -1
       CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		sampler2D _MainTex;
		sampler2D _FalloffTex;
		float4x4 unity_Projector;
		float4x4 unity_ProjectorClip;
		struct v2f {
			float4 pos:SV_POSITION;
			float4 texc:TEXCOORD0;
			float4 texc2:TEXCOORD1;
		};
		v2f vert(appdata_base v)
		{
			v2f o;
			o.pos=UnityObjectToClipPos(v.vertex);
			o.texc=mul(unity_Projector,v.vertex);
			o.texc2=mul(unity_ProjectorClip,v.vertex);
			return o;
		}
		float4 frag(v2f i):COLOR
		{
			float4 c=tex2D(_MainTex,i.texc.xy/i.texc.w);
			float c2=tex2D(_FalloffTex,i.texc2.xy/i.texc.w).a;
			return c*c2;
		}
		ENDCG
	}//endpass
  }
}
