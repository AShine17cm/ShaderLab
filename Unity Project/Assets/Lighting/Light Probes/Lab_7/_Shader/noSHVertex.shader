// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Lighting/LightProbes/Lab_7/noSHVertex" {
	Properties {
		_Color ("Base Color", Color) =(1,1,1,1)
	}
	SubShader {
		pass{
		Tags{ "LightMode"="Vertex"}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		#include "Lighting.cginc"

		uniform float4 _Color;

		struct vertOut{
			float4 pos:SV_POSITION;
			float4 color:COLOR;
		};
		vertOut vert(appdata_base v)
		{
			float3 c=ShadeVertexLights(v.vertex,v.normal);
			vertOut o;
			o.pos=UnityObjectToClipPos(v.vertex);
			o.color=float4(c,1)*_Color;
			return o;
		}
		float4 frag(vertOut i):COLOR
		{
			return i.color;
		}
		ENDCG
		}//end pass
	}
}
