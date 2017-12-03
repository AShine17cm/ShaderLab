// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Organize/UsePass/MyPasses" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		pass{
		Name "RED"
		CGPROGRAM
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
			return float4(1,0,0,0);
		}
		ENDCG
		}//end pass
		pass{
		Name "GREEN"
		CGPROGRAM
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
			return float4(0,1,0,0);
		}
		ENDCG
		}//end pass
		pass{
		Name "BLUE"
		CGPROGRAM
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
			return float4(0,0,1,0);
		}
		ENDCG
		}//end pass
	} 
	FallBack "Diffuse"
}
