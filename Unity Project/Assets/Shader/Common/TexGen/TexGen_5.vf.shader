// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shader/Common/TexGen_5.vf" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		pass{
		Tags{"LightMode"="Vertex"}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"

		sampler2D _MainTex;
		float4 _MainTex_ST;

		struct v2f {
			float4 pos:SV_POSITION;
			float2 uv:TEXCOORD0;
			float3 vc:TEXCOORD1;
		};
		v2f vert (appdata_full v) {
			v2f o;
			o.pos=UnityObjectToClipPos(v.vertex);
			float3 vn=mul(UNITY_MATRIX_MV,float4(SCALED_NORMAL,0)).xyz;
			o.uv=vn.xy;
			o.vc=ShadeVertexLights(v.vertex,v.normal);
			return o;
		}
		float4 frag(v2f i):COLOR
		{
			float4 c=tex2D(_MainTex,i.uv);
			c.xyz*=i.vc;
			return c*2;
		}
		ENDCG
		}//end Forward Base
	} 

}
