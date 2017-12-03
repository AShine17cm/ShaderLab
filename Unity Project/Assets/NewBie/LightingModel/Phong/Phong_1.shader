// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/NewBie/Phong_1" {
	Properties {
		_MainTex("MainTex",2D)="white"{}
	}
	SubShader {
		pass{
		Tags{"LightMode"="ForwardBase"}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"

		float4 _LightColor0;
		sampler2D _MainTex;
		float4 _MainTex_ST;
		struct v2f {
			float4 pos:SV_POSITION;
			float2 uv:TEXCOORD0;
			float3 lightDir:TEXCOORD1;
			float3 viewDir:TEXCOORD2;
			float3 normal:TEXCOORD3;
		};

		v2f vert (appdata_full v) {
			v2f o;
			o.pos=UnityObjectToClipPos(v.vertex);
			o.uv=TRANSFORM_TEX(v.texcoord,_MainTex);
			
			o.lightDir=ObjSpaceLightDir(v.vertex);
			o.viewDir=ObjSpaceViewDir(v.vertex);
			o.normal=v.normal;
			return o;
		}
		float4 frag(v2f i):COLOR
		{
			i.lightDir=normalize(i.lightDir);
			i.viewDir=normalize(i.viewDir);
			i.normal=normalize(i.normal);

			float4 c=tex2D(_MainTex,i.uv);
			float r=reflect(-i.lightDir,i.normal);
			float spec=max(0,dot(r,i.viewDir));
			spec=pow(spec,32)*4;
			float diff=max(0,dot(i.normal,i.lightDir));

			c=c*_LightColor0*(diff+spec);
			return c;
		}
		ENDCG
		}
	} 
	FallBack "Diffuse"
}
