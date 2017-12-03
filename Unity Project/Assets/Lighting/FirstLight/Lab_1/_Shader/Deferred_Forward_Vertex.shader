// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Lighting/FirstLight/Lab_1/Deferred_Forward_Vertex" {
	Properties{
		_tintVertex("Color of Vertex Lightmode",Color) = (1,0,0,1)
		_tintForward("Color of Forward Lightmode",Color) = (0,1,0,1)
		_tintDeferred("Color of Deferred Lightmode",Color) = (0,0,1,1)
		_dilateVertex("falte amount of Object",range(1,3)) = 1
		_dilateForward("falte amount of Object",range(1,3)) = 1.2
		_dilateDeferred("falte amount of Object",range(1,3)) = 1.4
	}
	SubShader {
		//.1
		pass{
		Tags{ "LightMode"="Vertex"}
		Blend One Zero Cull Front
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		#include "Lighting.cginc"

		struct vertOut{
			float4 pos:SV_POSITION;
		};
		float4 _tintVertex;
		float4 _tintForward;
		float4 _tintDeferred;
		float _dilateVertex;
		float _dilateForward;
		float _dilateDeferred;
		vertOut vert(appdata_base v)
		{
			vertOut o;
			o.pos=UnityObjectToClipPos(v.vertex*_dilateVertex);
			return o;
		}
		float4 frag(vertOut i):COLOR
		{
			return _tintVertex;
		}
		ENDCG
		}//end pass
		//.2
		pass{
		Tags{ "LightMode"="ForwardBase"}
		Blend One One Cull Front
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		#include "Lighting.cginc"

		struct vertOut{
			float4 pos:SV_POSITION;
		};
		float4 _tintVertex;
		float4 _tintForward;
		float4 _tintDeferred;
		float _dilateVertex;
		float _dilateForward;
		float _dilateDeferred;
		vertOut vert(appdata_base v)
		{
			vertOut o;
			o.pos=UnityObjectToClipPos(v.vertex*_dilateForward);
			return o;
		}

		float4 frag(vertOut i):COLOR
		{
			return _tintForward;
		}
		ENDCG
		}//end pass
		//.3
		Cull Front
		CGPROGRAM
		#pragma surface surf MyDeferred vertex:vert
		half4 LightingMyDeferred(SurfaceOutput s, half3 light,half atten)
		{
			half4 c;
			c.rgb = s.Albedo;
			c.a = s.Alpha;
			return c;
		}

		struct Input {
			float2 uv_MainTex;
		};
		sampler2D _MainTex;
		float4 _tintVertex;
		float4 _tintForward;
		float4 _tintDeferred;
		float _dilateVertex;
		float _dilateForward;
		float _dilateDeferred;
		void vert(inout appdata_full v)
		{
			v.vertex = v.vertex*_dilateDeferred;
		}
		void surf (Input IN, inout SurfaceOutput o) {
			o.Albedo = _tintDeferred.rgb;
			o.Alpha = _tintDeferred.a;
		}
		ENDCG
		//Deferred
	}
}
