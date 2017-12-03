Shader "Hidden/Shader/Common/BlendTest27" {
    Properties {
        _DstTex ("DstTex", 2D) ="white"{}
        _SrcTex ("SrcTex", 2D) ="white"{}
    }
    SubShader {
        Pass{
            SetTexture[_DstTex] {combine texture}
        }
        Pass {
            Blend SrcColor OneMinusSrcAlpha
            SetTexture [_SrcTex] { combine texture}
        }
    }
}
