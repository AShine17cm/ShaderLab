// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shadow/ShadowMapping/ShadowMapping_1" {
	SubShader {
	    Tags { "RenderType"="Opaque" }
	    Pass {
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
				o.depth = o.pos.zw;
			    return o;
			}
			
			float4 frag(v2f i) : COLOR {
			    float d=i.depth.x/i.depth.y;
				//经过投影矩阵变换后，depth虽然是单调递增的，但是并非线性的
			    d=Linear01Depth(d);//1.0 / (_ZBufferParams.x * z + _ZBufferParams.y);
			    return float4(d,d,d,d);
			}
			ENDCG
			}//endpass
	}
}
