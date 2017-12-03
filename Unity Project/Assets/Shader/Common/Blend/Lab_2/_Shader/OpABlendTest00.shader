Shader "Tut/Shader/Common/BlendTest03" {
	Properties {
	_DstTex ("DstTex", 2D) ="white"{}
	_SrcTex ("SrcTex", 2D) ="white"{}
	}
	SubShader {
	Pass{
		SetTexture[_DstTex] {combine texture}
	}
	Pass {
		BlendOp Sub//Min,Max,RevSub
		Blend One One
		SetTexture [_SrcTex] { combine texture}
	}
	Pass{//output Alpha to RGB
	Blend  DstAlpha zero
	color(1,1,1,1)
	}
	}
}