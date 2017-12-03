Shader "Tut/Shader/ShaderReplacement/RenderQueue/ChangeQueue" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Color("Base Color",color)=(1,1,1,1)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		ZTest Always
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		float4 _Color;
		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb*_Color.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
