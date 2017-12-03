Shader "Tut/Shader/Common/BlendTest02" {
	Properties {
	_DstTex ("DstTex", 2D) ="white"{}
	_SrcTex ("SrcTex", 2D) ="white"{}
	}
	SubShader {
	Pass{
		SetTexture[_DstTex] {combine texture}
	}
	Pass {
		Blend One One,DstAlpha zero//
		SetTexture [_SrcTex] { combine texture}
	}
	pass{
	Blend  DstAlpha zero
	color(1,1,1,1)
	}
	}
}