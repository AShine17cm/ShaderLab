Shader "Tut/Effects/ObjMask" {
Subshader {
Tags{"myMask"="obj"}
 Pass {
	CGPROGRAM
	#pragma vertex vert
	#pragma fragment frag
	#include "UnityCG.cginc"
	
	struct v2f {
		float4 pos : POSITION;
	};
	v2f vert( appdata_img v ) 
	{
		v2f o;
		o.pos = UnityObjectToClipPos(v.vertex);
		return o;
	} 
	half4 frag(v2f i) : COLOR 
	{
		return 1;
	}
      ENDCG
  }
}
Fallback off
} // shader