Shader "Hidden/Shader/Common/BlendTestOp326"
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
            Blend SrcColor OneMinusSrcColor
            SetTexture [_SrcTex] { combine texture}
        }
    }
}
