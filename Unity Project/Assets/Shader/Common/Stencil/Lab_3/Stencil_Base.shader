// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shader/Common/Stencil/Stencil_Base" {
	Properties {
		
		_Tex1("Texture 1",2D)="white"{}
		_refVal("Stencil Ref Value",int)=255
	}
	//这个Shader用来
	SubShader {
		Tags{ "RenderType"="Opaque" "Queue"="Geometry"}
		pass{
		Stencil
		{
			Ref [_refVal]
			Comp Always //比较成功条件 
			Pass Replace //条件成立 写入到Stencil
			Fail Keep   //条件不成立 保持Stencil
			ZFail Keep //Z测试失败 保持Stencil
		}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		#include "Lighting.cginc"

		sampler2D _Tex1;

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
		float4 frag(v2f i):COLOR
		{
			float4 c=tex2D(_Tex1,i.uv);
			return c*i.diff;
		}
		ENDCG
		}//end pass
	
	}
}
