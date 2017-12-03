Shader "Hidden/Shader/Common/BlendTestOp156"
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
            BlendOp Min
            Blend DstAlpha OneMinusSrcColor
            SetTexture [_SrcTex] { combine texture}
        }
    }
}
