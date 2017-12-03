// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shader/Area Lit/LineLit_1" {
	Properties{
		lh("Height of Line light",range(0,4))=1
		li("Intensity of Light",range(0,20))=1
	}
	SubShader {
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
			float3 wN:TEXCOORD0;
			//float3 litDir:TEXCOORD1;
			float4 wP:TEXCOORD1;
		};
		float4 litP;//pos of area obj
		float4 litT;
		float lh;
		float li;
		v2f vert(appdata_base v)
		{
			v2f o;
			o.pos=UnityObjectToClipPos(v.vertex);
			o.wN=mul(unity_ObjectToWorld,float4(SCALED_NORMAL,0)).xyz;
			o.wP=mul(unity_ObjectToWorld,v.vertex);
			//float4 wP=mul(_Object2World,v.vertex);
			//o.litDir=litP.xyz-wP.xyz/wP.w;
			return o;
		}
		float4 frag(v2f i):COLOR
		{
			float3 litDir=litP.xyz-i.wP.xyz/i.wP.w;//

			float3 litDir1=litP.xyz+litT.xyz*lh-i.wP.xyz/i.wP.w;//
			float3 litDir2=litP.xyz-litT.xyz*lh-i.wP.xyz/i.wP.w;//
			float len1=length(litDir1);
			float len2=length(litDir2);
			float len=abs(len1*len1-len2*len2)-4*lh*lh;//(2*lw)*(2*lw)
			//
			float diff=0;
			float att=1;
			float3 dr=0;
			//
			if(len<0)//判断 是否处于 线段光源的 内侧
			{
				//下面计算垂线段 向量
				float dt=abs(dot(normalize(litDir1),litT.xyz));
				float3 horT=dt*length(litDir1)*litT.xyz;
				float3 Ldir=litDir1-horT;//垂直向量
				
				dr=Ldir;
				diff=dot(normalize(i.wN),normalize(dr)); // diffuse version 1
				diff=(diff+0.7)/1.7;// diffuse version 2
				att=1/(1+length(dr));
				att=att*att;
			}
			else//不然点就处于 线段光源的 外侧
				//取光源线段上最近的点
			{
				if(len1<len2)
					dr=litDir1;
				else
					dr=litDir2;

				//
				att=1/(1+length(dr));
				att=att*att;
				//diff=max(0,dot(normalize(i.wN),normalize(dr))); // diffuse version 1
				diff=dot(normalize(i.wN),normalize(dr));// diffuse version 2
				diff=(diff+0.7)/1.7;
				//diff=diff*abs(dot(litR.xyz,i.wN));
			}
			float c= li*diff*att;
			//
			return c;
		}
		ENDCG
		}//end pass
	}
}
