// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Effects/Fog/Lab_3/LinearFog" {
    Properties {
        _Color ("Base Color", color) =(1,1,1,1)
        _Density("Density",Range(0,10))=1
        _nearDist("Near Disttance",float)=0
        _farDist("Far Distance",float)=30
    }
    SubShader {
        pass{

        Tags{ "LightMode"="ForwardBase"}
        Fog { Mode off}
        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag
        #pragma multi_compile_fwdbase
        #include "UnityCG.cginc"
        #include "Lighting.cginc"

        float4 _Color;
        float _Density;
        float _nearDist;
        float _farDist;
        struct vertOut{
            float4 pos:SV_POSITION;
            float4 depth : TEXCOORD0;
        };
        vertOut vert(appdata_base v)
        {
            vertOut o;
            o.pos=UnityObjectToClipPos(v.vertex);
            // Same as o.depth=mul(UNITY_MATRIX_MV,v.vertex);
            o.depth = mul(UNITY_MATRIX_V, mul(unity_ObjectToWorld, v.vertex));
            o.depth.z=-o.depth.z;
            o.depth.w=(_farDist-_nearDist)*o.depth.w;
            
            return o;
        }
        float4 frag(vertOut i):COLOR
        {
                float fg=0;
                if(i.depth.z>_nearDist&&i.depth.z<_farDist)
                {
                    fg=i.depth.z/i.depth.w;
                }else if(i.depth.z>_farDist)
                {
                    fg=_farDist/i.depth.w;
                }
                float4 c=fg*_Density*_Color;
                return c;
        }
        ENDCG
        }//end pass
    }
}

