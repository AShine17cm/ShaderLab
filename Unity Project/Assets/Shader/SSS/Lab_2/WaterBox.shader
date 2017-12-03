// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shader/SSS/WaterBox" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Deep("Deep Color of Liquid",Color)=(0,0,0,0)
		_Shallow("Shallow Color of Liquid",Color)=(1,1,1,1)
	}
	SubShader {
        Tags { "RenderType"="Opaque" "Queue"="Geometry+1"}
        //首先正常渲染，并写入到Z Buffer,这将成为水的表面层
        //首先渲染正面，是为了使渲染背面的Z测试条件Greater能通过
		Pass {
        	Blend One Zero
            Cull Back
            ZTest Less
        
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			
           struct v2f{
				float4 pos:SV_POSITION;
				float2 uv:TEXCOORD0;
				float4 diff:TEXCOORD1;
			};
			v2f vert(appdata_full v)
			{
				v2f o;
				o.pos=UnityObjectToClipPos(v.vertex);
				o.uv=v.texcoord.xy;
				float3 L= ObjSpaceLightDir(v.vertex);
				o.diff=max(0,dot(L,v.normal))*_LightColor0;
				return o;
			}
		 	float4 _Shallow;
			float4 frag(v2f i):COLOR
			{
				return i.diff*_Shallow;
			}
            ENDCG
        }
        Pass {
        //然后我们渲染背面，有分层概念的人可能会说，我们不是应该渲染底面，再显然表面么
        //是的，如果这是一幅水彩画的话，的确应该这么做，但是我们为了能够使渲染底面的Z测试条件
        //Greater能在GPU中通过，恐怕不得不首先渲染物体的正面，并且写入到Z缓冲，从而能够使背面正确的被渲染
        	Blend OneMinusDstAlpha DstAlpha
            Cull Front
            ZTest Greater
        	ZWrite off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			
           struct v2f{
				float4 pos:SV_POSITION;
				float2 uv:TEXCOORD0;
				float4 diff:TEXCOORD1;
			};
			v2f vert(appdata_full v)
			{
				v2f o;
				o.pos=UnityObjectToClipPos(v.vertex);
				o.uv=v.texcoord.xy;
				float3 L= ObjSpaceLightDir(v.vertex);
				//因为渲染的是背面，所以需要翻转一下法线
				o.diff=max(0,dot(L,-v.normal))*_LightColor0;
				return o;
			}
		 	float4 _Deep;
            sampler2D _MainTex;
			float4 frag(v2f i):COLOR
			{
				float4 c=tex2D(_MainTex,i.uv);
				return c*i.diff*_Deep;
			}
            ENDCG
        }
	} 
	FallBack "Diffuse"
}
