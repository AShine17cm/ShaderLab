// Upgrade NOTE: replaced '_LightMatrix0' with 'unity_WorldToLight'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/SurfaceShader/Deferred/LitTexSpot" {
   SubShader {
      Pass {    
         Tags { "LightMode" = "ForwardBase" }
         CGPROGRAM
         #pragma vertex vert  
         #pragma fragment frag 
		 #include "UnityCG.cginc"
         struct v2f {
            float4 pos : SV_POSITION;
         };
          v2f vert(appdata_base v) 
         {
            v2f o;
            o.pos = UnityObjectToClipPos(v.vertex);
            return o;
         }
         float4 frag(v2f input) : COLOR
         {
           return 1;
         }
          ENDCG
      }
	  Pass {    
         Tags { "LightMode" = "ForwardAdd" } 
         Blend One Zero
          CGPROGRAM
		 #pragma vertex vert  
         #pragma fragment frag 
		 #include "UnityCG.cginc"
		 #include "Lighting.cginc"
		 #include "Autolight.cginc"
		  float4x4 unity_WorldToLight;
		  sampler2D _LightTexture0;
         struct v2f {
            float4 pos : SV_POSITION;
            float2 uv : TEXCOORD0;
         };
         v2f vert(appdata_base v) 
         {
            v2f o;
            o.uv =v.texcoord.xy;
            o.pos = UnityObjectToClipPos(v.vertex);
            return o;
         }
          float4 frag(v2f input) : COLOR
         {
             float4 c = 1.0;
            if (0.0 == _WorldSpaceLightPos0.w) // directional light?
            {
			    c = tex2D(_LightTexture0,input.uv);
            }
            else if (1.0 != unity_WorldToLight[3][3]) 
               // spotlight (i.e. not a point light)?
            {
			    c = tex2D(_LightTexture0,input.uv);
            }
 
            return c;
         }
 
         ENDCG
      }
	  }
	FallBack Off
}
