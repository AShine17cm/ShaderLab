Shader "Tut/Unity_wiki/DebugShadowVolumeAlpha" {
	SubShader {
		 ColorMask A
		 ZTest Always Cull Off ZWrite Off
		 Pass {
		    Color (0.25,0.25,0.25,0.25)
		 }
		 Pass {
		    Blend DstColor One
		   Color (1,1,1,1)
		 } 
		 Pass {
		    Blend OneMinusDstColor Zero
		    Color (1,1,1,1)
		 } 
		 Pass {
		    Blend One One
		    Color (0.5,0.5,0.5,0.5)
		 } 
		 Pass {
		    ColorMask RGB
		    Blend Zero DstAlpha
		    Color (1,1,1,1)
		 } 
	}
}
