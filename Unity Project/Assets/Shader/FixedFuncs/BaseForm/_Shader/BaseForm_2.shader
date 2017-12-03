Shader "Tut/Shader/FixedFuncs/BaseForm_2" {
	Properties{
		_Val ("Shininess", Range(0, 1)) = 0.5
	}
    SubShader {
		 pass {
            Material {
                Diffuse (1,1,1,1)
                Ambient (1,1,1,1)
                Shininess 0.7
                Specular (1,1,1,1)
                Emission (0.2,0.1,0.1,1)
            }
            Lighting On//vertex lighting
            SeparateSpecular On
            SetTexture [_] {
                constantColor (0,[_Val],0,1)
                Combine constant * primary
            }
			SetTexture [_] {
                Combine previous  QUAD
            }
        }//
    }
}
