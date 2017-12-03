// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shadow/ShadowMapping/ShadowMapping_2" {
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
			    //UNITY_TRANSFER_DEPTH(o.depth);
				o.depth = o.pos.zw;
			    return o;
			}
			
			float4 frag(v2f i) : COLOR {
			    //UNITY_OUTPUT_DEPTH(i.depth);
			    float d=i.depth.x/i.depth.y;
				//经过投影矩阵变换后，depth虽然是单调递增的，但是并非线性的
				//1.0 / (_ZBufferParams.x * z + _ZBufferParams.y);
			    d=Linear01Depth(d);
			    return d;
			}
			ENDCG
			}//endpass
	}
}
