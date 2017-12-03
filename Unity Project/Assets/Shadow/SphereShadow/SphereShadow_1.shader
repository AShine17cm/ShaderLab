// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shadow/SphereShadow_1" {
	Properties {
		_spPos ("Sphere Position", vector) = (0,0,0,1)
		_spR ("Sphere Radius", float) = 1
		_Intensity("Intensity Of Shadow",range(0,1))=0
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
			float c=lerp(1-_Intensity,1,shadow);//0 is dark  //*step(0,dot(i.N,litDir))
			return i.vc*c;
		}
		ENDCG
		}//endpass
	} 
}
