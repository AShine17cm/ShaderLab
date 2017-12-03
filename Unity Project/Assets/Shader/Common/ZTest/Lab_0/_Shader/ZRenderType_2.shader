Shader "Tut/Shader/Common/ZRenderType_2" {
Properties {
    _MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
}
SubShader {
	Tags{ "RenderType" = "Opaque" }
	LOD 100
	pass {
	ZTest LEqual
		Material{ Diffuse(1,1,0.4,1) }
		Lighting On
		SetTexture[_MainTex]{ combine texture*primary double }
	}
	Pass
	{
		Name "ShadowCaster"
		Tags{ "LightMode" = "ShadowCaster" }

		ZWrite On ZTest LEqual Cull Off

		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma target 2.0
		#pragma multi_compile_shadowcaster
		#include "UnityCG.cginc"

			struct v2f {
			V2F_SHADOW_CASTER;
			UNITY_VERTEX_OUTPUT_STEREO
		};

		v2f vert(appdata_base v)
		{
			v2f o;
			UNITY_SETUP_INSTANCE_ID(v);
			UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
			TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
				return o;
		}

		float4 frag(v2f i) : SV_Target
		{
			SHADOW_CASTER_FRAGMENT(i)
		}
		ENDCG
		}
	}
	//Fallback "Diffuse"
}

