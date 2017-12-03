// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shader/Bumpy/UV_offset_2" {
	Properties {
		_MainTex("MainTex",2D)="white"{}
		_OffsetMap("Displacement Map(A)",2D)="white"{}
		_Offset("Displacement Amount",float)=0.0
	}
	SubShader {
		pass{
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"

		sampler2D _MainTex;
		sampler2D _OffsetMap;
		float4 _MainTex_ST;
		float _Offset;
		struct v2f {
			float4 pos:SV_POSITION;
			float2 uv:TEXCOORD0;
		};

		v2f vert (appdata_full v) {
			v2f o;
			o.pos=UnityObjectToClipPos(v.vertex);
			o.uv=TRANSFORM_TEX(v.texcoord,_MainTex);
			return o;
		}
		float4 frag(v2f i):COLOR
		{
			float4 c=1;
			float p=tex2D(_OffsetMap,float2(i.uv)).a;
			float s =(p*2.0-1.0)*_Offset;
			float2 offset=float2(s,s);
			
			i.uv+=offset;
			c=tex2D(_MainTex,float2(i.uv));
			return c;
		}
		ENDCG
		}
	} 
}
