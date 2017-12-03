Shader "Tut/Shader/Common/_SetShader" {
	Properties {
        _Color ("Main Color", Color) = (1,1,1,0.5)
        _MainTex ("Base (RGB)", 2D) = "white" { }
    }
    SubShader {
		LOD 600
        Pass {
            Material { Diffuse (0,1,0,1)}
            Lighting On
            SetTexture [_MainTex] {Combine texture * primary double}
        }
    }
	 SubShader {
		LOD 500
        Pass {
            Material {Diffuse (1,1,0,1)}
            Lighting On
        }
    }
	SubShader {
		LOD 400
        Pass {
           color(1,0,0,1)
        }
    }
}
