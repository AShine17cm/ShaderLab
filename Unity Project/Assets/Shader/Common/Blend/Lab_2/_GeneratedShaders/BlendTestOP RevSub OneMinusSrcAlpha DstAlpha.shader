Shader "Hidden/Shader/Common/BlendTestOp375"
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
            Blend OneMinusSrcAlpha DstAlpha
            SetTexture [_SrcTex] { combine texture}
        }
    }
}
