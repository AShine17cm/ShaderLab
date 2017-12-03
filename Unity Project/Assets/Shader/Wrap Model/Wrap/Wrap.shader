// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shader/Surface/Wrap" {
Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}
	down("Down boundary",float)=0
}
SubShader {
	//假设物体表面布满的是A字峰，通过偏移Normal来构造不同的质感
	//此种以灯光方向来调整Normal
	//然后根据视线V和调整后的N的dot(V,N)来决定漫反射
	Tags{ "RenderType"="Opaque" "Queue"="Geometry+100"}
	pass {
	Tags{"LightMode"="ForwardBase"}
	CGPROGRAM
	#pragma vertex vert
	#pragma fragment frag
	#pragma target 3.0
	#include "UnityCG.cginc"
	struct v2f { 
		float4 pos	: POSITION;
		float2 uv	: TEXCOORD0;
		float3 wN:TEXCOORD1;
		float4 wP:TEXCOORD2;
		float3 LDir:TEXCOORD3;
		float3 VDir:TEXCOORD4;
	}; 

	sampler2D _MainTex;
	v2f vert (appdata_full v)
	{
		v2f o;
		o.pos = UnityObjectToClipPos (v.vertex);
		o.uv = v.texcoord.xy;
		//世界空间内的灯光方向和视线
		o.LDir=WorldSpaceLightDir(v.vertex);
		o.VDir=WorldSpaceViewDir(v.vertex);
		//世界空间内的顶点和法线
		o.wP=mul(unity_ObjectToWorld,v.vertex);
		o.wN=mul(unity_ObjectToWorld,float4(v.normal,0)).xyz;
		//
		return o;
	}
	float4 _LightColor0;
	float down;
	float4 frag (v2f i) : COLOR
	{
		float3 N=normalize(i.wN);
		float3 V=normalize(i.VDir);
		float3 LDir=i.LDir;//指向灯光的矢量
		float3 L=normalize(LDir);//单位长的灯光矢量
		float3 H=(V+L)/2;//用于计算高光的半角向量
		//计算漫反射
		float diff=dot(N,normalize(L));//漫反射
		float spec=max(0,dot(H,N));
		diff=(diff-down)/(1-down);//将漫反射从(-down,1)映射到(0,1)
		diff=max(0,diff);
		spec=pow(spec,24);
		float3 base=_LightColor0.rgb;
		//base=(diff+spec)*base;
		float4 c=0;
		c.rgb=base*diff;
		return c;
	}
	ENDCG
	}
	//Pass 2
	pass {
	Tags{"LightMode"="ForwardAdd"}
	Blend One One
	CGPROGRAM
	#pragma vertex vert
	#pragma fragment frag
	#pragma target 3.0
	#include "UnityCG.cginc"
	struct v2f { 
		float4 pos	: POSITION;
		float2 uv	: TEXCOORD0;
		float3 wN:TEXCOORD1;
		float4 wP:TEXCOORD2;
		float3 LDir:TEXCOORD3;
		float3 VDir:TEXCOORD4;
	}; 

	sampler2D _MainTex;

	v2f vert (appdata_full v)
	{
		v2f o;
		o.pos = UnityObjectToClipPos (v.vertex);
		o.uv = v.texcoord.xy;
		//世界空间内的灯光方向和视线
		o.LDir=WorldSpaceLightDir(v.vertex);
		o.VDir=WorldSpaceViewDir(v.vertex);
		//世界空间内的顶点和法线
		o.wP=mul(unity_ObjectToWorld,v.vertex);
		o.wN=mul(unity_ObjectToWorld,float4(v.normal,0)).xyz;
		//
		return o;
	}
	float4 _LightColor0;
	float down;
	//计算点光源的衰减
	float GetAtten(float3 litDir)
	{
		float att=1;
		float dist=length(litDir);
		att=1/(dist*dist+1);
		return att;
	}
	float4 frag (v2f i) : COLOR
	{
		float3 N=normalize(i.wN);
		float3 V=normalize(i.VDir);
		float3 LDir=i.LDir;//指向灯光的矢量
		float3 L=normalize(LDir);//单位长的灯光矢量
		float3 H=(V+L)/2;//用于计算高光的半角向量
		//计算漫反射
		float diff=dot(N,normalize(L));//漫反射
		float spec=max(0,dot(H,N));
		diff=(diff-down)/(1-down);//将漫反射从(-down,1)映射到(0,1)
		diff=max(0,diff);
		spec=pow(spec,24);
		float3 base=_LightColor0.rgb;
		//base=(diff+spec)*base;
		//计算衰减
		float atten=GetAtten(LDir);
		//使用Diff01和Spec01控制漫反射和高光的比例，是为了便于检视
		float4 c=0;
		c.rgb=base*diff*atten;
		return c;
	}
	ENDCG
	}
}
Fallback "Diffuse"
}
