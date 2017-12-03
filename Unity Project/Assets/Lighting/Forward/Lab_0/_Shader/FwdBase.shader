// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Lighting/Forward/Lab_0/FwdBase" {
	Properties{
		_tintBase("Tint forward base",Color)=(1,0,0,1)
		_tintAddZero("Tint Forward add without base",Color) = (0,0,1,1)
		_tintAdd("Tint Forward add with base",Color)=(0,1,0,1)
		_dilateBase("Dilate of forwardBase",range(1,3))=1.0
		_dilateAddZero("Dilate of forward add without base",range(1,3))=1.2
		_dilateAdd("Dilate of forward add with base",range(1,3))=1.4
	}
	SubShader {
		pass{
		Tags{ "LightMode"="ForwardBase"}
		Cull Front
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma multi_compile_fwdbase
		#include "UnityCG.cginc"
		#include "Lighting.cginc"

		struct vertOut{
			float4 pos:SV_POSITION;
		};
		float4 _tintBase, _tintAddZero, _tintAdd;
		float _dilateBase, _dilateAddZero, _dilateAdd;
		vertOut vert(appdata_base v)
		{
			vertOut o;
			o.pos=UnityObjectToClipPos(v.vertex*_dilateBase);
			return o;
		}
		float4 frag(vertOut i):COLOR
		{
			return _tintBase;
		}
		ENDCG
		}//end pass
	}
}
