// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Organize/Use_MyFuncs" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		pass{
		Tags{ "LightMode"="ForwardBase"}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		#include "MyFuncs.cginc"
		uniform float4 _Color;
		float4 _LightColor0;
		struct vertOut{
			float4 pos:SV_POSITION;
			float4 color:COLOR;
		};
		vertOut vert(appdata_base v)
		{
			float3 n=(mul(float4(v.normal,0.0),unity_WorldToObject)).xyz;
			n=normalize(n);

			float4 lightDir;
			float4 diffColor=float4(0,0,0,0);

			float4 worldSpaceVertex=mul(unity_ObjectToWorld,v.vertex);
			float4 myLightPos=_WorldSpaceLightPos0;
			//使用我们在自定义的MyFuncs.cginc函数来计算光源方向以及灯光的衰减
			myLightPos=DoLightDir_Atten(myLightPos,worldSpaceVertex);
			//使用我们在MyFuncs.cginc中定义的结构，并初始化之
			MyLightingInfo info;
			info.vNormal=n;
			info.lightDir=myLightPos;
			info.lightColor=_LightColor0;
			//使用在MyFuncs.cginc中定义的计算光照的函数
			diffColor=DoMyLighting(info);
			
			//
			vertOut o;
			o.pos=UnityObjectToClipPos(v.vertex);
			o.color=diffColor;
			return o;
		}
		float4 frag(vertOut i):COLOR
		{
			return i.color;
		}
		ENDCG
		}//end pass
	} 
	FallBack "Diffuse"
}
