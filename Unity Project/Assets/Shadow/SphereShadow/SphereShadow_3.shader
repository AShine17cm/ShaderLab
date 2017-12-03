// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shadow/SphereShadow_3" {
	Properties {
		_spPos ("Sphere Position", vector) = (0,0,0,1)
		_spR ("Sphere Radius", float) = 1
		_Intensity("Intensity Of Shadow",range(0,1))=0.5
	}
	SubShader {
		pass{
		Tags{"LightMode"="ForwardBase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			float4 _spPos;
			float _spR;
			float _Intensity;
			float4 _LightColor0;
			struct v2f{
				float4 pos:SV_POSITION;
				float3 litDir:TEXCOORD0;
				float3 spDir:TEXCOORD1;
				float4 vc:TEXCOORD2;
			};
		v2f vert(appdata_base v)
		{
			v2f o;
			o.pos=UnityObjectToClipPos(v.vertex);
			o.litDir=WorldSpaceLightDir(v.vertex);
			o.spDir=(_spPos-mul(unity_ObjectToWorld,v.vertex)).xyz;

			float3 ldir=ObjSpaceLightDir(v.vertex);
			ldir=normalize(ldir);
			o.vc=_LightColor0*max(0,dot(ldir,v.normal));
			return o;
		}
		float4 frag(v2f i):COLOR
		{
			float3 litDir=normalize(i.litDir);
			float3 spDir=i.spDir;
			float spDistance=length(spDir);
			spDir=normalize(spDir);

			float cosV=dot(spDir,litDir);
			float sinV=sin(acos(max(0,cosV)));
			float D=sinV*spDistance;
			float shadow=step(_spR,D);//spR>D 0,else 1
			float atten=pow((D/_spR),4);
			float c=lerp(1-_Intensity,1,min(1,shadow+atten));//0 is dark  //*step(0,dot(i.N,litDir))
			return i.vc*c;
		}
		ENDCG
		}//endpass
		pass{
		Tags{"LightMode"="ForwardAdd"}
			Blend One One
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			float4 _spPos;
			float _spR;
			float _Intensity;
			float4 _LightColor0;
			struct v2f{
				float4 pos:SV_POSITION;
				float3 litDir:TEXCOORD0;
				float3 spDir:TEXCOORD1;
				float4 vc:TEXCOORD2;
			};
		v2f vert(appdata_base v)
		{
			v2f o;
			o.pos=UnityObjectToClipPos(v.vertex);
			o.litDir=WorldSpaceLightDir(v.vertex);
			o.spDir=(_spPos-mul(unity_ObjectToWorld,v.vertex)).xyz;

			float3 ldir=ObjSpaceLightDir(v.vertex);
			float atten=1/(1+length(ldir));
			ldir=normalize(ldir);
			o.vc=_LightColor0*max(0,dot(ldir,v.normal))*atten;
			return o;
		}
		float4 frag(v2f i):COLOR
		{
			float litAtten=length(i.litDir);
			float3 litDir=normalize(i.litDir);

			float3 spDir=i.spDir;
			float spDistance=length(spDir);
			spDir=normalize(spDir);
			
			float cosV=dot(spDir,litDir);
			float sinV=sin(acos(max(0,cosV)));
			float D=sinV*spDistance;
			float shadow=step(0,D-_spR);//spR>D 0,else 1
			float atten=pow((D/_spR),4);
			float c=lerp(1-_Intensity,1,min(1,shadow+atten));//0 is dark  //*step(0,dot(i.N,litDir))//
			return c*i.vc;
		}
		ENDCG
		}//endpass
	} 
}
