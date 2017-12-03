Shader "Tut/ShaderReplacement/RenderWith/RepShader.t3" {
	Properties {
	_MainTex ("Base", 2D) = "white" {}
	}
	SubShader {
		Tags { "myTag"="green" }
		pass{
		SetTexture[_MainTex] { combine texture }
		}
	}//end subshader
	FallBack Off
}
