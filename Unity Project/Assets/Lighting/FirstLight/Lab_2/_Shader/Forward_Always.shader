Shader "Tut/Lighting/FirstLight/Lab_2/Forward_Always" {
	Properties{
		_tintAlways("Color of Always",Color)=(1,0,0,1)
		_tintForward("Color of Forward",Color)=(0,1,0,1)
		_tintDeferred("Color of Deferred",Color)=(0,0,1,1)
		_dilateAlways("Dilate of Always",range(1,3))=1
		_dilateForward("Dilate of Forward",range(1,3))=1.2
		_dilateDederred("Dilate of Deferred",range(1,3))=1.4
	}
	SubShader {
		//.1
		pass{
		Tags{ "LightMode"="ForwardBase"}
		Cull Front
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		#include "Lighting.cginc"

		struct vertOut{
			float4 pos:SV_POSITION;
		};
		float4 _tintAlways;
		float4 _tintForward;
		float4 _tintDeferred;
		float _dilateAlways;
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
		//.2
		pass{
		Tags{ "LightMode"="Always"}
		Cull Front
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		#include "Lighting.cginc"

		struct vertOut{
			float4 pos:SV_POSITION;
		};
		float4 _tintAlways;
		float4 _tintForward;
		float4 _tintDeferred;
		float _dilateAlways;
		float _dilateForward;
		float _dilateDeferred;
		vertOut vert(appdata_base v)
		{
			vertOut o;
			o.pos=UnityObjectToClipPos(v.vertex*_dilateAlways);
			return o;
		}
		float4 frag(vertOut i):COLOR
		{
			return _tintAlways;
		}
		ENDCG
		}//end pass
		
		
	}
}
