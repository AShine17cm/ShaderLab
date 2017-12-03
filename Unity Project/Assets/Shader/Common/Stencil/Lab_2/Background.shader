// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shader/Common/Stencil/Background" {
	Properties {
		_Background("Back ground of scene",2D)="white"{}
		_refVal("Stencil Ref Value",int)=0
	}
	SubShader {
		pass{
		Tags{ "LightMode"="ForwardBase" "Queue"="Geometry+0"}
		Stencil
		{
			Ref [_refVal]
			Pass Replace
			Fail Replace
			ZFail Replace
		}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		struct v2f{
			float4 pos:SV_POSITION;
			float2 uv:TEXCOORD0;
			//float diff:TEXCOORD1;
		};
		v2f vert(appdata_full v)
		{
			v2f o;
			o.pos=UnityObjectToClipPos(v.vertex);
			o.uv=v.texcoord.xy;
			//float3 L= ObjSpaceLightDir(v.vertex);
			//o.diff=max(0,dot(L,v.normal));
			return o;
		}
		sampler2D _Background;
		float4 frag(v2f i):COLOR
		{
			float4 c=tex2D(_Background,i.uv);
			return c;
		}
		ENDCG
		}//end pass
	
	}
}
