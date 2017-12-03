// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shader/Bumpy/Parallax_0" {
	Properties {
		//_BumpMap("BumpMap",2D)="white"{}
		_MainTex("MainTex",2D)="white"{}
		_ParallaxMap("Displacement Map(A)",2D)="white"{}
		_Parallax("Displacement Amount",range(0,1))=0.05
	}
	SubShader {
		pass{
		Tags{"LightMode"="ForwardBase"}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		float4 vert(appdata_base v):SV_POSITION
		{
			return UnityObjectToClipPos(v.vertex);
		}
		float4 frag(float4 pos:POSITION):COLOR
		{
			return float4(0,0,0, 0);
		}
		ENDCG
		}
		pass{
		Tags{"LightMode"="ForwardAdd"}
		Blend One One
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"

		float4 _LightColor0;
		sampler2D _MainTex;
		//sampler2D _BumpMap;
		sampler2D _ParallaxMap;
		float4 _MainTex_ST;
		float _Parallax;
		//float4 _BumpMap_ST;
		struct v2f {
			float4 pos:SV_POSITION;
			float2 uv:TEXCOORD0;
			float3 lightDir:TEXCOORD1;
			float3 viewDir:TEXCOORD2;
			float4 posW:TEXCOORD3;
		};

		v2f vert (appdata_full v) {
			v2f o;
			o.pos=UnityObjectToClipPos(v.vertex);
			o.uv=TRANSFORM_TEX(v.texcoord,_MainTex);

			TANGENT_SPACE_ROTATION;
			o.lightDir=ObjSpaceLightDir(v.vertex);
			o.viewDir=ObjSpaceViewDir(v.vertex);
			o.lightDir=mul(rotation,o.lightDir);
			o.viewDir=mul(rotation,o.viewDir);
			o.posW=mul(unity_ObjectToWorld,v.vertex);
			return o;
		}
		float4 frag(v2f i):COLOR
		{
			float4 c=1;
			float p=tex2D(_ParallaxMap,i.uv).a;
			p = _Parallax *( p*2.0 - 1.0);//to (-1,1)
			float3 v = normalize(i.viewDir);
			float2 offset= p * v.xy;
			i.uv+=offset;
			c=tex2D(_MainTex,i.uv);
			//float3 N=UnpackNormal(tex2D(_BumpMap,i.uv));
			//float diff=max(0,dot(N,i.lightDir));
			float diff=length(i.lightDir);
			float atten=length(_WorldSpaceLightPos0-i.posW);
			atten=1/(1+atten*atten);
			c=c*_LightColor0*diff*atten;
			return c;
		}
		ENDCG
		}
	} 
	FallBack "Diffuse"
}
