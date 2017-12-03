Shader "Hidden/Shader/Common/BlendTestOp282"
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
            Blend OneMinusDstColor SrcColor
            SetTexture [_SrcTex] { combine texture}
        }
    }
}
