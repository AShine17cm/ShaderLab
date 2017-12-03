// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shader/Common/Cull_3" {
	SubShader {
		Cull Front
		pass{
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		struct v2f{
			float4 pos:SV_POSITION;
		};
		v2f vert(appdata_base v)
		{
			v2f o;
			o.pos=v.vertex;
			o.pos.xyz+=v.normal*0.03;
			o.pos=UnityObjectToClipPos(o.pos);
			return o;
		}
		float4 frag(v2f i):COLOR
		{
			return (1,0,0,1);
		}
		ENDCG
		}
		pass{
			Cull Back
			Lighting On
			Material{ Diffuse(1,1,1,1) }
		}
	} 
}
