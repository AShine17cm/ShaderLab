Shader "Tut/Project/ProjS_2x" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		pass{
		Tags { "LightMode"="ForwardAdd" }
		Blend One Zero
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		sampler2D _MainTex;
		struct v2f {
			float4 pos:SV_POSITION;
			float4 texc:TEXCOORD0;
			float vc:TEXCOORD1;
		};
		v2f vert(appdata_base v)
		{
			v2f o;
			o.pos=UnityObjectToClipPos(v.vertex);
			float4 sp=o.pos*0.5;
			sp.xy = float2(sp.x, sp.y*_ProjectionParams.x) + sp.w;
			sp.zw=o.pos.zw;
			o.texc=sp;
			float3 litDir=ObjSpaceLightDir(v.vertex);
			o.vc=max(0,dot(v.normal,normalize(litDir)));
			return o;
		}
		float4 frag(v2f i):COLOR
		{
			//float4 c=tex2Dproj(_MainTex,UNITY_PROJ_COORD(i.texc));
			float4 c=tex2Dproj(_MainTex,i.texc);
			return c*i.vc;
		}
		ENDCG
		}//endpass
	} 
}
