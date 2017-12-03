Shader "Hidden/Shader/Common/BlendTestOp362"
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
            Blend OneMinusSrcColor SrcColor
            SetTexture [_SrcTex] { combine texture}
        }
    }
}
