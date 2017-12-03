Shader "Tut/Shader/Toon/Outline_4.0" {
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
	} 
	FallBack "Diffuse"
}
