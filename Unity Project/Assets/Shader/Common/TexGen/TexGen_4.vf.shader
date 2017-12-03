// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shader/Common/TexGen_4.vf" {
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
		struct v2f {
			float4 pos:SV_POSITION;
			float2 uv:TEXCOORD0;
			float3 vc:TEXCOORD1;
		};
		v2f vert (appdata_full v) {
			v2f o;
			o.pos=UnityObjectToClipPos(v.vertex);
			float3 viewDir=-ObjSpaceViewDir(v.vertex);
			
			viewDir=mul(UNITY_MATRIX_MV,float4(viewDir,0)).xyz;
			viewDir=normalize(viewDir);
			float3 vn=mul(UNITY_MATRIX_MV,float4(SCALED_NORMAL,0)).xyz;
			o.uv=reflect(viewDir,vn).xy;

			//o.uv=2*dot(viewDir,vn)*vn-viewDir+1;
			//float3 nW=mul(float3x3(_Object2World),SCALED_NORMAL);
			//o.uv=2*nW.z*vn-float3(0,0,1);
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
