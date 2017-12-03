Shader "Tut/Newbie/Graphics Pipeline/Hard Edge"
{
    Properties
    {
        _Color("Color", Color) = (1, 1, 1, 1)
        _MainTex("Main Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
            "Queue"="Geometry"
        }
        Pass
        {
            Tags
            {
                "LightMode"="ForwardAdd"
            }
            Blend One One

            CGPROGRAM
            // Geometry shader requires at least target 4.0
            #pragma multi_compile_fwdadd_fullshadows
            #pragma target 4.0
            #pragma vertex vert
            #pragma geometry geom
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            struct a2v
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
            };

            // vertex and geometry shader shares the same struct
            // because we have to transferm _ShadowCoord and _LightCoord (from LIGHTING_COORDS(A, B))
            // when we dont know whether these two parameters exist or not.
            struct v2gng2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float4 worldPos : TEXCOORD1;
                float3 faceNormal : TEXCOORD2;
                LIGHTING_COORDS(3, 4)
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _Color;

            v2gng2f vert(a2v v)
            {
                v2gng2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                // this parameter do nothing in vertex shader.
                // Assign it with zero.
                o.faceNormal = float3(0, 0, 0);
                TRANSFER_VERTEX_TO_FRAGMENT(o);
                return o;
            }

            [maxvertexcount(3)]
            void geom(triangle v2gng2f IN[3], inout TriangleStream<v2gng2f> triStream)
            {
                float3 A = IN[1].worldPos.xyz - IN[0].worldPos.xyz;
                float3 B = IN[2].worldPos.xyz - IN[0].worldPos.xyz;
                float3 fn = normalize(cross(A, B));

                v2gng2f o;

                o = IN[0];
                o.faceNormal = fn;
                triStream.Append(o);

                o = IN[1];
                o.faceNormal = fn;
                triStream.Append(o);

                o = IN[2];
                o.faceNormal = fn;
                triStream.Append(o);
            }

            fixed4 frag(v2gng2f i) : SV_Target
            {
                fixed3 lightDir = UnityWorldSpaceLightDir(i.worldPos);
                fixed3 normalDir = normalize(i.faceNormal);
                fixed diff = saturate(dot(normalDir, lightDir));
                fixed atten = LIGHT_ATTENUATION(i);
                fixed3 albedo = _Color.rgb * tex2D(_MainTex, i.uv);
                fixed3 result = _LightColor0.rgb * albedo * diff * atten;
                return fixed4(result, 1.0);
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}
