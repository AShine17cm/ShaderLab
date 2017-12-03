Shader "Tut/Newbie/Graphics Pipeline/Fragment Shader Example"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BRDFTex ("BRDF Texture", 2D) = "white" {}
        _Bump("Normal map", 2D) = "bump" {}
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
            "Queue"="Geometry"
        }
        
        LOD 200

        Pass
        {
            Tags
            {
                "LightMode"="ForwardBase"
            }

            CGPROGRAM
            // Physically based Standard lighting model, and enable shadows on all light types
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _BRDFTex;
            fixed4 _Color;
            sampler2D _Bump;
            float4 _Bump_ST;

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                fixed4 texcoord : TEXCOORD0;
                fixed4 tangent : TANGENT;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                fixed4 uv : TEXCOORD0;
                float3 worldNormal : TEXCOORD1;
                float3 worldTangent : TEXCOORD2;
                float3 worldBinormal : TEXCOORD3;
                float3 worldPos : TEXCOORD4;
                float3 worldViewDir : TEXCOORD5;
                LIGHTING_COORDS(6, 7)
            };

            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.worldViewDir = UnityWorldSpaceViewDir(o.worldPos);
                o.worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
                o.worldBinormal = cross(o.worldNormal, o.worldTangent) * v.tangent.w * unity_WorldTransformParams.w;
                o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.uv.zw = TRANSFORM_TEX(v.texcoord, _Bump);
                TRANSFER_VERTEX_TO_FRAGMENT(o);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed3 albedo = tex2D(_MainTex, i.uv.xy).rgb * _Color.rgb;
                // will be fixed3(0, 0, 1.0) if no normal map founded
                fixed3 norm = UnpackNormal(tex2D(_Bump, i.uv.zw));
                fixed3 worldViewDir = normalize(i.worldViewDir);
                // fixed3 worldViewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
                fixed3 lightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                fixed3 worldNormal = normalize(half3(
                    dot(float3(i.worldTangent.x, i.worldBinormal.x, i.worldNormal.x), norm),
                    dot(float3(i.worldTangent.y, i.worldBinormal.y, i.worldNormal.y), norm),
                    dot(float3(i.worldTangent.z, i.worldBinormal.z, i.worldNormal.z), norm)));
                // Same as UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos);
                fixed atten = LIGHT_ATTENUATION(i);
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
                fixed rim = saturate(dot(worldNormal, normalize(worldViewDir)));
                fixed lambert = saturate(dot(worldNormal, lightDir));
                fixed3 ramp = tex2D(_BRDFTex, fixed2(lambert * 0.5 + 0.5, rim)).rgb;
                // add lambert effect to prevent poor shadow effect.
                // you may try this and enable shadow effect instead, then you know why.
                // fixwd3 diffuse = _LightColor0.rgb * albedo * ramp;
                fixed3 diffuse = _LightColor0.rgb * albedo * ramp * lambert;

                return fixed4(ambient + diffuse * atten, 1.0);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
