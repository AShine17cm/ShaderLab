Shader "Custom/Stencil_Cube" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_refVal("Stencil Ref Value",int)=0
	}
	SubShader {
		Tags { "RenderType"="Opaque" "Queue"="Geometry+2"}
		LOD 200
		Stencil
		{
			Ref  [_refVal]
			Comp GEqual //比较成功条件 大于等于
			Pass Replace //条件成立 写入到Stencil
			Fail keep   //条件不成立 保持Stencil
			ZFail Keep //Z测试失败 保持Stencil
			
		}
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
}
