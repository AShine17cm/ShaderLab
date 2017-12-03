Shader "Hidden/Shader/Common/BlendTestOp006"
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
            Blend One OneMinusSrcColor
            SetTexture [_SrcTex] { combine texture}
        }
    }
}
