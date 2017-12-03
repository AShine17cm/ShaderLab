Shader "Hidden/Shader/Common/BlendTest98" {
    Properties {
        _DstTex ("DstTex", 2D) ="white"{}
        _SrcTex ("SrcTex", 2D) ="white"{}
    }
    SubShader {
        Pass{
            SetTexture[_DstTex] {combine texture}
        }
        Pass {
            Blend OneMinusDstAlpha OneMinusDstColor
            SetTexture [_SrcTex] { combine texture}
        }
    }
}
