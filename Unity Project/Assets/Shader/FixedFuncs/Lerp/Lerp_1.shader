Shader "Tut/Shader/FixedFuncs/Lerp_1" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_bColor("Blue Color",color)=(1,0,0,1)
		_rColor("Red Color",color)=(1,1,1,1)
	}
	SubShader {
		pass{
		material{
			diffuse(1,1,1,1)
			ambient(1,1,1,1)
		}
		Lighting On
		SetTexture[_MainTex]{
			constantColor [_bColor]
			combine previous * constant
		}
		SetTexture[_MainTex]{
			constantColor[_rColor]
			combine previous lerp(texture) constant
		}
		}//endpass
		
	} 
	FallBack "Diffuse"
}
