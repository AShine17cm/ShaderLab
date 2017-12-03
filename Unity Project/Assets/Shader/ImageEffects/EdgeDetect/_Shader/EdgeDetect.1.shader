Shader "Tut/Effects/EdgeDetect.1" {
Properties {
	_MainTex ("Base (RGB)", RECT) = "white" {}
}
SubShader {
	Pass {
	ZTest Always Cull Off ZWrite Off
	Fog { Mode off }
	CGPROGRAM
	#pragma vertex vert
	#pragma fragment frag
	#include "UnityCG.cginc"

	uniform sampler2D _MainTex;
	uniform float4 _MainTex_TexelSize;
	sampler2D _CameraDepthTexture;
	sampler2D _CameraNormalsTexture;
	struct v2f {
		float4 pos : POSITION;
		float2 uv[4] : TEXCOORD0;
	};

	v2f vert( appdata_img v )
	{
		v2f o;
		o.pos = UnityObjectToClipPos (v.vertex);
		float2 uv = MultiplyUV( UNITY_MATRIX_TEXTURE0, v.texcoord );
		o.uv[0] = uv;
		#if SHADER_API_D3D9
		if (_MainTex_TexelSize.y < 0)
			uv.y = 1-uv.y;
		#endif
		o.uv[1] = uv;
		o.uv[2] = uv + float2(-_MainTex_TexelSize.x, -_MainTex_TexelSize.y);
		o.uv[3] = uv + float2(+_MainTex_TexelSize.x, -_MainTex_TexelSize.y);
		return o;
	}
	half4 frag (v2f i) : COLOR
	{
		half4 original = tex2D(_MainTex, i.uv[0]);//当前位置的像素
		//当前位置的Z深度和法向量
		float centerDepth = UNITY_SAMPLE_DEPTH(tex2D (_CameraDepthTexture, i.uv[1]));
		centerDepth = Linear01Depth(centerDepth);
		float3 centerNormal = tex2D(_CameraNormalsTexture, i.uv[1]) *2.0 - 1.0;

		//左下角的Z深度和法向量
		float d1 = UNITY_SAMPLE_DEPTH(tex2D (_CameraDepthTexture, i.uv[2]));
		d1 = Linear01Depth(d1);
		float3 n1 = tex2D (_CameraNormalsTexture, i.uv[2]) * 2.0 - 1.0;
		//右下角的Z深度和法向量
		float d2 = UNITY_SAMPLE_DEPTH(tex2D (_CameraDepthTexture, i.uv[3]));
		d2 = Linear01Depth(d2);
		float3 n2 = tex2D (_CameraNormalsTexture, i.uv[3]) * 2.0 - 1.0;
		//分别比较它们与当前位置的Z深度和法向量的差异是否大于阈值，在0～1取舍
		half isSameDepth1=abs(d1-centerDepth)<0.05*centerDepth;//0 or 1;
		half isSameDepth2=abs(d2-centerDepth)<0.05*centerDepth;//0 or 1;
		half isSameNormal1=1.0-dot(n1,centerNormal)<0.051;//0 or 1;
		half isSameNormal2=1.0-dot(n2,centerNormal)<0.051;//0 or 1;
		//这4个比较结果为逻辑或，即任何一个成功，都可以判定当前点处于轮廓边缘
		original=original*isSameDepth1*isSameDepth2*isSameNormal1*isSameNormal2;
		return original;
	}
	ENDCG
	}
}

Fallback off

}