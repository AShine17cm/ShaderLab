Shader "Tut/Project/Projector_1" {
  Properties {
     _MainTex ("Cookie", 2D) = "" { TexGen ObjectLinear }
  }
  Subshader {
     Pass {
        ZWrite off
		Blend DstColor One
        SetTexture [_MainTex] {
		   combine texture
           Matrix [_Projector]
        }
     }
  }
}
