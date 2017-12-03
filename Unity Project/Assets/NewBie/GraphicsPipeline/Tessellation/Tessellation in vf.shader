Shader "Tut/Newbie/Graphics Pipeline/Tessellation"
{
    Properties
    {
        _MainTex("Base (RGB)", 2D) = "white" {}
        _DispTex("Displacement Texture", 2D) = "gray" {}
        _Bump("Bump", 2D) = "bump" {}
        _Displacement("Displacement", Range(0, 1)) = 0.3
        _Specular("Specular", Range(1, 500)) = 250
        _Gloss("Gloss", Range(0, 1)) = 0.2
        _Tessellation("Tessellation", Float) = 2
        _Distance("Tessellation Distance", Range(10, 100)) = 1
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }
        LOD 200

        Pass
        {
            Tags
            {
                "LightMode"="ForwardBase"
            }

            CGPROGRAM

            // Tessellation shader takes effect in geometry stage.
            // Generally #pragma target 4.6 is sufficent for tessellation, add this just in case.
            // #ifdef UNITY_CAN_COMPILE_TESSELLATION
            #pragma vertex vert

            #pragma fragment frag

            #pragma hull hul
            #pragma domain dom

            #pragma multi_compile_fwdbase_fullshadows

            // target 4.6 fits the minimum requirement. Not target 5.0
            // (you may find target 5.0 on many examples from Internet)
            #pragma target 4.6
            #include "UnityCG.cginc"
            #include "Tessellation.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _DispTex;
            sampler2D _Bump;
            float _Specular;
            float _Gloss;
            float _Tessellation;
            float _Distance;
            float _Displacement;

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
                fixed2 uv : TEXCOORD0;
                float3 worldNormal : TEXCOORD1;
                float3 worldTangent : TEXCOORD2;
                float3 worldBinormal : TEXCOORD3;
                float3 worldPos : TEXCOORD4;
                float3 worldViewDir : TEXCOORD5;
                // equals to a _LightCoord : TEXCOORD6; \ b _ShadowCoord : TEXCOORD7;
                // the two variables are not always necessary according to your settings
                // for example, if no shadow, then no _ShadowCoord
                // a b might be float3 or float4 dependently.
                LIGHTING_COORDS(6, 7)
                // fixed3 lightDir : TEXCOORD8;
                // float3 binormal : TEXCOORD9;
            };

            struct TessVertex
            {
                float4 vertex : INTERNALTESSPOS;
                fixed4 texcoord : TEXCOORD0;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
            };

            struct OutputPatchConstant
            {
                float edge[3] : SV_TessFactor;
                float inside : SV_InsideTessFactor;
                float3 vTangent[4] : TANGENT;
                float2 vUV[4] : TEXCOORD;
                float3 vTanUCorner[4] : TANUCORNER;
                float3 vTanVCorner[4] : TANVCORNER;
                float4 vCWts : TANWEIGHTS;
            };

            TessVertex vert(a2v v)
            {
                // Tessellation shader will create vertex, so the vertex stage would be calculated there.
                // We cannot use the same struct because of semantic difference.
                TessVertex o;
                o.vertex = v.vertex;
                o.normal = v.normal;
                o.tangent = v.tangent;
                o.texcoord = v.texcoord;
                return o;
            }

            // Copied from Tessellation.cginc.
            // Equal to UnityCalcDistanceTessFactor
            float DistanceTessllationFactor (float4 vertex, float minDist, float maxDist, float tess)
            {
                float3 wpos = mul(unity_ObjectToWorld,vertex).xyz;
                // The _WorldSpaceCameraPos was defined at UnityShaderVariables.cginc
                float dist = distance (wpos, _WorldSpaceCameraPos);
                float f = clamp(1.0 - (dist - minDist) / (maxDist - minDist), 0.01, 1.0) * tess;
                return f;
            }

            // Copied from Tessellation.cginc.
            // Equal to UnityCalcTriEdgeTessFactors
            float4 CalculateTriEdgeTessellationFactors (float3 triVertexFactors)
            {
                float4 tess;
                tess.x = 0.5 * (triVertexFactors.y + triVertexFactors.z);
                tess.y = 0.5 * (triVertexFactors.x + triVertexFactors.z);
                tess.z = 0.5 * (triVertexFactors.x + triVertexFactors.y);
                tess.w = (triVertexFactors.x + triVertexFactors.y + triVertexFactors.z) / 3.0f;
                return tess;
            }

            OutputPatchConstant hullconst(InputPatch<TessVertex, 3> v)
            {
                OutputPatchConstant o = (OutputPatchConstant)0;
                // The following code equals to this line
                // float4 ts = UnityDistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, 10, _Distance, _Tessellation);
                float4 ts = CalculateTriEdgeTessellationFactors(float3(
                    DistanceTessllationFactor (v[0].vertex, 10, _Distance, _Tessellation),
                    DistanceTessllationFactor (v[1].vertex, 10, _Distance, _Tessellation),
                    DistanceTessllationFactor (v[2].vertex, 10, _Distance, _Tessellation)
                ));
                o.edge[0] = ts.x;
                o.edge[1] = ts.y;
                o.edge[2] = ts.z;
                o.inside = ts.w;
                return o;
            }

            // domain should be either tri, quad or isoline.
            [domain("tri")]
            // parititioning should be integer, fractional_odd, fractional_even or pow2
            [partitioning("fractional_odd")]
            // outputtopology should be either point, line, triangle_cw or triangle_ccw
            [outputtopology("triangle_cw")]
            // function_name is the name of a separate function that outputs the patch-constant data.
            [patchconstantfunc("hullconst")]
            // Defines the number of output control points (per thread) that will be created in the hull shader
            // will be the number of times the hull shader will be executed.
            [outputcontrolpoints(3)]
            TessVertex hul(InputPatch<TessVertex, 3> v, uint id : SV_OutputControlPointID)
            {
                return v[id];
            }

            v2f VertexInvokedInDomain(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.worldViewDir = UnityWorldSpaceViewDir(o.worldPos);
                o.worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
                o.worldBinormal = cross(o.worldNormal, o.worldTangent) * v.tangent.w;
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                // The following line equals to TANGENT_SPACE_ROTATION
                // o.binormal = cross(normalize(v.normal), normalize(v.tangent.xyz)) * v.tangent.w;
                // o.lightDir = mul(float3x3(v.tangent.xyz, o.binormal, v.normal), ObjSpaceLightDir(v.vertex));
                // fill in LIGHTING_COORDS(idx1, idx2)
                // requires v.vertex and o.pos (position in clip space) dependently
                TRANSFER_VERTEX_TO_FRAGMENT(o);

                return o;
            }

            // domain should be either tri, quad or isoline.
            [domain("tri")]
            v2f dom(OutputPatchConstant tessFactors, const OutputPatch<TessVertex, 3> vi, float3 barycentrePosition : SV_DomainLocation)
            {
                a2v v;
                v.vertex = vi[0].vertex * barycentrePosition.x + vi[1].vertex * barycentrePosition.y + vi[2].vertex * barycentrePosition.z;
                v.normal = vi[0].normal * barycentrePosition.x + vi[1].normal * barycentrePosition.y + vi[2].normal * barycentrePosition.z;
                v.tangent = vi[0].tangent * barycentrePosition.x + vi[1].tangent * barycentrePosition.y + vi[2].tangent * barycentrePosition.z;
                v.texcoord = vi[0].texcoord * barycentrePosition.x + vi[1].texcoord * barycentrePosition.y + vi[2].texcoord * barycentrePosition.z;
                // Using displacement texture to adjust verticies.
                float d = tex2Dlod(_DispTex, v.texcoord).r * _Displacement;
                v.vertex.xyz += v.normal * d;
                v2f o = VertexInvokedInDomain(v);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 texColor = tex2D(_MainTex, i.uv);
                fixed3 norm = UnpackNormal(tex2D(_Bump, i.uv));
                fixed3 worldViewDir = normalize(i.worldViewDir);
                fixed3 lightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                fixed3 worldNormal = normalize(half3(
                    dot(float3(i.worldTangent.x, i.worldBinormal.x, i.worldNormal.x), norm),
                    dot(float3(i.worldTangent.y, i.worldBinormal.y, i.worldNormal.y), norm),
                    dot(float3(i.worldTangent.z, i.worldBinormal.z, i.worldNormal.z), norm)));
                fixed atten = LIGHT_ATTENUATION(i);
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                fixed3 diff = _LightColor0.rgb * saturate(dot(normalize(worldNormal), normalize(lightDir)));
                fixed3 lightRefl = reflect(-lightDir, worldNormal);
                fixed3 spec = _LightColor0.rgb * pow(saturate(dot(normalize(lightRefl), normalize(worldViewDir))), _Specular) * _Gloss;
                // fixed3 worldRefl = reflect(-worldViewDir, worldNormal);
                return fixed4(((ambient + (diff + spec) * atten) * texColor), 1.0);
            }

            ENDCG
        }
    }
}