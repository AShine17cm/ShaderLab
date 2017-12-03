Shader "Tut/Shader/Common/_TransparentZ_1" {
Properties {
    _Color ("Main Color", Color) = (1,1,1,1)
}
SubShader {
    Tags {"RenderType"="Opaque" "Queue"="Transparent"}
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
		SetTexture[_]{
		Combine primary double
		}
    }
}
}

