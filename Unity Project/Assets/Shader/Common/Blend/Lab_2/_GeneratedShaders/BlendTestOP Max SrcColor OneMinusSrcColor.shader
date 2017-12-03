Shader "Hidden/Shader/Common/BlendTestOp026"
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
            Blend SrcColor OneMinusSrcColor
            SetTexture [_SrcTex] { combine texture}
        }
    }
}
