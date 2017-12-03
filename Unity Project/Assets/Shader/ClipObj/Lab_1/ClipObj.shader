// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shader/ClipObj" {
	Properties {
	
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		pass
		{
		Tags{"LightMode"="ForwardBase"}
		Cull Front
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		#pragma target 3.0
		
		struct v2f{
			float4 pos:SV_POSITION;
			float vc:TEXCOORD0;
			float3 px:TEXCOORD1;
			float3 cp:TEXCOORD2;
			float3 cn:TEXCOORD3;
		};
		float4 cPos;//world Position
		float4 cNormal;
		v2f vert(appdata_full i)
		{
			v2f o;
			o.pos=UnityObjectToClipPos(i.vertex);
			float3 ld=ObjSpaceLightDir(i.vertex);
			ld=normalize(ld);
			//对于填补的洞口，使用剪切方向作为法线，计算光照
			o.vc=max(0,dot(cNormal.xyz,ld));
			o.px=i.vertex/i.vertex.w;
			//float4 wPos=
			o.cp=mul(unity_WorldToObject,cPos).xyz;
			o.cn=mul(unity_WorldToObject,cNormal).xyz;
			
			return o;
		}
		
		float4 frag(v2f i):COLOR
		{
			float3 dir=i.cp-i.px;
			float c=dot(dir,i.cn);
			clip(c);
			
			return float4(i.vc,i.vc,i.vc,0);
		}
		ENDCG
		}
		pass
		{
		Tags{"LightMode"="ForwardBase"}
		Cull Back
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		#pragma target 3.0
		
		struct v2f{
			float4 pos:SV_POSITION;
			float vc:TEXCOORD0;
			float3 px:TEXCOORD1;
			float3 cp:TEXCOORD2;
			float3 cn:TEXCOORD3;
		};
		float4 cPos;//world Position
		float4 cNormal;
		v2f vert(appdata_full i)
		{
			v2f o;
			o.pos=UnityObjectToClipPos(i.vertex);
			float3 ld=ObjSpaceLightDir(i.vertex);
			ld=normalize(ld);
			o.vc=max(0,dot(i.normal,ld));//正常计算光照
			o.px=i.vertex/i.vertex.w;
		
			o.cp=mul(unity_WorldToObject,cPos).xyz;
			o.cn=mul(unity_WorldToObject,cNormal).xyz;
			
			return o;
		}
		
		float4 frag(v2f i):COLOR
		{
			float3 dir=i.cp-i.px;
			float c=dot(dir,i.cn);
			clip(c);
			
			return float4(i.vc,i.vc,i.vc,0);
		}
		ENDCG
		}
	} 
	FallBack "Diffuse"
}
