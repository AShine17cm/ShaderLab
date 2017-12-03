// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shader/Toon/Cel_2" {
	Properties {
		_ToonMap("Map to Toon",2D)="white"{}
		_Color("Main Color",color)=(1,1,1,1)
		_Outline("Thick of Outline",range(0,0.1))=0.02
		_Factor("Factor",range(0,1))=0.5
		_ToonEffect("Toon Effect",range(0,1))=0.5
	}
	SubShader {
		pass{
		Tags{"LightMode"="Always"}
		Cull Front
		ZWrite On
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		float _Outline;
		float _Factor;
		struct v2f {
			float4 pos:SV_POSITION;
		};

		v2f vert (appdata_full v) {
			v2f o;
			float3 dir=normalize(v.vertex.xyz);
			float3 dir2=v.normal;
			float D=dot(dir,dir2);
			dir=dir*sign(D);
			dir=dir*_Factor+dir2*(1-_Factor);
			v.vertex.xyz+=dir*_Outline;
			o.pos=UnityObjectToClipPos(v.vertex);
			return o;
		}
		float4 frag(v2f i):COLOR
		{
			float4 c=0;
			return c;
		}
		ENDCG
		}//end of pass
		pass{
		Tags{"LightMode"="ForwardBase"}
		Cull Back
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"

		sampler2D _ToonMap;
		float4 _LightColor0;
		float4 _Color;
		float _ToonEffect;

		struct v2f {
			float4 pos:SV_POSITION;
			float3 lightDir:TEXCOORD0;
			float3 viewDir:TEXCOORD1;
			float3 normal:TEXCOORD2;
		};

		v2f vert (appdata_full v) {
			v2f o;
			o.pos=UnityObjectToClipPos(v.vertex);
			o.normal=v.normal;
			o.lightDir=ObjSpaceLightDir(v.vertex);
			o.viewDir=ObjSpaceViewDir(v.vertex);

			return o;
		}
		float4 frag(v2f i):COLOR
		{
			float4 c=1;
			float3 N=normalize(i.normal);
			float3 viewDir=normalize(i.viewDir);
			float3 lightDir=normalize(i.lightDir);
			float diff=max(0,dot(N,i.lightDir));
			diff=(diff+1)/2;
			diff=smoothstep(0,1,diff);
			float toon=tex2D(_ToonMap,float2(diff,diff)).r;
			diff=lerp(diff,toon,_ToonEffect);

			c=_Color*_LightColor0*(diff);
			return c;
		}
		ENDCG
		}//
		pass{
		Tags{"LightMode"="ForwardAdd"}
		Blend One One
		Cull Back
		ZWrite Off
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"

		float4 _LightColor0;
		sampler2D _ToonMap;
		float4 _Color;
		float _ToonEffect;

		struct v2f {
			float4 pos:SV_POSITION;
			float3 lightDir:TEXCOORD0;
			float3 viewDir:TEXCOORD1;
			float3 normal:TEXCOORD2;
		};

		v2f vert (appdata_full v) {
			v2f o;
			o.pos=UnityObjectToClipPos(v.vertex);
			o.normal=v.normal;
			o.viewDir=ObjSpaceViewDir(v.vertex);
			o.lightDir=_WorldSpaceLightPos0-v.vertex;

			return o;
		}
		float4 frag(v2f i):COLOR
		{
			float4 c=1;
			float3 N=normalize(i.normal);
			float3 viewDir=normalize(i.viewDir);
			float dist=length(i.lightDir);
			float3 lightDir=normalize(i.lightDir);
			float diff=max(0,dot(N,i.lightDir));
			diff=(diff+1)/2;
			diff=smoothstep(0,1,diff);
			float atten=1/(dist);
			diff=diff*atten;
			float toon=tex2D(_ToonMap,float2(diff,diff)).r;
			diff=lerp(diff,toon,_ToonEffect);

			half3 h = normalize (lightDir + viewDir);
			float nh = max (0, dot (N, h));
			float spec = pow (nh, 32.0);
			float toonSpec=floor(spec*atten*2)/2;
			spec=lerp(spec,toonSpec,_ToonEffect);
			c=_Color*_LightColor0*(diff+spec);
			return c;
		}
		ENDCG
		}//
	} 
}
