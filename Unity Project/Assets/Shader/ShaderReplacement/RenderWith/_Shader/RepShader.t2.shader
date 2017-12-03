Shader "Tut/ShaderReplacement/RenderWith/RepShader.t2" {
	Properties {
	_MainTex ("Base", 2D) = "white" {}
	}
	SubShader {
		Tags { "myTag"="red" }
		pass{
		SetTexture[_MainTex] { combine texture }
		}
	}//end subshader
	FallBack Off
}
