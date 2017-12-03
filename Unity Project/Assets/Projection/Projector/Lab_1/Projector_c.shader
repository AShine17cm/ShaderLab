Shader "Tut/Projector/Project_c" {
  Properties {
  	  _Color ("Main Color", Color) = (1,1,1,1)   	
     _MainTex ("Cookie", 2D) = "" { TexGen ObjectLinear }
     _FalloffTex ("FallOff", 2D) = "" { TexGen ObjectLinear }
  }
  Subshader {
     Pass {
        ZWrite off
        Fog { Color (0, 0, 0) }
        Color [_Color]
        ColorMask RGB
        Blend DstColor One
		Offset -1, -1
        SetTexture [_MainTex] {
		   combine texture * primary, ONE - texture
           Matrix [_Projector]
        }
        SetTexture [_FalloffTex] {
           constantColor (0,0,0,0)
           combine previous lerp (texture) constant
           Matrix [_ProjectorClip]
        }
     }
  }
}
