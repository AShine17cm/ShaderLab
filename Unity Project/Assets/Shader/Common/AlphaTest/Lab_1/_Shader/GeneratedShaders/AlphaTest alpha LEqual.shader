Shader "Hidden/Shader/Common/AlphaTest_alpha_5"
{
    Properties {
        _DstTex ("DstTex", 2D) ="white"{} 
        _SrcTex ("SrcTex", 2D) ="white"{}
        _CutOff ("Cut Off", Float) =0.5
    }
    SubShader {
        Pass{
            SetTexture[_DstTex] { combine texture alpha }
        }
        Pass {
            AlphaTest  LEqual  [_CutOff]
            SetTexture [_SrcTex] { combine texture alpha }
        }
    }
}
