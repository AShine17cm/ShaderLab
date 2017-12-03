Shader "Tut/Shadow/ShadowMapping/ShadowMappingReciever_4" {
	SubShader {
		Tags { "RenderType"="Opaque" "Queue"="Geometry+6000"}
		pass{
		Zwrite off
		ZTest Always
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		
		//sampler2D _myZDepth;
		sampler2D _myShadow;
		float4x4 _myShadowProj;
		
		sampler2D _CameraDepthTexture;
		
		struct vertOut {
			float4 pos:SV_POSITION;
			float4 scrPos:TEXCOORD0;
			float4 texc:TEXCOORD1;
		};
		vertOut vert(appdata_base v)
		{
			vertOut o;
			o.pos=UnityObjectToClipPos(v.vertex);
			o.scrPos=ComputeScreenPos(o.pos);
			
			float4x4 proj;
			proj=mul(_myShadowProj,unity_ObjectToWorld);
			o.texc=mul(proj,v.vertex);
			
			return o;
		}
		float4 frag(vertOut i):COLOR
		{
			float d=tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD(i.scrPos)).r;
			float t=tex2Dproj(_myShadow,i.texc).r;//t already in Linear ,computed in ShadowMapping_4.shader
			//float2 uv=float2(i.scrPos.x/i.scrPos.w,i.scrPos.y/i.scrPos.w);
			//float d=tex2D(_CameraDepthTexture,uv).r;
			d=Linear01Depth(d);
			//d=LinearEyeDepth(d);
			return float4(d,t,0,1);
		}
		ENDCG
		}//endpass
	} 
	//FallBack "Diffuse"
}
