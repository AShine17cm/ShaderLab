Shader "Tut/Shadow/PlanarShadow_3" {
	Properties{
	_Intensity("atten",range(1,16))=1
	}
	SubShader {
	pass {      
		Tags { "LightMode" = "ForwardBase" }
		Material{Diffuse(1,1,1,1)}
		Lighting On
		}//
	pass {   
		Tags { "LightMode" = "ForwardBase" } 
		Cull Front
		Blend DstColor SrcColor
		Offset -1,-1
		CGPROGRAM
		#pragma vertex vert 
		#pragma fragment frag
		#include "UnityCG.cginc"
		float4x4 _World2Ground;
		float4x4 _Ground2World;
		float _Intensity;
		struct v2f{
			float4 pos:SV_POSITION;
			float atten:TEXCOORD0;
		};
		v2f vert(float4 vertex: POSITION)
		{
			v2f o;
			float3 litDir;
			litDir=normalize(WorldSpaceLightDir(vertex));  
			litDir=mul(_World2Ground,float4(litDir,0)).xyz;
			float4 vt;
			vt= mul(unity_ObjectToWorld, vertex);
			vt=mul(_World2Ground,vt);
			vt.xz=vt.xz-(vt.y/litDir.y)*litDir.xz;
			//上面这行代码可拆解为如下的两行代码，这样子可能在进行三角形相似计算时更好理解
			//vt.x=vt.x-(vt.y/litDir.y)*litDir.x;
			//vt.z=vt.z-(vt.y/litDir.y)*litDir.z;
			vt.y=0;
			vt=mul(_Ground2World,vt);//back to world
			vt=mul(unity_WorldToObject,vt);
			o.pos=UnityObjectToClipPos(vt);
			o.atten=distance(vertex,vt)/_Intensity;
			return o;
		}
 		float4 frag(v2f i) : COLOR 
		{
			return smoothstep(0,1,i.atten/2);
		}
 		ENDCG 
		}//
		pass {   
		Tags { "LightMode" = "ForwardAdd" } 
		Cull Front
		Blend DstColor SrcColor
		Offset -2,-1
		CGPROGRAM
		#pragma vertex vert 
		#pragma fragment frag
		#include "UnityCG.cginc"
		float4x4 _World2Ground;
		float4x4 _Ground2World;
		float _Intensity;
		struct v2f{
			float4 pos:SV_POSITION;
			float atten:TEXCOORD0;
		};
		v2f vert(float4 vertex:POSITION)
		{
			v2f o;
			float3 litDir;
			litDir=normalize(WorldSpaceLightDir(vertex)); 
			litDir=mul(_World2Ground,float4(litDir,0)).xyz;
			float4 vt;
			vt= mul(unity_ObjectToWorld, vertex);
			vt=mul(_World2Ground,vt);
			vt.xz=vt.xz-(vt.y/litDir.y)*litDir.xz;
			vt.y=0;
			vt=mul(_Ground2World,vt);//back to world
			vt=mul(unity_WorldToObject,vt);
			o.pos= UnityObjectToClipPos(vt);
			o.atten=distance(vertex,vt)/_Intensity;
			return o;
		}
 		float4 frag(v2f i) : COLOR 
		{
			return smoothstep(0,1,i.atten*i.atten);
		}
 		ENDCG 
		}
   }
}
