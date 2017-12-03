// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shader/Common/Stencil/Stencil_1" {
	Properties {
		
		_Tex1("Texture 1",2D)="white"{}
		_refVal("Stencil Ref Value",int)=0
	}
	//在Lab_1的场景中，右侧的相机揭示了球体的位置在长方体之后，但是正面的相机看到的球体的却在长方体之前，两个物体使用的是同一个Shader，但是材质参数不同，
	//球体Ref的值更大，而正方体Ref的值小一点，这样子，在渲染的时候，正方体虽然在前面，但是在第一步Stencil测试时,通过与Stencil缓冲区中值比较，会失败，而从不会执行fragment函数，而球体虽然在
	//正方体的后面，但是因为Stencil测试会成功，所以会将其Ref到的更大值写入到Stencil缓冲区中，并且会执行其fragment函数，最后导致的现实结果就是球体被完全渲染，
	//并写入到颜色缓冲区，导致貌似球体在正方体的前面。
	SubShader {
		pass{
		Tags{ "LightMode"="ForwardBase" "Queue"="2"}
		ZTest Always//这意味着我们不用考虑Z测试的结果，我们也没有在此使用到Alpha测试，因此决定一个像素的是否能写入到颜色缓冲区中的就只有Stencil测试了
		Stencil
		{
			Ref [_refVal]
			Comp GEqual //比较成功条件 大于等于
			Pass Replace //条件成立 写入到Stencil
			Fail keep   //条件不成立 保持Stencil
			ZFail keep //Z测试失败 保持Stencil
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
