// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shader/Common/Stencil/Stencil_Sphere" {
	Properties {
		
		_Tex1("Texture 1",2D)="white"{}
		_refVal("Stencil Ref Value",int)=0
	}
	//在场景Lab_2中的长方体的Stencil测试条件为大于等于，因此，当一个使用了Stencil比较条件为Always的物体出现在长方体前面时，也就是Z测试成功时，
	//就会使长方体的Stencil测试无法通过,导致如图所示的空洞
	SubShader {
		pass{
		Tags{ "LightMode"="ForwardBase" "RenderType"="Opaque" "Queue"="Geometry+1"}
		ColorMask 0
		Stencil
		{
			Ref  [_refVal]
			Comp GEqual //比较成功条件 大于等于
			Pass Replace //条件成立 写入到Stencil
			Fail keep   //条件不成立 保持Stencil
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
			//return 0;
			float4 c=tex2D(_Tex1,i.uv);
			return c*i.diff;
		}
		ENDCG
		}//end pass
	
	}
}
