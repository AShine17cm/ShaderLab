#warning Upgrade NOTE: unity_Scale shader variable was removed; replaced 'unity_Scale.w' with '1.0'
// Upgrade NOTE: commented out 'float4 unity_LightmapST', a built-in variable
// Upgrade NOTE: commented out 'sampler2D unity_Lightmap', a built-in variable
// Upgrade NOTE: commented out 'sampler2D unity_LightmapInd', a built-in variable
// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'
// Upgrade NOTE: replaced tex2D unity_Lightmap with UNITY_SAMPLE_TEX2D
// Upgrade NOTE: replaced tex2D unity_LightmapInd with UNITY_SAMPLE_TEX2D_SAMPLER

// Upgrade NOTE: commented out 'float4 unity_ShadowFadeCenterAndType', a built-in variable

Shader "Tut/SurfaceShader/Deferred/Lab_2/DeferredSurf" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_BumpMap ("Bumpmap", 2D) = "bump" {}
		_ColorTint ("Tint", Color) = (1.0, 0.6, 0.6, 1.0)
		_ExtrudeAmt ("Extrude Amount", Range(0,1)) = 0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		Pass {
		Name "PREPASS"
		Tags { "LightMode" = "PrePassBase" }
		Fog {Mode Off}
	CGPROGRAM
	#pragma vertex vert_surf
	#pragma fragment frag_surf
	#pragma fragmentoption ARB_precision_hint_fastest	 nodirlightmap
	//#pragma exclude_renderers d3d11 d3d11_9x
	#include "UnityShaderVariables.cginc"
	#include "HLSLSupport.cginc"
	#define UNITY_PASS_PREPASSBASE
	#include "UnityCG.cginc"
	#include "Lighting.cginc"

	#define INTERNAL_DATA
	#define WorldReflectionVector(data,normal) data.worldRefl
	#define WorldNormalVector(data,normal) normal
	//
		sampler2D _MainTex;
		sampler2D _BumpMap;
		fixed4 _ColorTint;
		float _ExtrudeAmt;
		struct Input {
			float3 viewDir; 
			float4 cc:COLOR;
			float4 screenPos;
			float3 worldPos;
			float3 worldRefl;
			float3 worldNormal;

			float2 uv_MainTex;
			float2 uv_BumpMap;
			INTERNAL_DATA
		};
		void vert (inout appdata_full v, out Input o)//Vertex
		{
			v.vertex.xyz=v.vertex.xyz+v.normal*_ExtrudeAmt;
			o.viewDir=0;
			o.cc=0;
			o.screenPos=0;
			o.worldPos=0;
			o.worldRefl=0;
			o.worldNormal=0;
			o.uv_MainTex=0;
			o.uv_BumpMap=0;
        }
		half4 LightingLitModel_PrePass (SurfaceOutput s, half4 light) //Deferred
		{
			half3 spec = light.a * s.Gloss;
            half4 c;
            c.rgb = (s.Albedo * light.rgb + light.rgb * spec);
            c.a = s.Alpha + Luminance(spec);
            return c;
		}
		void mycolor (Input IN, SurfaceOutput o, inout fixed4 color)//final color modifier
		{
			color *= _ColorTint;
		}
		void surf (Input IN, inout SurfaceOutput o) //Surface
		{
			o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_BumpMap));
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}//end surface func
		struct v2f_surf {
		  float4 pos : SV_POSITION;
		  float2 pack0 : TEXCOORD0;
		  float3 TtoW0 : TEXCOORD1;
		  float3 TtoW1 : TEXCOORD2;
		  float3 TtoW2 : TEXCOORD3;
		};
		float4 _BumpMap_ST;
		v2f_surf vert_surf (appdata_full v) {
		  v2f_surf o;
		  Input customInputData;
		  vert (v, customInputData);
		  o.pos = UnityObjectToClipPos (v.vertex);
		  o.pack0.xy = TRANSFORM_TEX(v.texcoord, _BumpMap);
		  TANGENT_SPACE_ROTATION;
		  o.TtoW0 = mul(rotation, ((float3x3)unity_ObjectToWorld)[0].xyz)*1.0;
		  o.TtoW1 = mul(rotation, ((float3x3)unity_ObjectToWorld)[1].xyz)*1.0;
		  o.TtoW2 = mul(rotation, ((float3x3)unity_ObjectToWorld)[2].xyz)*1.0;
		  return o;
		}
		fixed4 frag_surf (v2f_surf IN) : COLOR {
		  Input surfIN;
		  surfIN.uv_BumpMap = IN.pack0.xy;
		  SurfaceOutput o;
		  o.Albedo = 0.0;
		  o.Emission = 0.0;
		  o.Specular = 0.0;
		  o.Alpha = 0.0;
		  o.Gloss = 0.0;
		  surf (surfIN, o);
		  fixed3 worldN;
		  worldN.x = dot(IN.TtoW0, o.Normal);
		  worldN.y = dot(IN.TtoW1, o.Normal);
		  worldN.z = dot(IN.TtoW2, o.Normal);
		  o.Normal = worldN;
		  fixed4 res;
		  res.rgb = o.Normal * 0.5 + 0.5;
		  res.a = o.Specular;
		  return res;
		}
	ENDCG
	}//end prepassbase
	Pass {
		Name "PREPASS"
		Tags { "LightMode" = "PrePassFinal" }
		ZWrite Off
		CGPROGRAM
		#pragma vertex vert_surf
		#pragma fragment frag_surf
		#pragma fragmentoption ARB_precision_hint_fastest
		#pragma multi_compile_prepassfinal nodirlightmap
		#include "HLSLSupport.cginc"
		#define UNITY_PASS_PREPASSFINAL
		#include "UnityCG.cginc"
		#include "Lighting.cginc"

		#define INTERNAL_DATA
		#define WorldReflectionVector(data,normal) data.worldRefl
		#define WorldNormalVector(data,normal) normal
		sampler2D _MainTex;
		sampler2D _BumpMap;
		fixed4 _ColorTint;
		float _ExtrudeAmt;
		struct Input {
			float3 viewDir; 
			float4 cc:COLOR;
			float4 screenPos;
			float3 worldPos;
			float3 worldRefl;
			float3 worldNormal;

			float2 uv_MainTex;
			float2 uv_BumpMap;
			INTERNAL_DATA
		};
		void vert (inout appdata_full v, out Input o)//Vertex
		{
			v.vertex.xyz=v.vertex.xyz+v.normal*_ExtrudeAmt;
			o.viewDir=0;
			o.cc=0;
			o.screenPos=0;
			o.worldPos=0;
			o.worldRefl=0;
			o.worldNormal=0;
			o.uv_MainTex=0;
			o.uv_BumpMap=0;
        }
		half4 LightingLitModel_PrePass (SurfaceOutput s, half4 light) //Deferred
		{
			half3 spec = light.a * s.Gloss;
            half4 c;
            c.rgb = (s.Albedo * light.rgb + light.rgb * spec);
            c.a = s.Alpha + Luminance(spec);
            return c;
		}
		void mycolor (Input IN, SurfaceOutput o, inout fixed4 color)//final color modifier
		{
			color *= _ColorTint;
		}
		void surf (Input IN, inout SurfaceOutput o) //Surface
		{
			o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_BumpMap));
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}//end surface func
		struct v2f_surf {
		  float4 pos : SV_POSITION;
		  float4 pack0 : TEXCOORD0;
		  float4 screen : TEXCOORD1;
		#ifdef LIGHTMAP_OFF
		  float3 vlight : TEXCOORD2;
		#else
		  float2 lmap : TEXCOORD2;
		#ifdef DIRLIGHTMAP_OFF
		  float4 lmapFadePos : TEXCOORD3;
		#endif
		#endif
		};
		#ifndef LIGHTMAP_OFF
		// float4 unity_LightmapST;
		#ifdef DIRLIGHTMAP_OFF
		// float4 unity_ShadowFadeCenterAndType;
		#endif
		#endif
		float4 _MainTex_ST;
		float4 _BumpMap_ST;
		v2f_surf vert_surf (appdata_full v) {
		  v2f_surf o;
		  Input customInputData;
		  vert (v, customInputData);
		  o.pos = UnityObjectToClipPos (v.vertex);
		  o.pack0.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
		  o.pack0.zw = TRANSFORM_TEX(v.texcoord, _BumpMap);
		  o.screen = ComputeScreenPos (o.pos);
		#ifndef LIGHTMAP_OFF
		  o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
		  #ifdef DIRLIGHTMAP_OFF
			o.lmapFadePos.xyz = (mul(unity_ObjectToWorld, v.vertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w;
			o.lmapFadePos.w = (-mul(UNITY_MATRIX_MV, v.vertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w);
		  #endif
		#else
		  float3 worldN = mul((float3x3)unity_ObjectToWorld, SCALED_NORMAL);
		  o.vlight = ShadeSH9 (float4(worldN,1.0));
		#endif
		  return o;
		}//end vertex func
		sampler2D _LightBuffer;
		#if defined (SHADER_API_XBOX360) && defined (HDR_LIGHT_PREPASS_ON)
		sampler2D _LightSpecBuffer;
		#endif
		#ifndef LIGHTMAP_OFF
		// sampler2D unity_Lightmap;
		// sampler2D unity_LightmapInd;
		float4 unity_LightmapFade;
		#endif
		fixed4 unity_Ambient;
		fixed4 frag_surf (v2f_surf IN) : COLOR {
		  Input surfIN;
		  surfIN.uv_MainTex = IN.pack0.xy;
		  surfIN.uv_BumpMap = IN.pack0.zw;
		  SurfaceOutput o;
		  o.Albedo = 0.0;
		  o.Emission = 0.0;
		  o.Specular = 0.0;
		  o.Alpha = 0.0;
		  o.Gloss = 0.0;
		  surf (surfIN, o);
		  half4 light = tex2Dproj (_LightBuffer, UNITY_PROJ_COORD(IN.screen));
		#if defined (SHADER_API_GLES)
		  light = max(light, half4(0.001));
		#endif
		#ifndef HDR_LIGHT_PREPASS_ON
		  light = -log2(light);
		#endif
		#if defined (SHADER_API_XBOX360) && defined (HDR_LIGHT_PREPASS_ON)
		  light.w = tex2Dproj (_LightSpecBuffer, UNITY_PROJ_COORD(IN.screen)).r;
		#endif
		#ifndef LIGHTMAP_OFF
		#ifdef DIRLIGHTMAP_OFF
		  half3 lmFull = DecodeLightmap (UNITY_SAMPLE_TEX2D(unity_Lightmap, IN.lmap.xy));
		  half3 lmIndirect = DecodeLightmap (UNITY_SAMPLE_TEX2D_SAMPLER(unity_LightmapInd,unity_Lightmap, IN.lmap.xy));
		  float lmFade = length (IN.lmapFadePos) * unity_LightmapFade.z + unity_LightmapFade.w;
		  half3 lm = lerp (lmIndirect, lmFull, saturate(lmFade));
		  light.rgb += lm;
		#else
		  fixed4 lmtex = UNITY_SAMPLE_TEX2D(unity_Lightmap, IN.lmap.xy);
		  fixed4 lmIndTex = UNITY_SAMPLE_TEX2D_SAMPLER(unity_LightmapInd,unity_Lightmap, IN.lmap.xy);
		  half4 lm = LightingLitModel_DirLightmap(o, lmtex, lmIndTex, 1);
		  light += lm;
		#endif
		#else
		  light.rgb += IN.vlight;
		#endif
		  half4 c = LightingLitModel_PrePass (o, light);
		  mycolor (surfIN, o, c);
		  return c;
		}
		ENDCG
		}//end prepassfinal
	}//end subshader
	FallBack "Diffuse"
}
