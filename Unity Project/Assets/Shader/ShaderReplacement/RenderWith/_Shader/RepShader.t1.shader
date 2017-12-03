Shader "Tut/ShaderReplacement/RenderWith/RepShader.t1" {
	Properties {
	_MainTex ("Base", 2D) = "white" {}
	}
	SubShader {
		Tags { "myTag"="white" }
		pass{
		SetTexture[_MainTex] { combine  texture }
		}
	}//end subshader
	FallBack Off
}
