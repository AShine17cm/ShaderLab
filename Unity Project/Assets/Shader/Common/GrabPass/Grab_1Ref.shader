// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shader/GrabPass/Grab_1Ref" {
    SubShader {
	GrabPass {
		"_MyGrab"	
		}
	pass{
	Tags{"LightMode"="Vertex"}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"

		sampler2D _MyGrab;

		struct v2f {
			float4 pos:SV_POSITION;
			float2 uv:TEXCOORD0;
			float3 vc:TEXCOORD1;
		};
		v2f vert (appdata_full v) {
			v2f o;
			o.pos=UnityObjectToClipPos(v.vertex);
			float3 vn=mul(UNITY_MATRIX_MV,float4(SCALED_NORMAL,0)).xyz;
			o.uv.x=asin(vn.x)/3.14+0.5;
			o.uv.y=asin(vn.y)/3.14+0.5;
			o.vc=ShadeVertexLights(v.vertex,v.normal);
			return o;
		}
		float4 frag(v2f i):COLOR
		{
			float4 c=tex2D(_MyGrab,i.uv);
			return c*float4(i.vc,1)*3;
		}
		ENDCG
		}//end Forward Base
    }
}