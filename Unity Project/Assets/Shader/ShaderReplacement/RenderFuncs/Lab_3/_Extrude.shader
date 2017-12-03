Shader "Tut/ShaderReplacement/Funcs/_Extrude" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_ExtrudeAmt("Extrude Amount",float)=1
		
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert vertex:vert

		sampler2D _MainTex;
		float _ExtrudeAmt;

		struct Input {
			float2 uv_MainTex;
		};
		void vert(inout appdata_full v,out Input o)
		{
		v.vertex.xyz=v.vertex.xyz+v.normal*_ExtrudeAmt;
		o.uv_MainTex=v.texcoord.xy;
		}
		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
