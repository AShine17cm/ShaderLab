Shader "Hidden/Shader/Common/BlendTestOp269"
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
            Blend OneMinusSrcColor OneMinusDstAlpha
            SetTexture [_SrcTex] { combine texture}
        }
    }
}
