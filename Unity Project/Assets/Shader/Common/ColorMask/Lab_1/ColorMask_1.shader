Shader "Tut/Shader/Common/ColorMask_1" {
Properties {
    _Color ("Main Color", Color) = (1,1,1,1)
}
SubShader {
    Pass {
        ColorMask RG
		Blend One Zero
        Material {
            Diffuse [_Color]
        }
        Lighting On
    }
}
}

