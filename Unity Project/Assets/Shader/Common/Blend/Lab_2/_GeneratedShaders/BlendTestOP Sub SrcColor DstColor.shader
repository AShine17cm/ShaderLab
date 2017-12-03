Shader "Hidden/Shader/Common/BlendTestOp224"
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
            Blend SrcColor DstColor
            SetTexture [_SrcTex] { combine texture}
        }
    }
}
