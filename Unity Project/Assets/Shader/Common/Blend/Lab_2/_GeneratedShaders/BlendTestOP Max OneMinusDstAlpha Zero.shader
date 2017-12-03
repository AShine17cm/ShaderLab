Shader "Hidden/Shader/Common/BlendTestOp091"
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
            Blend OneMinusDstAlpha Zero
            SetTexture [_SrcTex] { combine texture}
        }
    }
}
