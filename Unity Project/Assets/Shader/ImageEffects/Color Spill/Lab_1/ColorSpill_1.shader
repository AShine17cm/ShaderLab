// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shader/Image Effects/ColorSpill_1" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "" {}
	}
Subshader {
 Pass {
	  ZTest Always Cull Off ZWrite Off
	  Fog { Mode off }      
	CGPROGRAM
	#pragma fragmentoption ARB_precision_hint_fastest
	#pragma vertex vert
	#pragma fragment frag
	#pragma glsl
	#pragma target 3.0
	#include "UnityCG.cginc"
	struct v2f {
		float4 pos : POSITION;
		float2 uv : TEXCOORD0;
	};
	float4 offsets;
	sampler2D _MainTex;
	sampler2D _CameraDepthNormalsTexture;
	float4 _MainTex_TexelSize;
	v2f vert (appdata_img v) {
		v2f o;
		o.pos = UnityObjectToClipPos(v.vertex);
		o.uv.xy = v.texcoord.xy;
		return o;  
	}
	float4 SamPoint(float2 uv,float2 dir,int s,float atten,float3 pN,float pD,float4 pc)
	{
		float4 samC=0;
		//采样的点的偏移步幅，以一个像素为单位
		float2 off=dir*float2(_MainTex_TexelSize.x,_MainTex_TexelSize.y)*(s+1)*4;
		//采样点的颜色
		samC=tex2D(_MainTex,uv+off);
		//对采样点应用基于距离的衰减因数，使采样点越远，其对当前点影响越小
		samC=samC*atten;
		//取得采样点的Z深度和法线
		float samD=0;
		float3 samN=0;
		float4 enc=tex2D(_CameraDepthNormalsTexture,uv+off);
		DecodeDepthNormal(enc,samD,samN);
		//基于采样点的Normal法线和当前点的法线，做一个点积，用来衡量采样点对当前点的影响程度
		float diff=1-dot(pN,samN);
		//float att=length(off);
		//计算采样点和当前点的Z深度值的差
		float take=pD-samD;
		float dx=abs(take)*3.15;
		
		dx=cos(dx)+1;
		dx=smoothstep(0,2,dx)/2;
		//只有当采样点位于当前点的前面时，才会对当前的点产生影响
		dx=dx*step(0,-take);
		//计算最终的经过距离衰减，法线垂直度，以及Z深度排除的最终的采样点对被采样点的影响
		samC=samC*diff*dx;
		return samC;
	}
	float GetAtten(int s,int steps)
	{
	float atten=(steps-s)/steps+0.5;
	return atten;
	}
	half4 frag (v2f i) : COLOR {
		float4 pc=tex2D (_MainTex, i.uv);
		float D=0;
		float3 N=0;
		//解出当前点的法线和Z深度
		float4 enc=tex2D(_CameraDepthNormalsTexture,i.uv);
		DecodeDepthNormal(enc,D,N);

		half4 cL = float4 (0,0,0,0);
		half4 cR = float4 (0,0,0,0);
		half4 cT = float4 (0,0,0,0);
		half4 cD = float4 (0,0,0,0);
		//对不同的方向进行16次的采样
		for(int s=0;s<16;s++)
		{
		float atten=GetAtten(s,16);

		cL+=SamPoint(i.uv,N.xy*float2(0.7,1),s,atten,N,D,pc);
		cR+=SamPoint(i.uv,N.xy*float2(1.3,1),s,atten,N,D,pc);
		cT+=SamPoint(i.uv,N.xy*float2(1,1.3),s,atten,N,D,pc);
		cD+=SamPoint(i.uv,N.xy*float2(1,0.7),s,atten,N,D,pc);
		}
		cL=cL/12;////
		cR=cR/12;
		cT=cT/12;
		cD=cD/12;
		// 计算平均值 
		float4 c=cL+cR+cT+cD;
		c=c/2;
		return c;
	} 
      ENDCG
  }//blur energy
  //just blur
}
Fallback off
} // shader