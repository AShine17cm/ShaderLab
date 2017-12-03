Shader "Tut/Shader/Common/M" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		pass{
		SetTexture[_MainTex]{combine texture}
		}
	} 
}
