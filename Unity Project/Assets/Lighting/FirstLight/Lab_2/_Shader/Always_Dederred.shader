// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Lighting/FirstLight/Lab_2/Always_Deferred" {
	Properties{
		_tintAlways("Color of Always", Color) = (1, 0, 0, 1)
		_tintForward("Color of Forward", Color) = (0, 1, 0, 1)
		_tintDeferred("Color of Deferred", Color) = (0, 0, 1, 1)
		_dilateAlways("Dilate of Always", range(1, 3)) = 1
		_dilateForward("Dilate of Forward", range(1, 3)) = 1.2
		_dilateDederred("Dilate of Deferred", range(1, 3)) = 1.4
	}
	SubShader {
		Tags{ "RenderType" = "Opaque" }
		pass {
		Tags{ "LightMode" = "Always" }
			Cull Front
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

		struct vertOut {
			float4 pos:SV_POSITION;
		};
		float4 _tintAlways;
		float4 _tintForward;
		float4 _tintDeferred;
		float _dilateAlways;
		float _dilateForward;
		float _dilateDeferred;
		vertOut vert(appdata_base v)
		{
			vertOut o;
			o.pos = UnityObjectToClipPos(v.vertex*_dilateAlways);
			return o;
		}
		float4 frag(vertOut i) :COLOR
		{
			return _tintAlways;
		}
			ENDCG
	}//end pass
		Cull Front
		CGPROGRAM
		#pragma surface surf MyDeferred vertex:vert
		half4 LightingMyDeferred (SurfaceOutput s, half3 light,half atten) {
			 half4 c;
            c.rgb = s.Albedo;
            c.a = s.Alpha;
            return c;
		}

		struct Input {
			float2 uv_MainTex;
		};

		sampler2D _MainTex;
		float4 _tintAlways;
		float4 _tintForward;
		float4 _tintDeferred;
		float _dilateAlways;
		float _dilateForward;
		float _dilateDeferred;
		void vert(inout appdata_full v)
		{
			v.vertex = v.vertex*_dilateDeferred;
		}
		void surf (Input IN, inout SurfaceOutput o) {
			o.Albedo = _tintDeferred.rgb;
			o.Alpha = _tintDeferred.a;
		}
		ENDCG
	}
}
