// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Lab_Zero/ProJ_V_P" {
		Properties {
		_vert("In Vertex",range(0,1))=0
		_frag("In Fragment",range(0,1))=0
		_P("after MVP",range(0,1))=0
		_Scal("scale",range(1,2))=1
	}
	SubShader {
		pass{
	//Tags{"LightMode"="Vertex"}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		float _vert,_frag,_P,_Scal;
		uniform float3 viewPos;
		struct v2f {
			float4 pos:SV_POSITION;
			float4 pjPos:TEXCOORD0;
			float3 c:TEXCOORD1;
		};
		v2f vert (appdata_full v) {
			v2f o;
			o.pos=UnityObjectToClipPos(v.vertex);
			o.pjPos=mul(UNITY_MATRIX_P,float4(viewPos,0));
			o.c=float3(0,0,0);
			o.c.x=o.pjPos.y;
			o.c.y=o.pjPos.y/o.pjPos.w;
			//o.c.z=o.pos.y;
			return o;
		}
		float4 frag(v2f i):COLOR
		{
			return i.c.x*_vert+i.c.y*_frag;
		}
		ENDCG
		}//end Forward Base
	} 
}
