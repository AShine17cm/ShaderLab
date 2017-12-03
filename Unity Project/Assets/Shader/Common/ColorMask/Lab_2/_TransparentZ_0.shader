Shader "Tut/Shader/Common/_TransparentZ_0" {
Properties {
    _Color ("Main Color", Color) = (1,1,1,1)
}
SubShader {
  Tags {"RenderType"="Transparent" "Queue"="Transparent"}
    Pass {
		ZWrite On
        ColorMask 0
    }
    Pass {
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha
        ColorMask RGB
        Material {
            Diffuse [_Color]
        }
        Lighting On
    }
}
}

