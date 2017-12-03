Shader "Tut/NewBie/FirstShader" {
    Properties {
        _MyTexture ("Texture (RGB)", 2D) = "white" {}
        _MyColor("Color of Object",Color)=(1,1,1,1)
        _MyCube("Environment map",Cube)="white"{}
        _MyVector("Vector",vector)=(1,1,1,1)
        _MyFloat("Float Value",float)=1.0
        _MyRange("Another type of float",range(-13,14))=1.0
    }
    SubShader {
        Tags{"Queue"="Geometry" "RenderType"="Opaque" "IgnoreProjector"="True"}
        pass{
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MyTexture;
            float4 _MyColor;
            samplerCUBE _MyCube;
            float4 _MyVector;
            float _MyFloat;
            float _MyRange;

            uniform float4x4 myMatrix;
            float4 vert(float4 v:POSITION):SV_POSITION
            {
                // Newbie instruction:
                // In this shader, the following line is equivelent as
                // float pos = mul(UNITY_MATRIX_MVP, *);
                // to transfer the axix from object to clip view.
                // The reason is that Unity may consider performance and platform suitable.
                // This function is defined at UnityInstancing.cginc, which will be included automatically
                // When you try to include UnityCG.cginc.
                // Versions former than Unity 5.6 should support this as well
                // But Unity 5.6 will automatically replace this code, along with a comment "Upgrade NOTE..." at the first line of this shader.
                float pos = UnityObjectToClipPos(v);

                return pos;
            }
            fixed4 frag(void):COLOR
            {
                return fixed4(1, 1, 1, 1);
            }
            ENDCG
        }
    } 
    FallBack "Diffuse"
}
