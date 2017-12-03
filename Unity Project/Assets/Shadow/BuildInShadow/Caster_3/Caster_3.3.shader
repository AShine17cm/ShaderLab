// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shadow/BuildInShadow/Caster_3.3" {
	Properties {
		_MainTex ("", 2D) = "" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
			pass{
			Tags{ "LightMode"="Vertex"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			sampler2D _MainTex;
			struct vertOut {
				float4 oPos:SV_POSITION;
				float4 color:TEXCOORD0;
				float4 uv:TEXCOORD1;
			};
			vertOut vert(appdata_base v)
			{
				float3 n=(mul(float4(v.normal,0.0),unity_WorldToObject)).xyz;
				n=normalize(n);
	
				float4 lightDir;
				float dist;
				float4 diffColor=float4(0,0,0,0);
				float diff=0;
				float atten=1;
	
				float4 worldSpaceVertex=mul(unity_ObjectToWorld,v.vertex);
	
				//first light,
				//_WorldSpaceLightPos0 is not always been setted;
				lightDir=_WorldSpaceLightPos0-worldSpaceVertex;
				dist=length(lightDir);
				lightDir=normalize(lightDir);
				diff=max(0.0,dot(n,lightDir));
				if(_WorldSpaceLightPos0.w!=0) atten=1/dist;
				//_WorldSpaceLightPos0  and _LightColor0 should be a pair to be used together
				diffColor=_LightColor0*diff*atten;
	
				//four  Lights
				for(int i=0;i<4;i++)
				{
					lightDir=unity_LightPosition[i]-worldSpaceVertex;
					dist=length(lightDir);
					lightDir=normalize(lightDir);
					diff=max(0.0,dot(n,lightDir));
					atten=1/dist;
					diffColor+=unity_LightColor[i]*diff*atten;
				}

				vertOut o;
				o.oPos=UnityObjectToClipPos(v.vertex);
				o.color=diffColor;
				o.uv=o.oPos;
				return o;
			}
			float4 frag(vertOut i):COLOR
			{
			
				return i.color*tex2Dproj(_MainTex,UNITY_PROJ_COORD(i.uv)).r*2;
			}
			ENDCG
		}
	} 
	FallBack "Diffuse"
}
