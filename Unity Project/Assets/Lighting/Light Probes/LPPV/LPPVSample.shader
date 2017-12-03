Shader "Tut/LPPVSample"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			#include "UnityStandardUtils.cginc"
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal:NORMAL;//用于确定采样SH的方向
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float3 wldPos:TEXCOORD1;//在worldSpace中采样，确定一个world space的位置
				float3 wldNormal:TEXCOORD2;//使用world space中的法线方向，类似texCube的方式
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.wldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.wldNormal = UnityObjectToWorldNormal(v.normal).xyz;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				half3 currentAmbient = half3(0, 0, 0);
				//采用SH需要用到位置Positon和法线方向Normal
				half3 ambient = ShadeSHPerPixel(i.wldNormal, currentAmbient, i.wldPos);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
