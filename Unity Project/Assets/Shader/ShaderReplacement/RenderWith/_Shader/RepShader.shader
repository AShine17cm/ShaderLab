Shader "Tut/ShaderReplacement/RenderWith/RepShader" {
	SubShader {
		Tags { "myTag"="white" }
		pass{
		color(1,1,1,1)
		}
	}//end subshader
	SubShader {
		Tags { "myTag"="blue" }
		pass{
		color(1,1,1,1)
		}
	}//end subshader
	SubShader {
		Tags { "myTag"="green" }
		pass{
		color(1,1,1,1)
		}
	}//end subshader
	SubShader {
		Tags { "myTag"="red" }
		pass{
		color(1,1,1,1)
		}
	}//end subshader
	SubShader {
		Tags { "myTag"="yellow" }
		pass{
		color(1,1,1,1)
		}
	}//end subshader  
	FallBack Off
}
