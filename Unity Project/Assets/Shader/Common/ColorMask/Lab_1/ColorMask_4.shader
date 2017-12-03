Shader "Tut/Shader/Common/ColorMask_4" {
Properties {
    _Color ("Main Color", Color) = (1,1,1,1)
}
SubShader {
	Tags {"Rendertype"="Opaque" "Queue"="Geometry"}
    pass {
		//color(1,1,1,1)
		Zwrite on
		Blend One Zero
		ColorMask RGB
        Material {
            Diffuse [_Color]
        }
        Lighting On
    }
}
}

