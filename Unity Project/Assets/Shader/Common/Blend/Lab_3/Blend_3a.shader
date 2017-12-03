// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shader/Common/Blend_3a" {
    Properties {
        _Color ("Tint Color", Color) = (1,1,1,1)
        _MainTex ("Base (RGB) Transparency (A)", 2D) = "white" {}
        _Factor("Blend Power",range(0.1,10))=1
        //可以调节near,far来控制混合Blend的开始和结束位置
        near("Blend From near Z",range(0,1))=0
        far("Blend to far Z",range(0,1))=1
    }
    SubShader {
        Tags { "Queue" = "Transparent" }
        Pass {
            Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 pos:SV_POSITION;
				float2 uv:TEXCOORD0;
				float4 scr:TEXCOORD1;
			};
			v2f vert(appdata_full v)
			{
				v2f o;
				o.pos=UnityObjectToClipPos(v.vertex);
				o.uv=v.texcoord.xy;
				o.scr=o.pos;
				return o;
			}
			float _Factor;
			float near;
			float far;
			float4 _Color;
			sampler2D _MainTex;
			sampler2D _CameraDepthTexture;
			
			float4 frag(v2f i):COLOR
			{
				float4 scr=ComputeScreenPos(i.scr);
				float d=tex2D(_CameraDepthTexture,scr.xy/scr.w).r;
				d=Linear01Depth(d);
				float4 c=tex2D(_MainTex,i.uv);
				c.rgb=c.rgb* _Color.rgb;
				float t= d-near;
				t=max(0,t);//保证d小于near时为0
				float t01=t/(far-near);//将t从(near,far)转换，映射到（0,1）域
				c.a=t01;
				c.a=pow(c.a,_Factor);
				return c;
			}
			ENDCG
        }
    }
}
