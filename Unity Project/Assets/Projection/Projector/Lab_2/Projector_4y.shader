Shader "Tut/Project/Projector_4y" {
   Properties {
      _FalloffTex ("FallOff", 2D) = "white" { TexGen ObjectLinear   }
   }

   Subshader {
     // Tags { "RenderType"="Transparent-1" }
      Pass {
         ZWrite Off
         ColorMask RGB
        // Blend DstColor Zero
		 Offset -1, -1
         SetTexture [_FalloffTex] {
            combine texture
            Matrix [_ProjectorClip]
         }
      }
   }
}