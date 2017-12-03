Shader "Tut/Organize/UsePass/UseBLUE" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		UsePass "Tut/Organize/UsePass/MyPasses/BLUE"
	} 
}
