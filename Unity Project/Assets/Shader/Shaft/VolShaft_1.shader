Shader "Tut/Shader/Shaft/VolShaft_1" {
Properties {
	FracTex("Fractral Tex for shaft",2D)="white"{}
	BaseC("Base Color",color)=(1,1,1,1)
	exL ("Extrusion", Range(0,12)) = 5.0
	kP("Factor of Power",float)=1
}
SubShader {
	Tags { "Queue" = "Transparent+10" }
	pass{
		Blend SrcAlpha OneMinusSrcAlpha
		Cull Off ZWrite Off Offset 1,1
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma target 3.0
		#include "UnityCG.cginc"

		struct v2f{
			float4 pos:SV_POSITION;
			float3 objPoint:TEXCOORD0;
			float4 objLitPos:TEXCOORD1;
			float2 uv:TEXCOORD2;
			float exDist : TEXCOORD3;
		};
		float exL;
		float kP;
		float4 litPos;
		float4x4 toW;
		float4x4 toObj;
		v2f vert( appdata_base v ) 
		{
			v2f o;
			// point to light vector
			float4 wldVex = mul(unity_ObjectToWorld, v.vertex);
			float3 toLight = normalize(litPos.xyz - wldVex.xyz * litPos.w);
			float3 wldNormal = UnityObjectToWorldDir(v.normal);
			float backFactor = dot(toLight, wldNormal);
			float extrude = (backFactor < 0.0) ? 1.0 : 0.0;
			toLight = UnityWorldToObjectDir(toLight);
			v.vertex.xyz -= toLight * (extrude * exL);
			v.vertex.xyz += v.normal*0.05;
			o.pos=UnityObjectToClipPos(v.vertex);
			// point to light vector
			o.objLitPos = mul(unity_WorldToObject,litPos);
			o.objPoint=v.vertex.xyz/v.vertex.w;
			o.uv=v.texcoord.xy;
			o.exDist = extrude*exL;
			return o;
		}
		sampler2D FracTex;
		float4 BaseC;
		float4 frag(v2f i):COLOR
		{
			float alp=tex2D(FracTex,i.uv).r;
			float toL=distance(i.objLitPos.xyz,i.objPoint);//像素点到光源的距离

			float dist=toL-exL;//像素点挤出的距离
			float	att=dist/exL;//
			att=1-att;

			float4 c=BaseC*att;
			c.a=pow(att,kP)*BaseC.a*alp;
			return c;
		}
		ENDCG
		}//end pass
} //sub

FallBack Off
}
