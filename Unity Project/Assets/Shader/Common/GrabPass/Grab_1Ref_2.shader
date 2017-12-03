// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shader/GrabPass/Grab_1Ref_2" {
	Properties{
		_Range("Reflection Range",range(0.1,1))=0.3
	}
    SubShader {
	GrabPass {
		"_MyGrab2"	
		}
	pass{
	Tags{"LightMode"="Vertex"}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"

		sampler2D _MyGrab2;
		float _Range;

		struct v2f {
			float4 pos:SV_POSITION;
			float2 uv:TEXCOORD0;
			float3 vc:TEXCOORD1;
			//float2 scrPivot:TEXCOORD2;
		};
		v2f vert (appdata_full v) {
			v2f o;
			o.pos=UnityObjectToClipPos(v.vertex);
			float3 vn=mul(UNITY_MATRIX_MV,float4(SCALED_NORMAL,0)).xyz;
			o.uv.x=asin(vn.x)/3.14+0.5;
			o.uv.y=asin(vn.y)/3.14+0.5;
			o.vc=ShadeVertexLights(v.vertex,v.normal);
			//
			float2 scrPivot=ComputeScreenPos(UnityObjectToClipPos(float4(0,0,0,0))).xy/2;
			o.uv=(o.uv+scrPivot)*_Range;
			//o.uv-=scrPivot;
			return o;
		}
		float4 frag(v2f i):COLOR
		{
			float4 c=tex2D(_MyGrab2,i.uv);
			return c*float4(i.vc,1)*3;
		}
		ENDCG
		}//end Forward Base
    }
}