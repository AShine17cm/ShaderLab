Shader "Tut/Shader/FixedFuncs/VertexColor_3" {
SubShader {
	pass {
		BindChannels{
			Bind "Vertex",vertex
			Bind "Color",color
		}
		SetTexture[_]{  combine primary	}
	}      
}//en sub
}
