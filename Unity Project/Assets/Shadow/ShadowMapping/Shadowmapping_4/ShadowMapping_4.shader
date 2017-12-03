// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shadow/ShadowMapping/ShadowMapping_4" {
	SubShader {
	    Tags { "RenderType"="Opaque" }
	    Pass {
	        Fog { Mode Off }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			
			struct v2f {
			    float4 pos : SV_POSITION;
			    float2 depth : TEXCOORD0;
			};
			
			v2f vert (appdata_base v) {
			    v2f o;
			    o.pos = UnityObjectToClipPos (v.vertex);
				o.depth=float2(0,0);
			    //UNITY_TRANSFER_DEPTH(o.depth);
				o.depth = o.pos.zw;
			    return o;
			}
			
			float4 frag(v2f i) : COLOR {
			    //UNITY_OUTPUT_DEPTH(i.depth);
			    float d=i.depth.x/i.depth.y;
			    d=Linear01Depth(d);
			    return d;
			}
			ENDCG
			}//endpass
	}
}
