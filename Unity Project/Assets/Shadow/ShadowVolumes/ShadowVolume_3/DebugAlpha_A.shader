Shader "Tut/Unity_wiki/DebugAlpha_A" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "Queue"="Transparent+10" }
		ZWrite Off
		ColorMask A
		Offset 1,1
		pass{
		Blend One Zero
		SetTexture[_MainTex]{
			combine texture
		}
		}
	} 
	//FallBack "Diffuse"
}
