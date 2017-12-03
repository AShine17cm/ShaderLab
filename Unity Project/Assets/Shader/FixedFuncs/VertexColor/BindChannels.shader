Shader "Tut/Shader/FixedFuncs/BindChannels" {
SubShader {
	pass {
		BindChannels{
			Bind "Vertex",vertex
			Bind "Normal",normal
			Bind "Color",color
			Bind "Texcoord",texcoord0
			Bind "Texcoord1",texcoord1
		}
		SetTexture[_]{  combine primary	}
	}      
}//en sub
}
