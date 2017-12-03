Shader "Hidden/Shader/Common/BlendTestOp217"
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
            BlendOp Sub
            Blend Zero OneMinusSrcAlpha
            SetTexture [_SrcTex] { combine texture}
        }
    }
}
