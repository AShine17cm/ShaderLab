// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Lab_Zero/mvp_ed" {

	Properties {
		_X("X",range(0,1))=0
		_Y("Y",range(0,1))=0
		_Z("Z",range(0,1))=0
		_Scal("scale",range(1,10))=1
	}
	SubShader {
		pass{
	//Tags{"LightMode"="Vertex"}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		float _X,_Y,_Z,_Scal;
		uniform float3 viewPos;
		struct v2f {
			float4 pos:SV_POSITION;
			float3 pjPos:TEXCOORD0;
			float c:TEXCOORD1;
		};
		v2f vert (appdata_full v) {
			v2f o;
			o.pos=UnityObjectToClipPos(v.vertex);
			//o.pjPos=mul(UNITY_MATRIX_MVP,float4(viewPos,1));
			o.pjPos=mul(UNITY_MATRIX_P,float4(viewPos,1));
			float c=o.pjPos.x*_X+o.pjPos.y*_Y;
			c=c/_Scal;
			if(c>1) c=0;
			o.c=c;
			return o;
		}
		float4 frag(v2f i):COLOR
		{
		float c=i.pjPos.x*_X+i.pjPos.y*_Y;//-i.pjPos.z*_Z;
		//float c=pjPos.z*_Z;
		//if(pjPos.z>2)
			//c=-1;
			//c=c/_Scal;
			//if(c>1) c=0;
			return i.c;
		}
		ENDCG
		}//end Forward Base
	} 
	//FallBack "Diffuse"
}
