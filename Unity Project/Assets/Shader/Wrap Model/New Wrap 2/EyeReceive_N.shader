// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Lighting/Surface/Specular/EyeReceive_N" {
Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}
	Slope("Slope of A Peak",range(0,1))=0
	Spec01("Content of Spec",range(0,1))=1
	Diff01("Content of Diff",range(0,1))=1
	Sigma("Distribution of Guassian Spec",range(0,1))=0.5
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
	sampler2D _CameraDepthTexture;

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
	float Slope;
	float Spec01,Diff01;

	float Sigma;
	//float4 _WorldSpaceLightPos0;
	float4 frag (v2f i) : COLOR
	{
		float3 N=normalize(i.wN);
		float3 V=normalize(i.VDir);
		float3 LDir=i.LDir;//指向灯光的矢量
		float3 L=normalize(LDir);//单位长的灯光矢量
		float3 H=(V+L)/2;//用于计算高光的半角向量
		//计算漫反射
		float3 N1=normalize(N+L*Slope);
		float3 N2=normalize(N-L*Slope);
		float diff1=max(0,dot(N1,normalize(L)));//漫反射
		float diff2=max(0,dot(N2,normalize(L)));//漫反射
		float k1=max(0,dot(V,N1));
		float k2=max(0,dot(V,N2));
		float diff=max(k1*diff1,k2*diff2);//漫反射通过调整后的法线N1,N2与视线的垂直度来接受

		//float diff=max(0,dot(N,normalize(i.LDir)));//漫反射
		//下面计算以高斯形态分别的高光
		float angle1=acos(dot(H,N1));
		angle1=angle1/Sigma;
		angle1=-angle1*angle1;
		float spec1=exp(angle1);

		float angle2=acos(dot(H,N2));
		angle2=angle2/Sigma;
		angle2=-angle2*angle2;
		float spec2=exp(angle2);

		float spec=k1*spec1+k2*spec2;//高光通过调整后的法线N1,N2与视线的垂直度来接受

		float3 base=_LightColor0.rgb;
		//使用Diff01和Spec01控制漫反射和高光的比例，是为了便于检视
		base=(diff*Diff01+spec*Spec01)*base;
		float4 c=0;
		c.rgb=base;
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
	sampler2D _CameraDepthTexture;

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
	float Slope;
	float Spec01,Diff01;

	float Sigma;
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
		float3 N1=normalize(N+L*Slope);
		float3 N2=normalize(N-L*Slope);
		float diff1=max(0,dot(N1,normalize(L)));//漫反射
		float diff2=max(0,dot(N2,normalize(L)));//漫反射
		float k1=max(0,dot(V,N1));
		float k2=max(0,dot(V,N2));
		float diff=max(k1*diff1,k2*diff2);//漫反射通过调整后的法线N1,N2与视线的垂直度来接受
		//计算衰减
		float atten=GetAtten(LDir);

		//下面计算以高斯形态分别的高光,dot(H,N)一定大于0
		float angle1=acos(dot(H,N1));
		angle1=angle1/Sigma;
		angle1=-angle1*angle1;
		float spec1=exp(angle1);

		float angle2=acos(dot(H,N2));
		angle2=angle2/Sigma;
		angle2=-angle2*angle2;
		float spec2=exp(angle2);

		float spec=k1*spec1+k2*spec2;//高光通过调整后的法线N1,N2与视线的垂直度来接受

		float3 base=_LightColor0.rgb;
		//使用Diff01和Spec01控制漫反射和高光的比例，是为了便于检视
		base=(diff*Diff01+spec*Spec01)*atten*base;

		float4 c=0;
		c.rgb=base;
		return c;
	}
	ENDCG
	}
}
Fallback "Diffuse"
}
