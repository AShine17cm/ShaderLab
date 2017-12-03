Shader "Hidden/Shader/Common/BlendTestOp293"
{
    Properties {
        _DstTex ("DstTex", 2D) ="white"{}
        _SrcTex ("SrcTex", 2D) ="white"{}
    }
    SubShader {
        Pass{
            SetTexture[_DstTex] {combine texture}
        }
        Pass {
            BlendOp Sub
            Blend OneMinusDstAlpha SrcAlpha
            SetTexture [_SrcTex] { combine texture}
        }
    }
}
