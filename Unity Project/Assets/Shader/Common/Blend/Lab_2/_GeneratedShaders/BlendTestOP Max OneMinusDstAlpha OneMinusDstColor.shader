Shader "Hidden/Shader/Common/BlendTestOp098"
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
            BlendOp Max
            Blend OneMinusDstAlpha OneMinusDstColor
            SetTexture [_SrcTex] { combine texture}
        }
    }
}
