//This original shader comes from here:
//http://wiki.unity3d.com/index.php?title=Shadow_Volumes_in_Alpha
Shader "Tut/Shadow/ShadowVolume/Extrusion" {
Properties {
	_Extrusion ("Extrusion", Range(0,30)) = 5.0
}
SubShader {
	Tags { "Queue" = "Transparent+10" }
	// Draw front faces, doubling the value in alpha channel
	pass {
		Blend DstColor One
		Cull Back ZWrite Off ColorMask A Offset 1,1
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		float _Extrusion;
		// World space light position
		float4 _LightPosition;
		float4 vert(appdata_base v) : POSITION
		{
			// point to light vector
			float4 wldLightPos = _LightPosition;
			float4 wldVex = mul(unity_ObjectToWorld,v.vertex);
			float3 toLight = normalize(wldLightPos.xyz - wldVex.xyz * wldLightPos.w);
			float3 wldNormal = UnityObjectToWorldDir(v.normal);
			float backFactor = dot(toLight, wldNormal);
			float extrude = (backFactor < 0.0) ? 1.0 : 0.0;
			toLight = UnityWorldToObjectDir(toLight);
			v.vertex.xyz -= toLight * (extrude * _Extrusion);
			v.vertex.xyz += v.normal*0.001;
			return UnityObjectToClipPos(v.vertex);
		}
		float4 frag(float4 pos:POSITION) :COLOR
		{
			return float4(1,1,1,1);
		}
			ENDCG
	}//endpass
	
	// Draw back faces, halving the value in alpha channel
	pass {
		Blend DstColor Zero
		Cull Front ZWrite Off ColorMask A Offset 1,1
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		float _Extrusion;
		// World space light position
		float4 _LightPosition;
		float4 vert(appdata_base v) : POSITION
		{
			// point to light vector
			float4 wldLightPos = _LightPosition;
			float4 wldVex = mul(unity_ObjectToWorld,v.vertex);
			float3 toLight = normalize(wldLightPos.xyz - wldVex.xyz * wldLightPos.w);
			float3 wldNormal = UnityObjectToWorldDir(v.normal);
			float backFactor = dot(toLight, wldNormal);
			float extrude = (backFactor < 0.0) ? 1.0 : 0.0;
			toLight = UnityWorldToObjectDir(toLight);
			v.vertex.xyz -= toLight * (extrude * _Extrusion);
			v.vertex.xyz += v.normal*0.001;
			return UnityObjectToClipPos(v.vertex);
		}
		float4 frag(float4 pos:POSITION) :COLOR
		{
			return float4(1,1,1,1)*0.5;
		}
		ENDCG
	}//endpass
} 

FallBack Off
}
