// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Lighting/GI/BlurEnergy_2Blur" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "" {}
	}
Subshader {
 pass {
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
		float2 off=dir*float2(_MainTex_TexelSize.x,_MainTex_TexelSize.y)*(s+1)*4;
		samC=tex2D(_MainTex,uv+off);
		samC=samC*atten;
		//
		float samD=0;
		float3 samN=0;
		float4 enc=tex2D(_CameraDepthNormalsTexture,uv+off);
		DecodeDepthNormal(enc,samD,samN);
		//float diff=1-max(0,dot(pN,samN));
		float diff=1-dot(pN,samN);
		float att=length(off);
		//att=1/(1+att);
		//
		float take=pD-samD;
		float dx=abs(take)*3.15;
		
		dx=cos(dx)+1;
		dx=smoothstep(0,2,dx)/2;
		//dx/=2;
		dx=dx*step(0,-take);
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
		float4 enc=tex2D(_CameraDepthNormalsTexture,i.uv);
		DecodeDepthNormal(enc,D,N);
		//N.xy=normalize(N.xy);
		//N=TransformViewToProjection(N);
		//N.xy=normalize(N.xy)*N.z;
		half4 cL = float4 (0,0,0,0);
		half4 cR = float4 (0,0,0,0);
		half4 cT = float4 (0,0,0,0);
		half4 cD = float4 (0,0,0,0);
		//c +=  tex2D (_MainTex, i.uv);
		for(int s=0;s<16;s++)//16
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
		float4 c=cL+cR+cT+cD;
		//c=c*c;
		c=c/2;
		return c;
		//c=c+pc;
		//c=c/(1+Luminance(c.rgb));
		//return c;
	} 
      ENDCG
  }//blur energy
  //just output
   pass {
	  ZTest Always Cull Off ZWrite Off	  Fog { Mode off }      
	CGPROGRAM
	#pragma fragmentoption ARB_precision_hint_fastest
	#pragma vertex vert
	#pragma fragment frag
	#include "UnityCG.cginc"
	struct v2f {
		float4 pos : POSITION;
		float2 uv : TEXCOORD0;
	};
	sampler2D _MainTex;
	sampler2D _Energy;
	v2f vert (appdata_img v) {
		v2f o;
		o.pos = UnityObjectToClipPos(v.vertex);
		o.uv.xy = v.texcoord.xy;
		return o;  
	}
	
	
	half4 frag (v2f i) : COLOR {
		float4 pc=tex2D (_MainTex, i.uv);
		float4 ec=tex2D(_Energy,i.uv);
		
		//return c;
		ec=ec+pc;
		ec=ec/(1+Luminance(ec.rgb));
		return ec;
	} 
      ENDCG
  }//blur energy
}
Fallback off
} // shader