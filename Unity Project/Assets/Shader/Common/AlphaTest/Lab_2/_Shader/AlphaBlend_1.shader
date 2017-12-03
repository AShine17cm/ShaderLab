Shader "Tut/Shader/Common/AlphaBlend_1" {
	Properties {
		_DstTex ("Dst Tex", 2D) = "white" {}
		_SrcTex ("Src Tex", 2D) = "white" {}
		_CutOff("_Cut Off",float)=0.5
	}
	SubShader {
		pass{
		//AlphaTest Off
		SetTexture[_DstTex] { combine texture}
		}
		pass{
		Blend SrcAlpha OneMinusSrcAlpha
		AlphaTest GEqual [_CutOff]
		SetTexture[_SrcTex] {combine texture}
		}
	} 
}
