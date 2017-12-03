// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Organize/KeyWords/Multi_Compile" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		pass{
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma multi_compile MY_multi_1 MY_multi_2
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
			#ifdef MY_multi_1
			c=float4(0,1,0,0);
			#endif
			#ifdef MY_multi_2
			c=float4(0,0,1,0);
			#endif
			return c;
		}
		ENDCG
		}//end pass
		
	} 
	CustomEditor "ExamEditor_2"
}
