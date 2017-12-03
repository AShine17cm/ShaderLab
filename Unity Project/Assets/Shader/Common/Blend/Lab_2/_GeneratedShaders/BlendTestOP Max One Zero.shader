Shader "Hidden/Shader/Common/BlendTestOp001"
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
            Blend One Zero
            SetTexture [_SrcTex] { combine texture}
        }
    }
}
