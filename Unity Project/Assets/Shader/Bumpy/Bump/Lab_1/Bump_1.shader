// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shader/Bumpy/Bump_1" {
	Properties {
		_BumpMap("BumpMap",2D)="white"{}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		pass{
		Tags{"LightMode"="ForwardBase"}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"

		float4 _LightColor0;
		sampler2D _BumpMap;

		struct v2f {
			float4 pos:SV_POSITION;
			float2 uv:TEXCOORD0;
			float3 lightDir:TEXCOORD1;
		};

		v2f vert (appdata_full v) {
			v2f o;
			o.pos=UnityObjectToClipPos(v.vertex);
			o.uv=v.texcoord.xy;

			float3 binormal=cross(v.normal,v.tangent)*v.tangent.w;
			float3x3 rotation=float3x3(v.tangent.xyz,binormal,v.normal);

			o.lightDir= mul(unity_WorldToObject, _WorldSpaceLightPos0).xyz;//Direction Light
			o.lightDir=mul(rotation,o.lightDir);
			return o;
		}
		float4 frag(v2f i):COLOR
		{
			float4 c=1;

			float4 packedN=tex2D(_BumpMap,i.uv);
			float3 N=float3(2.0*packedN.wy-1,1.0);
			N.z=sqrt(1-N.x*N.x-N.y*N.y);
			float diff=max(0,dot(N,i.lightDir));
			c=_LightColor0*diff;
			return c*2;
		}
		ENDCG
		}//end Forward Base
	} 
}
