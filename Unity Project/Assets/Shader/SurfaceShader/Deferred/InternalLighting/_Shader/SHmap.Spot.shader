// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/SurfaceShader/Deferred/SHmap.Spot" {
   SubShader {
      Pass {    
         Tags { "LightMode" = "ForwardAdd" }
		  Blend Zero One
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
         Tags { "LightMode" = "ForwardBase" } 
         Blend One Zero
          CGPROGRAM
		 #pragma vertex vert  
         #pragma fragment frag 
		 #include "UnityCG.cginc"
		 #include "Lighting.cginc"
		 #include "Autolight.cginc"
		  sampler2D _ShadowMapTexture;
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
		    c = tex2D(_ShadowMapTexture,input.uv);
            return c;
         }
 
         ENDCG
      }
	  }
	FallBack Off
}
