Shader "Hidden/Shader/Common/BlendTest72" {
    Properties {
        _DstTex ("DstTex", 2D) ="white"{}
        _SrcTex ("SrcTex", 2D) ="white"{}
    }
    SubShader {
        Pass{
            SetTexture[_DstTex] {combine texture}
        }
        Pass {
            Blend OneMinusSrcAlpha SrcColor
            SetTexture [_SrcTex] { combine texture}
        }
    }
}
