Shader "Tut/NewBie/SecondShader" {
SubShader {
	pass {
		Name "MYM"
		Material{
			Diffuse(1,0.7,0.4,1)
			Ambient(1,0.7,0.4,1)
		}
		Lighting On
		SetTexture[_]{  combine primary	}
	}      
}
}
