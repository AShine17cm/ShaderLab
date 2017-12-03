Shader "Tut/Project/ProjS_1" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		pass{
		Tags {"LightMode"="ForwardAdd"}
		Blend One Zero
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		sampler2D _MainTex;
		float4x4 projM2;
		struct v2f {
			float4 pos:SV_POSITION;
			float4 texc:TEXCOORD0;
			float vc:TEXCOORD1;
		};
		v2f vert(appdata_base v)
		{
			float4x4 proj;
			proj=mul(projM2,unity_ObjectToWorld);
			v2f o;
			o.pos=UnityObjectToClipPos(v.vertex);
			o.texc=mul(proj,v.vertex);
			float3 litDir=ObjSpaceLightDir(v.vertex);
			o.vc=max(0,dot(v.normal,normalize(litDir)));
			return o;
		}
		float4 frag(v2f i):COLOR
		{
			float4 c=tex2Dproj(_MainTex,i.texc);
			return c*i.vc;
		}
		ENDCG
		}//endpass
	} 
}
