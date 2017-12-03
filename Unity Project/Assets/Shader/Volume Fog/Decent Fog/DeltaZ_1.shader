// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shader/Volume_Fog/DeltaZ_1" {
	Properties {
		MainTex ("Main Tex", 2D) = "white" {}
		kf("Factor of Fog",float)=1
	}
	SubShader {
		
		//通过设定RenderType可以使物体在_CameraDepthTexture中的影像为Cull Back
		//然后再通过Cull Front可以计算Cull Front和Cull Back的Z的深度差
		//缺点是：只能为Cull Front
		//关键：_CameraDepthTexture产生所使用的Replacement Shader和此Shader是不相同的
		//对于密封体适应比较好
		Tags { "RenderType"="Opaque" "Queue"="Transparent+100"}
	   pass {
		Blend One OneMinusSrcColor
		ZWrite Off
		Cull Front
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		struct v2f {
			float4 pos : POSITION;
			float2 uv : TEXCOORD0;
			float4 scr:TEXCOORD1;
			//float rim:TEXCOORD2;
		};
		
		v2f vert (appdata_full v) {
			v2f o;
			v.vertex.xyz=v.vertex.xyz-v.normal*0.03;//
			o.pos = UnityObjectToClipPos(v.vertex);
			o.scr=o.pos;
			o.uv.xy = v.texcoord.xy;
			//下面是计算rim边缘因数
			//float3 viewDir=ObjSpaceViewDir(v.vertex);
			//viewDir=normalize(viewDir);
			//o.rim=max(0,dot(viewDir,v.normal));
			//o.rim=smoothstep(0,1,o.rim);
			//o.rim=1-pow(o.rim,1);
			return o;  
		}

		sampler2D _CameraDepthTexture;
		sampler2D MainTex;
		float kf;

		float4 frag (v2f i) : COLOR {

			float4 scr=ComputeScreenPos(i.scr);
			scr.xy/=scr.w;
			float hd=scr.z/scr.w;
			hd=Linear01Depth(hd);

			float d=tex2D(_CameraDepthTexture,scr.xy).r;
			d=Linear01Depth(d);
			float dif=d-hd;//hd-d
			dif=abs(dif);//Back面比Front面的Z更大

			//物体在Z深度图中的影像为Cull Back，对于单面体可能会有为0的情形
			//在Cull Front时，也就是此Pass中，这个Z的深度差dif有可能就是直接相对于其他背景物体的Z深度差
			//因此需要加以限制
			
			dif= dif*kf;
			return dif;
		} 
		  ENDCG
	  }//pass
	} 
	FallBack Off
}
