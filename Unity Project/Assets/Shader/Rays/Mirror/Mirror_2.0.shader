Shader "Tut/Rays/Mirror_2.0" {
Properties {
	_RefTex ("Reflection", 2D) = "white" { TexGen ObjectLinear }
}

SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 100
	
	pass {
        SetTexture[_RefTex] { Matrix[_ProjMatrix] combine texture }
    }
}
}

