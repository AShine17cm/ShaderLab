// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/ImageEffects/Bilt_1" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque"}
		pass {
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		sampler2D _MainTex;
		float4 _MainTex_ST;
		struct v2f {
			float4 pos :SV_POSITION;
			float2 uv : TEXCOORD0;
		};
		v2f vert( appdata_base v )
		{
			v2f o;
			o.pos = UnityObjectToClipPos (v.vertex);
			o.uv = TRANSFORM_TEX(v.texcoord,_MainTex);
			return o;
		}
		half4 frag (v2f i) : COLOR
		{
			half4 c = tex2D(_MainTex, i.uv);
			float lu=Luminance(c);
			c=float4(lu,lu,lu,lu);
			return c;
		}
		ENDCG
		}//end pass
	} 
	FallBack Off
}
