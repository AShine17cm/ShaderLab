Shader "Tut/ExamEditor_1" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_RangeVal("Range Value",range(0,10))=1
		_IntVal("Interger",int)=1
	}
	SubShader {
		Tags { "RenderType"="Opaque" "Queue"="Geometry"}
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
	//使用自定义的材质编辑器
	CustomEditor "ExamEditor_1"
}
