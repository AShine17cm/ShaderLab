// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shader/Toon/Outline_4.1" {
	Properties {
		_Outline("Out line",range(0,0.3))=0.02
		_Outline2("Out line2",range(0,0.3))=0.02
		_Factor("Factor",range(0,1))=0.5
		_Factor2("Factor",range(0,1))=0.5
	}
	SubShader {
		pass{
		Tags{"LightMode"="Always"}
		Cull Back
		ZWrite On
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		float _Outline;
		float _Factor;
		struct v2f {
			float4 pos:SV_POSITION;
		};

		v2f vert (appdata_full v) {
			v2f o;
			o.pos=UnityObjectToClipPos(v.vertex);

			float3 dir=normalize(v.vertex.xyz);
			float3 dir2=v.normal;
			dir=lerp(dir,dir2,_Factor);
			dir= mul ((float3x3)UNITY_MATRIX_IT_MV, dir);
			float2 offset = TransformViewToProjection(dir.xy);
			offset=normalize(offset);
			o.pos.xy += offset * o.pos.z *_Outline;

			return o;
		}
		float4 frag(v2f i):COLOR
		{
			return float4(1,1,1,1);
		}
		ENDCG
		}//end of pass .1
		pass{
		Tags{"LightMode"="Always"}
		Cull Front
		ZWrite Off
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		float _Outline2;
		float _Factor2;
		struct v2f {
			float4 pos:SV_POSITION;
		};

		v2f vert (appdata_full v) {//.2
			v2f o;
			o.pos=UnityObjectToClipPos(v.vertex);

			float3 dir=normalize(v.vertex.xyz);
			float3 dir2=v.normal;
			dir=lerp(dir,dir2,_Factor2);
			dir= mul ((float3x3)UNITY_MATRIX_IT_MV, dir);
			float2 offset = TransformViewToProjection(dir.xy);
			offset=normalize(offset);
			o.pos.xy += offset * o.pos.z *_Outline2;
			return o;
		}
		float4 frag(v2f i):COLOR
		{
			return float4(0,0,0,0);
		}
		ENDCG
		}//end of pass .2
		pass{
		Tags{"LightMode"="ForwardBase"}
		Blend DstColor Zero
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"

		float4 _LightColor0;
		sampler2D _MainTex;
		float _Factor;
		float _Outline;

		struct v2f {
			float4 pos:SV_POSITION;
			float3 lightDir:TEXCOORD0;
			float3 viewDir:TEXCOORD1;
			float3 normal:TEXCOORD2;
		};

		v2f vert (appdata_full v) {
			v2f o;
			o.pos=UnityObjectToClipPos(v.vertex);

			float3 dir=normalize(v.vertex.xyz);
			float3 dir2=v.normal;
			dir=lerp(dir,dir2,_Factor);
			dir= mul ((float3x3)UNITY_MATRIX_IT_MV, dir);
			float2 offset = TransformViewToProjection(dir.xy);
			offset=normalize(offset);
			o.pos.xy += offset * o.pos.z *_Outline;

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
