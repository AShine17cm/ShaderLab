Shader "Tut/Lighting/Surf_Always" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
			_tintAlways("Color of Always",Color) = (1,0,0,1)
			_tintForward("Color of Forward",Color) = (0,1,0,1)
			_tintDeferred("Color of Deferred",Color) = (0,0,1,1)
			_dilateAlways("Dilate of Always",range(1,3)) = 1
			_dilateForward("Dilate of Forward",range(1,3)) = 1.2
			_dilateDederred("Dilate of Deferred",range(1,3)) = 1.4
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		CGPROGRAM
		#pragma surface surf Standard vertex:vert fullforwardshadows 
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;

		float4 _tintAlways;
		float4 _tintForward;
		float4 _tintDeferred;
		float _dilateAlways;
		float _dilateForward;
		float _dilateDeferred;

		void vert(inout appdata_full v)
		{
			v.vertex.xyz*=_dilateDeferred;
		}
		void surf (Input IN, inout SurfaceOutputStandard o) {

			o.Albedo = _tintDeferred.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = _tintDeferred.a;
		}
		ENDCG
	}
	FallBack Off
}
