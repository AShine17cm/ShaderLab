Shader "Hidden/Shader/Common/BlendTest63" {
    Properties {
        _DstTex ("DstTex", 2D) ="white"{}
        _SrcTex ("SrcTex", 2D) ="white"{}
    }
    SubShader {
        Pass{
            SetTexture[_DstTex] {combine texture}
        }
        Pass {
            Blend OneMinusSrcColor SrcAlpha
            SetTexture [_SrcTex] { combine texture}
        }
    }
}
