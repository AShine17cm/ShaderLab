// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Self-Illumin/Lighting/LightMapping/Lab_1/EmissionLM" {
    Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
        _Color ("Illumi Color", Color) = (1,1,1,1) 
        _EmissionLM ("Emission (Lightmapper)", Float) = 1
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 200
        
       pass{
		Tags{ "LightMode"="Vertex"}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		#include "Lighting.cginc"

		uniform float4 _Color;
		float4 _Illumi;
		struct vertOut{
			float4 pos:SV_POSITION;
			float4 color:COLOR;
		};
		vertOut vert(appdata_base v)
		{
			
			float3 c=ShadeVertexLights(v.vertex,v.normal);
			vertOut o;
			o.pos=UnityObjectToClipPos(v.vertex);
			o.color=_Color*float4(c,1);
			return o;
		}
		float4 frag(vertOut i):COLOR
		{
			return i.color+_Color;
		}
		ENDCG
		}//end pass
    } 
    
}