// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shader/FixedFuncs/CombineCg" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Extr("Extrude",range(0,1))=0
	}
		CGINCLUDE
		#pragma exclude_renderers gles
		#pragma only_renderers d3d9
		#pragma vertex vert
		float _Extr;
		float4 vert(float4 v:POSITION,float3 n:NORMAL):SV_POSITION
		{
			v.xyz+=n*_Extr;
			float4 pos=UnityObjectToClipPos(v);
			return pos;
		}
		ENDCG
	SubShader {
		pass{
			CGPROGRAM
			ENDCG
			Lighting on
			SetTexture[_MainTex]{
			combine texture
			}
		}
	} 
}
