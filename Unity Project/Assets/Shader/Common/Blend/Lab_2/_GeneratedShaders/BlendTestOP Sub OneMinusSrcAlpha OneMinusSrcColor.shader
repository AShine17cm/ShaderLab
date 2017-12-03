Shader "Hidden/Shader/Common/BlendTestOp276"
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
            Blend OneMinusSrcAlpha OneMinusSrcColor
            SetTexture [_SrcTex] { combine texture}
        }
    }
}
