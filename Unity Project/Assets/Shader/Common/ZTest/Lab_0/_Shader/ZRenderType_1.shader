Shader "Tut/Shader/Common/ZRenderType_1" {
Properties {
    _MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
}
SubShader {
	pass{
		ZTest LEqual
		Material{Diffuse(1,0,0,1)}
		Lighting On
		SetTexture[_MainTex]{combine texture*primary double}
	}
	}
}

