Shader "Tut/Shader/Volume_Fog/DXdepth" {
	Properties {
	}
	SubShader {
			//Tags{ "RenderType" = "Opaque" "Queue" = "Transparent+100" 
			Tags{ "RenderType" = "Opaque" "Queue" = "Geometry" }

	   pass {
		ZWrite Off
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		struct v2f {
			float4 pos : POSITION;
			float2 uv : TEXCOORD0;
			float4 scr:TEXCOORD1;
		};
		
		v2f vert (appdata_full v) {
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex);
			o.scr=o.pos;
			o.uv.xy = v.texcoord.xy;
			return o;  
		}

		sampler2D _CameraDepthTexture;
		float4 frag (v2f i) : COLOR {

			float4 scr=ComputeScreenPos(i.scr);
			scr.xy/=scr.w;
			float d=tex2D(_CameraDepthTexture,(scr.xy-float2(0.5,0.5))*2.0+float2(0.5,0.5)).r;
			
			//d = 0;
			d=Linear01Depth(d);
			return float4(d, d, d, d);
		} 
		  ENDCG
	  }//pass
	} 
	//FallBack "Diffuse"
}
