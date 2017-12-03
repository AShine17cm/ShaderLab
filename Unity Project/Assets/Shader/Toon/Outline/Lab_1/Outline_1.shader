// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shader/Toon/Outline_1" {
	Properties {
		_Outline("Outline",range(0,0.2))=0.02
	}
	SubShader {
		pass{
		Tags{"LightMode"="Always"}
		Cull Off
		ZWrite Off
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		float _Outline;
		struct v2f {
			float4 pos:SV_POSITION;
		};

		v2f vert (appdata_full v) {
			v2f o;
			v.vertex.xyz+=v.normal*_Outline;
			o.pos=UnityObjectToClipPos(v.vertex);
			return o;
		}
		float4 frag(v2f i):COLOR
		{
			float4 c=0;
			return c;
		}
		ENDCG
		}//end of pass
		pass{
		Tags{"LightMode"="ForwardBase"}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"

		float4 _LightColor0;
		struct v2f {
			float4 pos:SV_POSITION;
			float3 lightDir:TEXCOORD0;
			float3 viewDir:TEXCOORD1;
			float3 normal:TEXCOORD2;
		};

		v2f vert (appdata_full v) {
			v2f o;
			o.pos=UnityObjectToClipPos(v.vertex);
			o.normal=v.normal;
			o.lightDir=ObjSpaceLightDir(v.vertex);
			o.viewDir=ObjSpaceViewDir(v.vertex);

			return o;
		}
		float4 frag(v2f i):COLOR
		{
			float4 c=1;
			float3 N=normalize(i.normal);
			float3 viewDir=normalize(i.viewDir);
			float diff=dot(N,i.lightDir);
			diff=(diff+1)/2;
			diff=smoothstep(diff/12,1,diff);
			c=_LightColor0*diff;
			return c;
		}
		ENDCG
		}
	} 
}
