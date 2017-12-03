Shader "Hidden/Shader/Common/BlendTestOp285"
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
            Blend OneMinusDstColor DstAlpha
            SetTexture [_SrcTex] { combine texture}
        }
    }
}
