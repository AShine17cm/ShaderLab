Shader "Hidden/Shader/Common/BlendTestOp019"
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
            Blend Zero OneMinusDstAlpha
            SetTexture [_SrcTex] { combine texture}
        }
    }
}
