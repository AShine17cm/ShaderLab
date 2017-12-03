Shader "Hidden/Shader/Common/BlendTestOp070"
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
            Blend OneMinusSrcAlpha One
            SetTexture [_SrcTex] { combine texture}
        }
    }
}
