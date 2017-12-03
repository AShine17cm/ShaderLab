Shader "Tut/Shader/Common/BlendTest03" {
	Properties {
	_DstTex ("DstTex", 2D) ="white"{}
	_SrcTex ("SrcTex", 2D) ="white"{}
	
	SrcMode("Src Blend Factor",range(0,1))=1
	DstMode("Dst Blend Factor",range(0,1))=0
	}
	SubShader {
	Pass{
		SetTexture[_DstTex] {combine texture}
	}
	Pass {
		Blend [SrcMode][DstMode],DstAlpha zero//
		SetTexture [_SrcTex] { combine texture}
	}
	}
}