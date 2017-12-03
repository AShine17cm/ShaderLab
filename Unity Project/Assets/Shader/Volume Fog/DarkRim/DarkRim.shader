// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shader/VolumeFog/DarkRim" {
	Properties {
		MainTex ("Main Tex", 2D) = "white" {}
		kf("Factor of Fog",range(0,9))=1
	}
	SubShader {
	//Tags { "RenderType"="Opaque" "Queue"="Geometry"}
		Tags {  "Queue"="Geometry+600"}
	   pass {
	   Tags{"LightMode"="ForwardBase"}
	   //Blend One OneMinusSrcColor
	    Blend Zero OneMinusSrcColor
		// Cull Front    
		ZWrite Off
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		struct v2f {
			float4 pos : POSITION;
			float2 uv : TEXCOORD0;
			float4 scr:TEXCOORD1;
			float rim:TEXCOORD2;
		};

		sampler2D MainTex;
		float kf;
		v2f vert (appdata_full v) {
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex);
			o.scr=o.pos;
			o.uv.xy = v.texcoord.xy;
			//下面是计算rim边缘因数
			float3 viewDir=ObjSpaceViewDir(v.vertex);
			viewDir=normalize(viewDir);
			o.rim=max(0,dot(viewDir,v.normal));
			o.rim=smoothstep(0,1,o.rim);
			return o;  
		}

		sampler2D _CameraDepthTexture;

		float4 frag (v2f i) : COLOR {
			float4 scr=ComputeScreenPos(i.scr);
			scr.xy/=scr.w;
			float hd=scr.z/scr.w;
			hd=Linear01Depth(hd);
			//return hd;
			float d=tex2D(_CameraDepthTexture,scr.xy).r;
			d=Linear01Depth(d);
			float dif=d-hd;
			dif=dif*i.rim;//
			float4 c=1;
			c=lerp(0,0.5,dif*kf);
			return c;
		} 
		  ENDCG
	  }//pass
	} 
	FallBack Off
}
