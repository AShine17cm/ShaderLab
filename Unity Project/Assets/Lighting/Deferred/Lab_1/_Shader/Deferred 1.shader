Shader "Tut/Lighting/FirstLight/Deferred/Lab_1/Deferred" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		Blend One One

		CGPROGRAM
		#pragma surface surf MyDeferred 
		half4 LightingMyDeferred_PrePass (SurfaceOutput s, half4 light) {
			 half4 c;
            c.rgb = s.Albedo;
            c.a = s.Alpha;
            return c;
		}

		struct Input {
			float2 uv_MainTex;
		};
		sampler2D _MainTex;
		void surf (Input IN, inout SurfaceOutput o) {
			o.Albedo=float3(1,0,0);
		}
		ENDCG
	}
}
