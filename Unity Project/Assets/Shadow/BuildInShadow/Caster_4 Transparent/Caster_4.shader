// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shadow/BuildInShadow/Caster_4" {
Properties {
	_MainTex("MainTex",2D)="white"{}
	_NoiseTex("NoiseTex",2D)="white"{}
    _v("v value",range(0,12))=0.2
	 _h("v value",range(0,2))=0.2
}

SubShader {
	//normal pass to render object
		pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
	
			struct vertOut {
				float4 oPos:SV_POSITION;
			};
			vertOut vert(appdata_base v)
			{
				vertOut o;
				float4 pos=UnityObjectToClipPos(v.vertex);
				o.oPos=pos;
				return o;
			}
			float4 frag(vertOut i):COLOR
			{
				float4 c;
				c=float4(0.3,0.3,0.3,0.3);
				c.g=0.6;
				return c;
			}
			ENDCG
		}
    // Pass to render object as a shadow caster
    pass {
       Name "ShadowCaster"
       Tags { "LightMode" = "ShadowCaster" }

       Fog {Mode Off}
       ZWrite On ZTest Less Cull Off
       //Offset [_ShadowBias], [_ShadowBiasSlope]

		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma multi_compile SHADOWS_NATIVE SHADOWS_CUBE
		#pragma fragmentoption ARB_precision_hint_fastest
		#include "UnityCG.cginc"
		
		sampler2D _NoiseTex;
		float _v;
		float _h;
		float4x4 _Object2Light;
		struct v2f { 
		    //V2F_SHADOW_CASTER;
		    float4 pos : SV_POSITION; 
		    float4 hpos : TEXCOORD1;
		    float3 vec : TEXCOORD0;
		    float2 uv:TEXCOORD2;
			float toC:TEXCOORD3;
		};
		
		v2f vert( appdata_base v )
		{
		    v2f o;
		    //TRANSFER_SHADOW_CASTER(o)
		    float4 vPos=v.vertex;
		    o.vec = mul( unity_ObjectToWorld, vPos).xyz - _LightPositionRange.xyz;//顶点到光源的距离
		    o.pos = UnityObjectToClipPos(vPos);
		    //
		    o.pos.z += unity_LightShadowBias.x; 
			//o.pos.z+=(1/(1+200*length(o.vec)));
		    float clamped = max(o.pos.z, -o.pos.w);
		    o.pos.z = lerp(o.pos.z, clamped, unity_LightShadowBias.y); 
		    o.hpos = o.pos;
		    o.uv=v.texcoord.xy;
			//
			float4 vp=mul(_Object2Light,vPos);
			float4 vc=mul(_Object2Light,float4(0,0,0,1));
			o.toC=length(vp-vc);
		    return o;
		}
		
		float4 frag( v2f i ) : COLOR
		{
		    //SHADOW_CASTER_FRAGMENT(i)
		    //float4 c=tex2D(_MainTex,i.uv);
		    //return EncodeFloatRGBA( length(i.vec) *( _LightPositionRange.w)*_v*c.a);//.............
			float4 c=tex2D(_NoiseTex,i.uv*50);
			float toL=length(i.vec);
			float toC=i.toC;
			//toC=toC*toL;
			//toC=1/(0.1+toC*toC*toC);
			float blur=c.r;
			//blur=exp(-(toC*toC))*5*blur;
			blur=exp(-(blur*blur))*5/blur;
			float4 sh=EncodeFloatRGBA(toL*blur*_v*toC);
			//float4 sh=EncodeFloatRGBA(toL  *( _LightPositionRange.w)*blur*_v*toC);
			//float4 sh=EncodeFloatRGBA(toL *( _LightPositionRange.w)*_v*toC);
			return sh;
		}
		ENDCG

    }//endpass
	}
}

