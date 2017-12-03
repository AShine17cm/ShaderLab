Shader "Hidden/Shader/Common/BlendTest85" {
    Properties {
        _DstTex ("DstTex", 2D) ="white"{}
        _SrcTex ("SrcTex", 2D) ="white"{}
    }
    SubShader {
        Pass{
            SetTexture[_DstTex] {combine texture}
        }
        Pass {
            Blend OneMinusDstColor DstAlpha
            SetTexture [_SrcTex] { combine texture}
        }
    }
}
