// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shader/Toon/Outline_5" {
	Properties{
		_ValA("Offset Val A",int)=1
		_ValB("Offset Val B",int)=1
	}
	SubShader {
		pass{
		Tags{"LightMode"="Always"}
		Cull Front
		ZWrite On
		Offset [_ValA],[_ValB]
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		struct v2f {
			float4 pos:SV_POSITION;
		};
		v2f vert (appdata_full v) {
			v2f o;
			o.pos=UnityObjectToClipPos(v.vertex);
			return o;
		}
		float4 frag(v2f i):COLOR
		{
			return 0;
		}
		ENDCG
		}//end of pass
	pass{
		Tags{"LightMode"="ForwardBase"}
		Offset 1,1
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		float4 _LightColor0;
		struct v2f {
			float4 pos:SV_POSITION;
			//float2 uv:TEXCOORD0;
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
			float diff=max(0,dot(N,i.lightDir));
			diff=(diff+1)/2;
			diff=smoothstep(0,1,diff);
			c=_LightColor0*diff;
			return c;
		}
		ENDCG
		}
	} 
}
