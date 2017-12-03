// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Lighting/Forward/Lab_0/ShadeFwdAdd" {
	Properties{

	}
	SubShader {
		pass {
			Tags{ "LightMode" = "ForwardBase" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			struct vertOut {
			float4 pos:SV_POSITION;
			float3 pointLit:COLOR;
			float3 wldLight:TEXCOORD0;
			float3 wldNormal:TEXCOORD1;
			};
			vertOut vert(appdata_full v)
			{
				vertOut o;
				o.pos = UnityObjectToClipPos(v.vertex);
				//取4个点光源的顶点色
				float3 wldPos = mul(unity_ObjectToWorld, v.vertex.xyz).xyz;
				float3 wldNormal = UnityObjectToWorldNormal(v.normal);
				o.pointLit = Shade4PointLights(
					unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,//light positions
					unity_LightColor[0], unity_LightColor[1], unity_LightColor[2], unity_LightColor[3],//light Colors
					unity_4LightAtten0,//attens
					wldPos, wldNormal);
				o.wldLight = WorldSpaceLightDir(v.vertex);
				o.wldNormal = UnityObjectToWorldNormal(v.normal);
				return o;
			}
			float4 frag(vertOut i) :COLOR
			{
				float  diff = max(0, dot(normalize(i.wldNormal),i.wldLight));
				float3 lit = _LightColor0*diff + i.pointLit;
				return float4(lit,1);
			}
			ENDCG
		}//end pass
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
