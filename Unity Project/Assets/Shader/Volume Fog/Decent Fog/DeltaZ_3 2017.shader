Shader "Tut/Shader/Volume_Fog/DeltaZ_3_2017" {
	Properties {
		_MainTex ("Main Tex", 2D) = "white" {}
		kf1("Factor 1 of Fog",range(0,10))=1
			kf2("Factor 2 of Fog",range(0,10)) = 1
			p1("Pow 1 of Fog",range(1,10)) = 1
			p2("Pow 2 of Fog",range(1,10)) = 1
		BaseC("Base Color",color)=(1,1,1,1)
	}
	SubShader {
		Tags{ "RenderType" = "Opaque" "Queue" = "Geometry+500" }
		pass {
			//Tags{"LightMode"="ForwardBase"}
			//	ColorMask A
			//BlendOp RevSub
			//Blend SrcAlpha Zero
				ZWrite On
				Cull Front
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"
				struct v2f {
				float4 pos : POSITION;
				float2 uv : TEXCOORD0;
				float4 scr:TEXCOORD1;
			};

			v2f vert(appdata_full v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.scr = o.pos;
				o.uv.xy = v.texcoord.xy;
				return o;
			}
			float kf1,kf2,p1,p2;
			sampler2D _MainTex;
			float4 frag(v2f i) : COLOR{
				float4 scr = ComputeScreenPos(i.scr);
				float hd = scr.z / scr.w;
				float4 tex = tex2Dproj(_MainTex, i.scr);
				tex = tex2D(_MainTex, i.uv);
				hd = Linear01Depth(hd);
				float k = pow(hd, p1)*kf1;
				return float4(1,1,1,k);
			}
				ENDCG
		}
	   pass {
		   //Tags{ "LightMode" = "ForwardAdd" }
		BlendOp Sub
		Blend  DstAlpha SrcAlpha
		ZWrite On
		Cull Back
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
		sampler2D _MainTex;
		float kf1,kf2,p1,p2;
		float4 frag (v2f i) : COLOR {

			float4 scr = ComputeScreenPos(i.scr);
			float hd = scr.z/ scr.w;
			float4 tex = tex2Dproj(_MainTex, i.scr);
			tex = tex2D(_MainTex, i.uv);
			hd=Linear01Depth(hd);
			float k = pow(hd, p2)*kf2;
			return float4(1,1,1,k);
		} 
		  ENDCG
	  }//pass
	} 
	FallBack "Diffuse"
}
