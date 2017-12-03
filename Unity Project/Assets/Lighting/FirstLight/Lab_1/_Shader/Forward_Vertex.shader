Shader "Tut/Lighting/FirstLight/Lab_1/Forward_Vertex" {
	Properties{
		_tintVertex("Color of Vertex Lightmode", Color) = (1, 0, 0, 1)
		_tintForward("Color of Forward Lightmode", Color) = (0, 1, 0, 1)
		_tintDeferred("Color of Deferred Lightmode", Color) = (0, 0, 1, 1)
		_dilateVertex("falte amount of Object",range(1,3)) = 1
		_dilateForward("falte amount of Object",range(1,3)) = 1.2
		_dilateDeferred("falte amount of Object",range(1,3)) = 1.4
	}
	SubShader {
		//.2
		pass {
		Tags{ "LightMode" = "Vertex" }
			Blend One One Cull Front
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			struct vertOut {
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
			o.pos = UnityObjectToClipPos(v.vertex*_dilateVertex);
			return o;
		}

		float4 frag(vertOut i) :COLOR
		{
			return _tintVertex;
		}
			ENDCG
	}//end pass
		//.1
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
		

	}
}
