Shader "Hidden/Shader/Common/BlendTestOp370"
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
            Blend OneMinusSrcAlpha One
            SetTexture [_SrcTex] { combine texture}
        }
    }
}
