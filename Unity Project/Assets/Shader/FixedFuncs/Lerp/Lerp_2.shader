Shader "Tut/Shader/FixedFuncs/Lerp_2" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Factor("Factor Of Lerp",range(0,1))=0.5
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
			constantColor(0,0,0,[_Factor])
			combine previous lerp(constant) texture
		}
		}//endpass
		
	} 
	FallBack "Diffuse"
}
