Shader "Hidden/Shader/Common/AlphaTest5"
{
    Properties {
        _DstTex ("DstTex", 2D) ="white"{} 
        _SrcTex ("SrcTex", 2D) ="white"{}
        _CutOff ("Cut Off", Float) =0.5
    }
    SubShader {
        Pass{
            SetTexture[_DstTex] { combine texture }
        }
        Pass {
            AlphaTest  LEqual  [_CutOff]
            SetTexture [_SrcTex] { combine texture }
        }
    }
}
