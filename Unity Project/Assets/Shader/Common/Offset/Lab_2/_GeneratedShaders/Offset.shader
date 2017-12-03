Shader "Tut/Shader/Common/Offset_2"
{
    Properties
    {
        _MainTex("Main Tex", 2D) = "white" {}
        _Factor("Offset Factor", Int) = 0
        _Units("Offset Units", Int) = 0
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
            "Queue"="Geometry+300"
        }
        ZWrite Off
        ZTest Greater
        Pass
        {
            Offset [_Factor], [_Units]
            Material
            {
                Diffuse(1, 1, 1, 1)
            }
            Lighting On
            SetTexture [_MainTex] {
                Combine primary * texture
            }
        }
    }
}