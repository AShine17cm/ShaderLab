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
		CGPROGRAM
		#pragma surface surf LitModel vertex:vert finalcolor:mycolor  exclude_path:forward
		#pragma only_renderers d3d9
		#pragma debug

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
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
