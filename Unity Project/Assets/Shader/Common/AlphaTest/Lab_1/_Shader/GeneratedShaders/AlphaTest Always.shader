Shader "Hidden/Shader/Common/AlphaTest0"
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
            AlphaTest  Always  [_CutOff]
            SetTexture [_SrcTex] { combine texture }
        }
    }
}
