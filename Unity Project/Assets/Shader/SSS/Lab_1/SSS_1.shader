// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shader/SSS/SSS_1" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_BaseColor("Base Color of Object",color)=(1,1,1,1)
		_DistAdjust("Distance Adjust",float)=0
		_Atten("Control the Density of Object",float)=1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		pass{
		Tags{ "LightMode"="ForwardBase"}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma multi_compile_fwdbase
		#pragma target 3.0
		#include "UnityCG.cginc"

		struct v2f{
			float4 pos:SV_POSITION;
		};
		v2f vert(appdata_base v)
		{
			v2f o;
			o.pos=UnityObjectToClipPos(v.vertex);
			return o;
		}
		
		float4 frag(v2f i):COLOR
		{
			//
			return 0;
		}
		ENDCG
		}//end pass
		pass{
		Blend One One
		Tags{ "LightMode"="ForwardAdd"}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma target 3.0
		#include "UnityCG.cginc"

		struct v2f{
			float4 pos:SV_POSITION;
			float3 N:TEXCOORD0;
			float3 litDir:TEXCOORD1;
			//float4 vp:TEXCOORD2;
		};
		v2f vert(appdata_base v)
		{
			v2f o;
			o.pos=UnityObjectToClipPos(v.vertex);
			o.N=v.normal;
			o.litDir=ObjSpaceLightDir(v.vertex);
			//o.vp=v.vertex;
			return o;
		}
		float4 _BaseColor;
		float _DistAdjust;
		float _Atten;
		float4 frag(v2f i):COLOR
		{
			float3 N=normalize(i.N);
			//float3 litDir=ObjSpaceLightDir(i.vp);
			float3 litDir=i.litDir;//光源方向
			float dist=length(litDir);//到光源的原始距离
			dist=max(0,dist-_DistAdjust);//对原始距离进行一个偏移
			float att=1/(1+dist*dist);
			att=pow(att,_Atten);//计算光的衰减速度
			float4 c= _BaseColor* att*2;
			//c.a=1-c.a;
			return c;
		}
		ENDCG
		}//end pass
	} 
	FallBack "Diffuse"
}
