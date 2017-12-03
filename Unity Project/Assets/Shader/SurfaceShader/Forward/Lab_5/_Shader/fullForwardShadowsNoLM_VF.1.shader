// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'
// Upgrade NOTE: replaced tex2D unity_Lightmap with UNITY_SAMPLE_TEX2D
// Upgrade NOTE: replaced tex2D unity_LightmapInd with UNITY_SAMPLE_TEX2D_SAMPLER

Shader "Tut/SurfaceShader/Forward/Lab_5/fullforwardshadowsNoLM_VF" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_BumpMap ("Bumpmap", 2D) = "bump" {}
		_ColorTint ("Tint", Color) = (1.0, 0.6, 0.6, 1.0)
		_FogColor ("Fog Color", Color) = (0.3, 0.4, 0.7, 1.0)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }
		CGPROGRAM
		#pragma vertex vert_surf
		#pragma fragment frag_surf
		#pragma fragmentoption ARB_precision_hint_fastest
		#pragma multi_compile_fwdbase nolightmap nodirlightmap
		#include "HLSLSupport.cginc"
		#define UNITY_PASS_FORWARDBASE
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#include "AutoLight.cginc"

		#define INTERNAL_DATA
		#define WorldReflectionVector(data,normal) data.worldRefl
		#define WorldNormalVector(data,normal) normal
		#pragma target 3.0
		//start surface code
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
			float2 uv_MainTex;
			float2 uv_BumpMap;
			half fog;
			INTERNAL_DATA
		};
		//.1 called in vertex
		void vert (inout appdata_full v, out Input o)//Vertex
		{
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

		}//end surface code
		#ifdef LIGHTMAP_OFF
		struct v2f_surf {
			  float4 pos : SV_POSITION;
			  float4 pack0 : TEXCOORD0;
			  half cust_fog : TEXCOORD1;
			  fixed3 lightDir : TEXCOORD2;
			  fixed3 vlight : TEXCOORD3;
			  float3 viewDir : TEXCOORD4;
			  LIGHTING_COORDS(5,6)
		};
		#endif
		float4 _MainTex_ST;
		float4 _BumpMap_ST;
		v2f_surf vert_surf (appdata_full v) {
			  v2f_surf o;
			  Input customInputData;
			  vert (v, customInputData);
			  o.cust_fog = customInputData.fog;
			  o.pos = UnityObjectToClipPos (v.vertex);
			  o.pack0.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
			  o.pack0.zw = TRANSFORM_TEX(v.texcoord, _BumpMap);
			  #ifndef LIGHTMAP_OFF
			  o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
			  #endif
			  float3 worldN = mul((float3x3)unity_ObjectToWorld, SCALED_NORMAL);
			  TANGENT_SPACE_ROTATION;
			  float3 lightDir = mul (rotation, ObjSpaceLightDir(v.vertex));
			  #ifdef LIGHTMAP_OFF
			  o.lightDir = lightDir;
			  #endif
			  #ifdef LIGHTMAP_OFF
			  float3 viewDirForLight = mul (rotation, ObjSpaceViewDir(v.vertex));
			  o.viewDir = viewDirForLight;
			  #endif
			  #ifdef LIGHTMAP_OFF
			  float3 shlight = ShadeSH9 (float4(worldN,1.0));
			  o.vlight = shlight;
			  #ifdef VERTEXLIGHT_ON
			  float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
			  o.vlight += Shade4PointLights (
				unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
				unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
				unity_4LightAtten0, worldPos, worldN );
			  #endif // VERTEXLIGHT_ON
			  #endif // LIGHTMAP_OFF
			  TRANSFER_VERTEX_TO_FRAGMENT(o);
			  return o;
		}//end vertex
			fixed4 frag_surf (v2f_surf IN) : COLOR {
				  Input surfIN;
				  surfIN.uv_MainTex = IN.pack0.xy;
				  surfIN.uv_BumpMap = IN.pack0.zw;
				  surfIN.fog = IN.cust_fog;
				  SurfaceOutput o;
				  o.Albedo = 0.0;
				  o.Emission = 0.0;
				  o.Specular = 0.0;
				  o.Alpha = 0.0;
				  o.Gloss = 0.0;
				  surf (surfIN, o);
				  fixed atten = LIGHT_ATTENUATION(IN);
				  fixed4 c = 0;
				  #ifdef LIGHTMAP_OFF
				  c = LightingLitModel (o, IN.lightDir, normalize(half3(IN.viewDir)), atten);
				  #endif // LIGHTMAP_OFF
				  #ifdef LIGHTMAP_OFF
				  c.rgb += o.Albedo * IN.vlight;
				  #endif // LIGHTMAP_OFF
				  #ifndef LIGHTMAP_OFF
				  #ifdef DIRLIGHTMAP_OFF
				  fixed4 lmtex = UNITY_SAMPLE_TEX2D(unity_Lightmap, IN.lmap.xy);
				  fixed3 lm = DecodeLightmap (lmtex);
				  #else
				  fixed4 lmtex = UNITY_SAMPLE_TEX2D(unity_Lightmap, IN.lmap.xy);
				  fixed4 lmIndTex = UNITY_SAMPLE_TEX2D_SAMPLER(unity_LightmapInd,unity_Lightmap, IN.lmap.xy);
				  half3 lm = LightingLitModel_DirLightmap(o, lmtex, lmIndTex, 1).rgb;
				  #endif
				  #ifdef SHADOWS_SCREEN
				  #if defined(SHADER_API_GLES) && defined(SHADER_API_MOBILE)
				  c.rgb += o.Albedo * min(lm, atten*2);
				  #else
				  c.rgb += o.Albedo * max(min(lm,(atten*2)*lmtex.rgb), lm*atten);
				  #endif
				  #else // SHADOWS_SCREEN
				  c.rgb += o.Albedo * lm;
				  #endif // SHADOWS_SCREEN
				  c.a = o.Alpha;
				#endif // LIGHTMAP_OFF
				  mycolor (surfIN, o, c);
				  return c;
				}//end fragment
			ENDCG
		}//end forwardbase pass
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardAdd" }
		ZWrite Off Blend One One Fog { Color (0,0,0,0) }
		CGPROGRAM
		#pragma vertex vert_surf
		#pragma fragment frag_surf
		#pragma fragmentoption ARB_precision_hint_fastest
		#pragma multi_compile_fwdadd_fullshadows nolightmap nodirlightmap
		#include "HLSLSupport.cginc"
		#define UNITY_PASS_FORWARDADD
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#include "AutoLight.cginc"

		#define INTERNAL_DATA
		#define WorldReflectionVector(data,normal) data.worldRefl
		#define WorldNormalVector(data,normal) normal
		#pragma target 3.0
		//start surface funcs
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
			float2 uv_MainTex;
			float2 uv_BumpMap;
			half fog;
			INTERNAL_DATA
		};
		//.1 called in vertex
		void vert (inout appdata_full v, out Input o)//Vertex
		{
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
		}//end surface func
		struct v2f_surf {
			  float4 pos : SV_POSITION;
			  float4 pack0 : TEXCOORD0;
			  half cust_fog : TEXCOORD1;
			  half3 lightDir : TEXCOORD2;
			  half3 viewDir : TEXCOORD3;
			  LIGHTING_COORDS(4,5)
		};
		float4 _MainTex_ST;
		float4 _BumpMap_ST;
		v2f_surf vert_surf (appdata_full v) {
			  v2f_surf o;
			  Input customInputData;
			  vert (v, customInputData);
			  o.cust_fog = customInputData.fog;
			  o.pos = UnityObjectToClipPos (v.vertex);
			  o.pack0.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
			  o.pack0.zw = TRANSFORM_TEX(v.texcoord, _BumpMap);
			  TANGENT_SPACE_ROTATION;
			  float3 lightDir = mul (rotation, ObjSpaceLightDir(v.vertex));
			  o.lightDir = lightDir;
			  float3 viewDirForLight = mul (rotation, ObjSpaceViewDir(v.vertex));
			  o.viewDir = viewDirForLight;
			  TRANSFER_VERTEX_TO_FRAGMENT(o);
			  return o;
		}
		fixed4 frag_surf (v2f_surf IN) : COLOR {
			  Input surfIN;
			  surfIN.uv_MainTex = IN.pack0.xy;
			  surfIN.uv_BumpMap = IN.pack0.zw;
			  surfIN.fog = IN.cust_fog;
			  SurfaceOutput o;
			  o.Albedo = 0.0;
			  o.Emission = 0.0;
			  o.Specular = 0.0;
			  o.Alpha = 0.0;
			  o.Gloss = 0.0;
			  surf (surfIN, o);
			  #ifndef USING_DIRECTIONAL_LIGHT
			  fixed3 lightDir = normalize(IN.lightDir);
			  #else
			  fixed3 lightDir = IN.lightDir;
			  #endif
			  fixed4 c = LightingLitModel (o, lightDir, normalize(half3(IN.viewDir)), LIGHT_ATTENUATION(IN));
			  c.a = 0.0;
			  mycolor (surfIN, o, c);
			  return c;
			}//end fragment
		ENDCG
		}//end forwardadd pass
	}//end subshader
	FallBack "Diffuse"
}
