Shader "Tut/Newbie/Graphics Pipeline/Fragment shader example surface version (Directional Light Only)" {
    Properties {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        // _Glossiness ("Smoothness", Range(0,1)) = 0.5
        // _Metallic ("Metallic", Range(0,1)) = 0.0
        _RampTex("Ramp Texture", 2D) = "white" {}
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 200
        
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf BasicDiffuse fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0
        #include "Lighting.cginc"
        #include "AutoLight.cginc"

        sampler2D _MainTex;
        sampler2D _RampTex;

        struct Input {
            float2 uv_MainTex;
        };

        // half _Glossiness;
        // half _Metallic;
        fixed4 _Color;

        inline fixed4 LightingBasicDiffuse(SurfaceOutput s, fixed3 lightDir,  half3 viewDir, fixed atten)
        {
            float lambert  =dot(s.Normal, lightDir);
            float rimLight = dot(s.Normal, viewDir);
            float hLambert = lambert * 0.5 + 0.5;
            float3 ramp = tex2D(_RampTex, float2(hLambert, rimLight)).rgb;

            fixed4 c = fixed4(s.Albedo * _LightColor0.rgb * ramp * atten * lambert, 1.0);
            return c;
        }

        // GI function is required if wanna to use GI, or GI version if this light model.

        // inline fixed4 LightingBasicDiffuse(SurfaceOutput s, half3 viewDir, UnityGI gi)
        // {
        //     float lambert  =dot(s.Normal, gi.light.dir);
        //     float rimLight = dot(s.Normal, viewDir);
        //     float hLambert = lambert * 0.5 + 0.5;
        //     float3 ramp = tex2D(_RampTex, float2(hLambert, rimLight)).rgb;
        // 	   fixed4 c = fixed4(s.Albedo * _LightColor0.rgb * ramp, 1.0);
        // #ifdef UNITY_LIGHT_FUNCTION_APPLY_INDIRECT
        //     c.rgb += s.Albedo * gi.indirect.diffuse;
        // #endif
        //     return c;
        // }
        // inline void LightingBasicDiffuse_GI(SurfaceOutput s, UnityGIInput data, inout UnityGI gi)
        // {
        // 	gi = UnityGlobalIllumination(data, 1.0, s.Normal);
        // }

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        // UNITY_INSTANCING_CBUFFER_START(Props)
            // put more per-instance properties here
        // UNITY_INSTANCING_CBUFFER_END

        void surf (Input IN, inout SurfaceOutput o) {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            // o.Metallic = _Metallic;
            // o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
