Shader "Tut/Shader/Common/ColorMask_3" {
Properties {
    _Color ("Main Color", Color) = (1,1,1,1)
}
SubShader {
    Pass {
		Blend One OneMinusSrcColor
		ColorMask RG
        Material {
            Diffuse [_Color]
        }
        Lighting On
    }
}
}

