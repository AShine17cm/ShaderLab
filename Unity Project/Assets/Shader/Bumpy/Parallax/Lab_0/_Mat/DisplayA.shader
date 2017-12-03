Shader "Tut/Shader/Bumpy/DisplayA" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
	pass{
	SetTexture[_MainTex]{combine texture alpha}
	}
	} 
}
