Shader "Tut/Shadow/Caster/CutoutShadowOnly" {
    Properties {
        _MainTex ("Alpha (A)", 2D) = "white" {}
        _Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
     Tags {"Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout"}
      Pass {
          Name "Caster"
          Tags { "LightMode" = "ShadowCaster" }
            Offset 1, 1
            Fog {Mode Off}
            ZWrite On ZTest LEqual Cull Front
            CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #pragma multi_compile_shadowcaster
                #pragma fragmentoption ARB_precision_hint_fastest
                #include "UnityCG.cginc"
                struct v2f { 
                   V2F_SHADOW_CASTER;
                    float2  uv : TEXCOORD1;
                };
               uniform float4 _MainTex_ST;
               v2f vert( appdata_base v ) {
                    v2f o;
                    TRANSFER_SHADOW_CASTER(o)
                   o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                    return o;
             }
             uniform sampler2D _MainTex;
             uniform fixed _Cutoff;
             float4 frag( v2f i ) : COLOR {
                fixed alpha = tex2D( _MainTex, i.uv ).a;
                 clip( alpha - _Cutoff );
                 SHADOW_CASTER_FRAGMENT(i)
             }
         ENDCG
     }
    }
   Fallback Off
}

