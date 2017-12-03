Shader "Hidden/Shader/Common/BlendTestOp391"
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
            Blend OneMinusDstAlpha Zero
            SetTexture [_SrcTex] { combine texture}
        }
    }
}
