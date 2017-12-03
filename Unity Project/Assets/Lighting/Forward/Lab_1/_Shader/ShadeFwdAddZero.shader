Shader "Tut/Lighting/Forward/Lab_0/ShadeFwdAddZero" {
	Properties{
	}
	SubShader {
		pass {
			Tags{ "LightMode" = "ForwardAdd" }
				Blend One One
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			struct vertOut {
			float4 pos:SV_POSITION;
			float3 wldLight:TEXCOORD0;
			float3 wldNormal:TEXCOORD1;
			};
			vertOut vert(appdata_full v)
			{
				vertOut o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.wldLight = WorldSpaceLightDir(v.vertex);
				o.wldNormal = UnityObjectToWorldNormal(v.normal);
				return o;
			}
			float4 frag(vertOut i) :COLOR
			{
				float  diff = max(0, dot(normalize(i.wldNormal),i.wldLight));
				float3 lit = _LightColor0*diff;
				return float4(lit,1);
			}
			ENDCG
		}//end pass
	}
}
