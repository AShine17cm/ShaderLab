// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shader/SSS/FloatObject" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_refVal("Stencil Ref Value",int)=0
		_Deep("Deep Color of Liquid",Color)=(0,0,0,0)
		_Front("Shallow Color of Liquid",Color)=(1,1,1,1)
	}
	SubShader {
	//这是一个为了和WaterBox配合使用，描述漂浮在水面的物体而写的Shader
        Tags { "RenderType"="Opaque" "Queue"="Geometry+2"}
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
		 	float4 _Front;
            sampler2D _MainTex;
			float4 frag(v2f i):COLOR
			{
				float4 c=tex2D(_MainTex,i.uv);
				return c*i.diff*_Front*2;
			}
            ENDCG
        }
        Pass {
        	Blend SrcAlpha OneMinusSrcAlpha
            Cull Back
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
				o.diff=max(0,dot(L,v.normal))*_LightColor0;
				return o;
			}
		 	float4 _Deep;
            sampler2D _MainTex;
			float4 frag(v2f i):COLOR
			{
				float4 c=tex2D(_MainTex,i.uv);
				return c*i.diff*_Deep*2;
			}
            ENDCG
        }
        

	} 
	FallBack "Diffuse"
}
