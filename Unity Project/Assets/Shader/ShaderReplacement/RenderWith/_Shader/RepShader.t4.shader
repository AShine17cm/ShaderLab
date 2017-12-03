Shader "Tut/ShaderReplacement/RenderWith/RepShader.t4" {
	Properties {
	_MainTex ("Base", 2D) = "white" {}
	}
	SubShader {
		Tags { "myTag"="blue" }
		pass{
		SetTexture[_MainTex] { combine texture }
		}
	}//end subshader
	FallBack Off
}
