Shader "Tut/ShaderReplacement/RenderWith/RepShader.1" {
	SubShader {
		Tags { "myTag"="white" }
		pass{
		color(1,1,1,1)
		}
	}//end subshader
	SubShader {
		Tags { "myTag"="white" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		float4 _Color;
		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo =float3(1,0,0);// c.rgb*_Color.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack Off
}
