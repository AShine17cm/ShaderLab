Shader "Tut/Shadow/BuildInShadow/Caster_1" {
Properties {
    _MainTex ("Base (RGB)", 2D) = "white" {}
}

SubShader {
    // Pass to render object as a shadow caster
    Pass {
       Name "ShadowCaster"
       Tags { "LightMode" = "ShadowCaster" }

       Fog {Mode Off}
       ZWrite On ZTest Less Cull Off
       //Offset [_ShadowBias], [_ShadowBiasSlope]

		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma multi_compile SHADOWS_NATIVE SHADOWS_CUBE
		#pragma fragmentoption ARB_precision_hint_fastest
		#include "UnityCG.cginc"
		
		struct v2f { 
		    V2F_SHADOW_CASTER;
		};
		
		v2f vert( appdata_base v )
		{
		    v2f o;
		    TRANSFER_SHADOW_CASTER(o)
		    return o;
		}
		
		float4 frag( v2f i ) : COLOR
		{
		    SHADOW_CASTER_FRAGMENT(i)
		}
		ENDCG

    }//endpass
	}
}

