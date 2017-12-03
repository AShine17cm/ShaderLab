// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shadow/BuildInShadow/Caster_3.1" {
	Properties {
		_MainTex ("", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
			pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
	
			sampler2D _MainTex;
			struct vertOut {
				float4 oPos:SV_POSITION;
				float2 uv:TEXCOORD0;
			};
			vertOut vert(appdata_base v)
			{
				vertOut o;
				float4 pos=UnityObjectToClipPos(v.vertex);
				o.oPos=pos;
				o.uv=v.texcoord.xy;
				return o;
			}
			float4 frag(vertOut i):COLOR
			{
				float4 c=tex2D(_MainTex,i.uv);
				return c;
			}
			ENDCG
		}
	} 
	FallBack "Diffuse"
}
