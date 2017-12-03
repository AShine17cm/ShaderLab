Shader "Hidden/Shader/Common/BlendTestOp399"
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
            Blend OneMinusDstAlpha OneMinusDstAlpha
            SetTexture [_SrcTex] { combine texture}
        }
    }
}
