// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shader/Bumpy/Bump_3" {
	Properties {
		_BumpMap("BumpMap",2D)="white"{}
	}
	SubShader {
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
			TANGENT_SPACE_ROTATION;
			o.lightDir= mul(unity_WorldToObject, _WorldSpaceLightPos0).xyz;//Direction Light
			o.lightDir=mul(rotation,o.lightDir);
			return o;
		}
		float4 frag(v2f i):COLOR
		{
			float4 c=1;
			float3 N=UnpackNormal(tex2D(_BumpMap,i.uv));
			float diff=max(0,dot(N,i.lightDir));
			c=_LightColor0*diff;
			return c*2;
		}
		ENDCG
		}
	} 
}
