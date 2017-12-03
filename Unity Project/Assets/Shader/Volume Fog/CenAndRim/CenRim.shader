// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shader/Volume_Fog/CenRim" {
	Properties {
		kc("Factor to center",range(0,30))=1
		kf("Factor of Fog",range(0,30))=1
	}
	SubShader {
		Tags {  "Queue"="Geometry+600"}
	   pass {
	   Tags{"LightMode"="ForwardBase"}
	   Blend One OneMinusSrcColor
		ZWrite Off
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		struct v2f {
			float4 pos : POSITION;
			float4 scr:TEXCOORD1;
			float4 cen:TEXCOORD2;
			float4 vp:TEXCOORD3;
			float rim:TEXCOORD4;
		};

		sampler2D MainTex;
		float kf;
		float kc;
		v2f vert (appdata_full v) {
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex);
			o.scr=o.pos;
			float4 cen= UnityObjectToClipPos(float4(0,0,0,1));//
			float4 vp=UnityObjectToClipPos(v.vertex);
			o.cen=cen;
			o.vp=vp;
			//下面是计算rim边缘因数
			float3 viewDir=ObjSpaceViewDir(v.vertex);
			viewDir=normalize(viewDir);
			o.rim=max(0,dot(viewDir,v.normal));
			return o;  
		}

		sampler2D _CameraDepthTexture;
		float4 frag (v2f i) : COLOR {

			//下面是计算到物体中心的衰减
			float3 cen=i.cen.xyz/i.cen.w;
			float3 vp=i.vp.xyz/i.vp.w;
			cen=vp-cen;
			float dc=1-length(cen);
			dc=pow(dc,6);
			dc=dc*kc;

			float4 scr=ComputeScreenPos(i.scr);
			scr.xy/=scr.w;
			float hd=scr.z/scr.w;
			hd=Linear01Depth(hd);

			float d=tex2D(_CameraDepthTexture,scr.xy).r;// 取得屏幕上的像素点的Z深度
			d=Linear01Depth(d);
			float dif=d-hd;//计算Z深度差
			dif=dif*kf;//控制Fog浓度
			dc=dc/(1+dc);//保证dc小于1
			dif=dif*dc;//dc 应用到Fog物体中心的衰减
			dif=dif*i.rim;//rim 应用边缘衰减，淡化边缘
			float4 c=1;
			c=lerp(0,0.5,dif);
			return c;
		} 
		  ENDCG
	  }//pass
	} 
	FallBack Off
}
