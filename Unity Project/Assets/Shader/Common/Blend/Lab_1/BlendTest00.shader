Shader "Tut/Shader/Common/BlendTest00" {
	Properties {
	_DstTex ("DstTex", 2D) ="white"{}
	_SrcTex ("SrcTex", 2D) ="white"{}
	}
	SubShader {
	Pass{
		SetTexture[_DstTex] {combine texture}
	}
	Pass {
		Blend SrcAlpha DstAlpha//
		SetTexture [_SrcTex] { combine texture}
	}
	}
}