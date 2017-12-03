// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/SurfaceShader/Forward/Lab_5/fullForwardShadows_Surf" {
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _BumpMap ("Bumpmap", 2D) = "bump" {}
        _ColorTint ("Tint", Color) = (1.0, 0.6, 0.6, 1.0)
        _FogColor ("Fog Color", Color) = (0.3, 0.4, 0.7, 1.0)
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 200
        CGPROGRAM
        #pragma surface surf LitModel exclude_path:prepass 	 vertex:vert finalcolor:mycolor	fullforwardshadows nolightmap
        #pragma target 3.0
        #pragma debug
        #include "UnityCG.cginc"

        sampler2D _MainTex;
        sampler2D _BumpMap;
        fixed4 _ColorTint;
        fixed4 _FogColor;

        struct Input {
            float3 viewDir;
            float4 cc:COLOR;
            float4 screenPos;
            float3 worldPos;
            float3 worldRefl;
            float3 worldNormal;
            //
            float3 shLight;
            float2 uv_MainTex;
            float2 uv_BumpMap;
            half fog;
            INTERNAL_DATA
        };
        //.1 called in vertex
        void vert (inout appdata_full v, out Input o)//Vertex
        {
            // Initialize to zero, get rid of 'vert': output parameter 'o' not completely initialized error.
            // Defined in "HLSLSupport.cginc"
            UNITY_INITIALIZE_OUTPUT(Input, o);

            float4 hpos = UnityObjectToClipPos (v.vertex);
            o.fog = min (1, dot (hpos.xy, hpos.xy) * 0.0);
            o.viewDir=0;
            o.cc=0;
            o.screenPos=0;
            o.worldPos=0;
            o.worldRefl=0;
            o.worldNormal=0;
            o.uv_MainTex=0;
            o.uv_BumpMap=0;
            o.shLight=0;
        }
        //.2 called in fragment
        void surf (Input IN, inout SurfaceOutput o) {
            o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_BumpMap));
            half4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        //.3 called in fragment
        half4 LightingLitModel(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten)//Forward
        {
            #ifndef USING_DIRECTIONAL_LIGHT
            lightDir = normalize(lightDir);
            #endif
            viewDir = normalize(viewDir);
            half3 h = normalize (lightDir + viewDir);
            half diff = max (0, dot (s.Normal, lightDir));
            float nh = max (0, dot (s.Normal, h));
            float3 spec = pow (nh, s.Specular*128.0) * s.Gloss;
            half4 c;
            c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec) * (atten * 2);
            c.a = s.Alpha + _LightColor0.a * Luminance(spec) * atten;
            return c;
        }
        //.4 called in fragment
        void mycolor (Input IN, SurfaceOutput o, inout fixed4 color)//final color modifier
        {
            color *= _ColorTint;
            fixed3 fogColor = _FogColor.rgb;
            #ifdef UNITY_PASS_FORWARDADD
            fogColor = 0;
            #endif
            color.rgb = lerp (color.rgb, fogColor, IN.fog);

        }

        ENDCG
    }
    FallBack "Off"
}
