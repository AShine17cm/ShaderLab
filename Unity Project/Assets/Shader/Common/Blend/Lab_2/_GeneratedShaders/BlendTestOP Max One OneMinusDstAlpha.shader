Shader "Hidden/Shader/Common/BlendTestOp009"
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
            Blend One OneMinusDstAlpha
            SetTexture [_SrcTex] { combine texture}
        }
    }
}
