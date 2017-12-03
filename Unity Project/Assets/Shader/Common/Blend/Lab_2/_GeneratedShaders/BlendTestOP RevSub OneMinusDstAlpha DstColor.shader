Shader "Hidden/Shader/Common/BlendTestOp394"
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
            BlendOp RevSub
            Blend OneMinusDstAlpha DstColor
            SetTexture [_SrcTex] { combine texture}
        }
    }
}
