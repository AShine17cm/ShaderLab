Shader "Tut/Shader/GrabPass/Grab_3" {
Properties {
        _MainTex ("Base (RGB)", 2D) = "white" { }
    }
    SubShader {
	Tags {"RenderType"="Transparent" "Queue" = "Transparent+300" }
	GrabPass {	"_MyGrab"	}
	pass{
		SetTexture[_MainTex]{ combine texture }
		SetTexture[_MyGrab]{matrix[_MyMatrix] combine texture*previous }
	}//
    }
}