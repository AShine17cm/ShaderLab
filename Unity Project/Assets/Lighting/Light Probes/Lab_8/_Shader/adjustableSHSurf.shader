// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Tut/Lighting/LightProbes/Lab_8/adjustableSHSurf" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_SHfactor("SH factor",float)=1.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert noambient vertex:vert
		sampler2D _MainTex;
		float _SHfactor;

		struct Input {
			float2 uv_MainTex;
			float3 shLight;
		};
		void vert (inout appdata_full v, out Input o) {
             float3 worldN = mul (unity_ObjectToWorld,float4( SCALED_NORMAL,0)).xyz;
            o.shLight = ShadeSH9 (float4 (worldN, 1.0));
			o.uv_MainTex=v.texcoord.xy;
        }
		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Emission=o.Albedo*IN.shLight*_SHfactor;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
