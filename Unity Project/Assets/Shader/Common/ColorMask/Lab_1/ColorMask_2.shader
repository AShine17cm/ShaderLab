Shader "Tut/Shader/Common/ColorMask_2" {
Properties {
    _Color ("Main Color", Color) = (1,1,1,1)
}
SubShader {
    // Render normally
	pass{
	color(0,0,0,0)
	}
    Pass {
        ColorMask RG
        Material {
            Diffuse [_Color]
        }
        Lighting On
    }
}
}

