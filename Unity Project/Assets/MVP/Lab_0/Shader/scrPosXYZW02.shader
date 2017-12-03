// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Lab_Zero/scrPosXYZW01" {
	Properties {
		_X("X",range(0,1))=0
		_Y("Y",range(0,1))=0
		_Z("Z",range(0,1))=0
		_W("W",range(0,1))=0
		_Height("Height of Screen",range(1,600))=600
		_Width("Width of Screen",range(1,800))=800
	}
	SubShader {
		pass{
	//Tags{"LightMode"="Vertex"}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		float _X,_Y,_Z,_W,_Width,_Height;
		struct v2f {
			float4 pos:SV_POSITION;
			float4 pos2:TEXCOORD0;
		};
		v2f vert (appdata_full v) {
			v2f o;
			o.pos=UnityObjectToClipPos(v.vertex);
			o.pos2=ComputeScreenPos(o.pos);
			return o;
		}
		float4 frag(v2f i):COLOR
		{
		//将屏幕空间的位置从(-1,1)变换到(0,1)
			//float c=(i.pos2.x*_X+i.pos2.y*_Y+i.pos2.z*_Z+i.pos2.w*_W)/i.pos2.w;
			float c=(i.pos2.x*_X/_Width+i.pos2.y*_Y/_Height+i.pos2.z*_Z)/i.pos2.w;
			//c=(c+1)/2;
			return c;
		}
		ENDCG
		}//end Forward Base
	} 
	//FallBack "Diffuse"
}
