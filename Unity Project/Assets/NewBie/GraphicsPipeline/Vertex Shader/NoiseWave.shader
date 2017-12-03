Shader "Tut/Newbie/Graphics Pipeline/NoiseWave"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white"{}
        _NoiseTex("Noise Texture", 2D) = "white" {}
        _Bump("Bump", 2D) = "bump" {}
        _Color("MainColor", Color) = (1, 1, 1, 1)
    }
    Subshader
    {
        Tags
        {
            "Queue"="Geometry"
            "RenderType"="Opaque"
            "IgnoreProjector"="True"
        }
        Pass
        {
            Tags
            {
                "LightMode"="ForwardBase"
            }
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // texture lod sampling (tex2Dlod) mininum support target 3.0
            #pragma target 3.0
            #pragma multi_compile_fwdbase_fullshadows

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            sampler2D _NoiseTex;
            float4 _NoiseTex_ST;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _Bump;
            fixed4 _Color;

            struct a2v
            {
                float4 vertex : POSITION;
                float4 texcoord : TEXCOORD0;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                fixed2 uv : TEXCOORD0;
                float3 worldNormal : TEXCOORD1;
                float3 worldTangent : TEXCOORD2;
                float3 worldBinormal : TEXCOORD3;
                float3 worldPos : TEXCOORD4;
                LIGHTING_COORDS(5, 6)
                // float3 worldViewDir : TEXCOORD7;
                // fixed3 lightDir : TEXCOORD8;
                // float3 binormal : TEXCOORD9;
            };

            v2f vert(a2v v)
            {
                v2f o;
                v.vertex.xyz += tex2Dlod(_NoiseTex, float4(TRANSFORM_TEX(v.texcoord, _NoiseTex), 0, 0)).r * v.normal;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                // o.worldViewDir = UnityWorldSpaceViewDir(o.worldPos);
                o.worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
                o.worldBinormal = cross(o.worldNormal, o.worldTangent) * v.tangent.w;
                // o.binormal = cross(normalize(v.normal), normalize(v.tangent.xyz)) * v.tangent.w;
                // o.lightDir = mul(float3x3(v.tangent.xyz, o.binormal, v.normal), ObjSpaceLightDir(v.vertex));
                TRANSFER_VERTEX_TO_FRAGMENT(o);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 texColor = tex2D(_MainTex, i.uv) * _Color;
                fixed3 norm = UnpackNormal(tex2D(_Bump, i.uv));
                fixed3 lightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                fixed3 worldNormal = normalize(half3(
                    dot(float3(i.worldTangent.x, i.worldBinormal.x, i.worldNormal.x), norm),
                    dot(float3(i.worldTangent.y, i.worldBinormal.y, i.worldNormal.y), norm),
                    dot(float3(i.worldTangent.z, i.worldBinormal.z, i.worldNormal.z), norm)));
                fixed atten = LIGHT_ATTENUATION(i);
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                fixed3 diffuse = _LightColor0.rgb * saturate(dot(normalize(worldNormal), normalize(lightDir)));
                return fixed4((ambient + diffuse * atten) * texColor, 1.0);
            }
            ENDCG
        }
    }
    Fallback Off
}