Shader "Hidden/Shader/Common/BlendTestOp051"
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
            Blend DstAlpha Zero
            SetTexture [_SrcTex] { combine texture}
        }
    }
}
