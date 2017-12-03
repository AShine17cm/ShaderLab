Shader "Tut/Shader/GrabPass/Grab_2" {
Properties {
        _MainTex ("Base (RGB)", 2D) = "white" { }
    }
    SubShader {
	Tags {"RenderType"="Transparent" "Queue" = "Transparent+300" }
	GrabPass {	"_MyGrab"	}
	pass{
		SetTexture[_MainTex]{ combine texture }
		SetTexture[_MyGrab]{ combine texture*previous }
	}//
    }
}