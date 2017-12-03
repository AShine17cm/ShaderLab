Shader "Tut/Shader/FixedFuncs/VertexColor_2" {
Properties{
    _Color ("Base Color", Color) = (1, 0, 0,1)
}
SubShader {
	Pass {
		ColorMaterial Emission
		Material{
			Emission [_Color]
		}
		Lighting On
		SetTexture[_]
		{
		combine primary
		}
	}      
}//en sub
}
