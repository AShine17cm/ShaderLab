Shader "Tut/Shader/FixedFuncs/VertexColor" {
Properties{
    _Color ("Base Color", Color) = (1, 0, 0,1)
}
SubShader {
	pass {
		ColorMaterial AmbientAndDiffuse
		Material{
			Ambient [_Color]
			Diffuse [_Color]
		}
		Lighting On
		SetTexture[_]
		{
		combine primary   double
		}
	}      
}//en sub
}
