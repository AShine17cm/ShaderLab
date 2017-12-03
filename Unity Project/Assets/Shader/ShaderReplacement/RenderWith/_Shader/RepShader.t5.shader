Shader "Tut/ShaderReplacement/RenderWith/RepShader.t5" {
	Properties {
	_MainTex ("Base", 2D) = "white" {}
	}
	SubShader {
		Tags { "myTag"="yellow" }
		pass{
		SetTexture[_MainTex] { combine texture }
		}
	}//end subshader
	FallBack Off
}
