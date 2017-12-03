Shader "Tut/Rays/Mirror_1" {
Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}
	//_RefTex ("Reflection", 2D) = "white" { TexGen ObjectLinear }
	_RefTex ("Reflection", 2D) = "white" {}
}

SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 100
	
	pass {
        SetTexture[_RefTex] {combine texture }
    }
}
}

