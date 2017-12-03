// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Effects/Fog/Lab_3/Exp2Fog" {
	Properties {
		_Color ("Base Color", color) =(1,1,1,1)
		_Density("Density",Range(0,1))=0.001
	}
	SubShader {
		pass{

		Tags{ "LightMode"="ForwardBase"}
		Fog { Mode off}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma multi_compile_fwdbase
		#include "UnityCG.cginc"
		#include "Lighting.cginc"

		float4 _Color;
		float _Density;

		struct vertOut{
			float4 pos:SV_POSITION;
			float fogExp : TEXCOORD0;
		};
		vertOut vert(appdata_base v)
		{
			vertOut o;
			o.pos=UnityObjectToClipPos(v.vertex);
			float4 posV=mul(UNITY_MATRIX_MV,v.vertex);
			float dist=length(posV.xyz);
			o.fogExp=dist*dist*_Density;
			return o;
		}
		float4 frag(vertOut i):COLOR
		{
				
				float ff=exp2(-abs(i.fogExp));
			    float4 c=(1-ff)*_Color;
			    return c;
		}
		ENDCG
		}//end pass
	}
}

