Shader "Tut/SurfaceShader/SurfVertex" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
			_amt("Extrude amount",range(0,1))=0.1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows vertex:vert
		#pragma target 3.0
		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};
		half _Glossiness;
		half _Metallic;
		half _amt;
		fixed4 _Color;

		void vert(inout appdata_full v)
		{
			float4 col = tex2Dlod(_MainTex, float4(v.texcoord.xy, 0, 0)).a;
			v.vertex.xyz = v.vertex.xyz + v.vertex.xyz*col*_amt;
		}
		void surf (Input IN, inout SurfaceOutputStandard o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = 0.5;// c.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
