Shader "Tut/Project/GUITex_Cube" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_X("Screen Pos  X",float)=0.0
		_Y("Screen Pos Y",float)=0.0
		_Width("Width",float)=128
		_Height("Height",float)=128
	}
	SubShader {
		//Tags {"Queue"="Overlay"}
		pass{
		//Cull Off
		ZTest Always
		Blend SrcAlpha OneMinusSrcAlpha
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		sampler2D _MainTex;
		float _X;
		float _Y;
		float _Width;
		float _Height;
		struct v2f {
			float4 pos:SV_POSITION;
			float2 texc:TEXCOORD0;
		};
		v2f vert(appdata_base v)
		{
			v2f o;
			o.pos.xy=float2(v.vertex.x+0.5,v.vertex.y+0.5)*2;//to full screen
			//o.pos.xy*=float2(_Width*_ProjectionParams.x/_ScreenParams.x,_Height/_ScreenParams.y);//scale
			//o.pos.xy+=float2(_X/_ScreenParams.x,_Y/_ScreenParams.y*_ProjectionParams.x);//offset pos

			float2 scale=float2(_Width/_ScreenParams.x,_Height/_ScreenParams.y);//to fit size
			float2 offset=float2(_X/_ScreenParams.x,_Y/_ScreenParams.y)*2;//to fit pos
			o.pos.xy=o.pos.xy*scale-offset;//scale
			o.pos.x*=_ProjectionParams.x;
			o.pos.zw=float2(0,1);
			o.texc=v.texcoord;
			return o;
		}
		float4 frag(v2f i):COLOR
		{
			return tex2D(_MainTex,i.texc);
		}
		ENDCG
		}//endpass
	} 
}
