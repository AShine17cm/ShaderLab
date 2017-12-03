// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Effects/Lab_3/myLinearFog" {
    Properties {
        _Color ("Base Color", color) =(1,1,1,1)
        _Density("Density",Range(0,10))=1
    }
    SubShader {
        Tags{"Queue"="Transparent+10"}
        pass{

        Tags{ "LightMode"="ForwardBase"}
        Blend SrcAlpha One
        //Blend One One
        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag
        #pragma multi_compile_fwdbase
        #include "UnityCG.cginc"
        #include "Lighting.cginc"

        float4 _Color;
        float _Density;
        struct vertOut{
            float4 pos:SV_POSITION;
            float2 depth : TEXCOORD0;
            float density:TEXCOORD1;
        };
        vertOut vert(appdata_base v)
        {
            vertOut o;
            o.pos=UnityObjectToClipPos(v.vertex);
            o.depth=o.pos.zw;
            //steam
            // The following code is the same as mul(UNITY_MATRIX_MV, float4(0,0,0,v.vertex.w));
            // to eliminate unity warning.
            float4 ori=mul(UNITY_MATRIX_V, mul(unity_ObjectToWorld, float4(0, 0, 0, v.vertex.w)));
            // float4 posV=mul(UNITY_MATRIX_MV,v.vertex);
            float4 posV=mul(UNITY_MATRIX_V, mul(unity_ObjectToWorld, v.vertex));
            float4 dir=float4(ori-posV);
            float dist=dot(dir.xy,dir.xy);
            //float dist=distance(ori.xy/ori.w,posV.xy/posV.w);
            o.density=_Density/(1+dist);
            o.density=smoothstep(0.1,1,o.density);
            return o;
        }
        float4 frag(vertOut i):COLOR
        {
                //float d=i.depth.x/i.depth.y;
                float d=i.density;
                float4 c=float4(d,d,d,d);//(1-Linear01Depth(d))*100*_Color;
                return c;
        }
        ENDCG
        }//end pass
    }
}