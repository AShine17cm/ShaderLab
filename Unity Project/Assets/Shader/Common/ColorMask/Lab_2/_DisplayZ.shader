// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shader/Common/_DisplayZ" {
	SubShader {
		Tags{"RenderType"="Transparent" "Queue"="Transparent" "LightMode"="Always"}
		Zwrite Off
		pass{
		//ZTest Always
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		sampler2D _CameraDepthTexture;

		struct v2f {
			float4 pos:SV_POSITION;
			float2 uv:TEXCOORD0;
		};
		v2f vert(appdata_base v)
		{
			v2f o;
			o.pos=UnityObjectToClipPos(v.vertex);
			o.uv=v.texcoord;
			return o;
		}
		half4 frag(v2f i):COLOR
		{
			float d=tex2D(_CameraDepthTexture,i.uv).r;
			d=Linear01Depth(d);
			return float4(d,d,d,1);
		}
		ENDCG
		}
	} 
	FallBack Off
}
