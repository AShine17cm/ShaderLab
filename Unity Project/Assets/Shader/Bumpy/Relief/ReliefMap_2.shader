// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Tut/Shader/Bumpy/ReliefMap_2" {
	Properties {
		_MainTex("MainTex",2D)="white"{}
		_BumpMap("BumpMap",2D)="white"{}
		_HeightMap("Displacement Map(A)",2D)="white"{}
		_Height("Displacement Amount",range(0,1))=0.05
	}
	SubShader {
		pass{
			Tags{"LightMode"="ForwardBase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma only_renderers d3d9
			#include "UnityCG.cginc"
			float4 vert(appdata_base v):SV_POSITION
			{
				return UnityObjectToClipPos(v.vertex);
			}
			float4 frag(float pos):COLOR
			{
				return 0;
			}
			ENDCG
		}//Forward base
		pass{
		Tags{"LightMode"="ForwardAdd"}
		Blend One One
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma target 3.0
		#pragma only_renderers d3d9
		#include "UnityCG.cginc"

		sampler2D _MainTex;
		sampler2D _BumpMap;
		sampler2D _HeightMap;
		float4 _MainTex_ST;
		float4 _LightColor0;
		float _Height;

		struct v2f {
			float4 pos:SV_POSITION;
			float2 uv:TEXCOORD0;
			float3 lightDir:TEXCOORD1;
			float3 viewDir:TEXCOORD2;
			float4 posW:TEXCOORD3;
		};

		v2f vert (appdata_full v) {
			v2f o;
			o.pos=UnityObjectToClipPos(v.vertex);
			o.uv=TRANSFORM_TEX(v.texcoord,_MainTex);

			TANGENT_SPACE_ROTATION;
			o.lightDir=ObjSpaceLightDir(v.vertex);
			o.viewDir=ObjSpaceViewDir(v.vertex);
			o.lightDir=mul(rotation,o.lightDir);
			o.viewDir=mul(rotation,o.viewDir);
			o.posW=mul(unity_ObjectToWorld,v.vertex);
			return o;
		}
		//depthMap  Brighter pixles presents more deep,
		//heightMap brighter pixles presents more heigh
		//we use Heightmap,brighter pixels more heigh,and so it result to...
		float4 frag(v2f i):COLOR
		{
			//set up ray and initial pixel
			float3 viewRay=normalize(i.viewDir*-1);
			viewRay.z=abs(viewRay.z);
			float3 shadeP=float3(i.uv,0);

			//set up depth bias
			//more steep viewVay, more less uv offset,
			//and steep  related to viewRay.z so : 1-viewRay.z
			//after abs() the viewRay.z is the same direction with normal in TBN space
			float bias=1-viewRay.z;
			bias=1-pow(bias,4);
			viewRay.xy=viewRay.xy*bias*_Height;//apply the element to contrain uv offset amount,which is viewRay.xy
			//
			int linearStep=20;
			int binaryStep=10;
			//first change viewRay to a vector that ranged  in(0,1)
			//after this the viewRay infact dont has the same direction as viewDir,
			//but viewRay.xy still related to the steep amount of viewDir,
			//and viewRay.z=1,so when step from 0 to viewRay.z
			// viewRay.xyz now will intersect with or perice with the (0,1) space that heightMap's alpha(0,1) forms
			float3 offset=(viewRay/viewRay.z)/linearStep;//a step
			for(int i=0;i<linearStep;i++)//liear search
			{
				//shadeP.z step from 0 to 1,from top to down
				//so they will meet
				//we will know if they have met , at the point shadeP.z> d=1-tex2D(_HeightMap) because i use _heightMap, brighter pixel more heighter
				float d=1-tex2D(_HeightMap,shadeP.xy).a;
				if(shadeP.z<d)//
					{
					//shadeP=shadeP+offset;
					shadeP.xy=shadeP.xy+offset.xy;//uv offset
					shadeP.z=shadeP.z+offset.z;//depth step up(0 to 1)
					}
			}
			//
			float3 biOffset=offset;
			for(int i=0;i<binaryStep;i++)
			{
				biOffset=biOffset/2;//every step,narrow the search range by divide it by 2
				float d=1-tex2D(_HeightMap,shadeP.xy).a;
				if(shadeP.z<d)
				shadeP+=biOffset;//step froward one/2
				else
				shadeP-=biOffset;//first shadeP.z must bigger than d=1-tex2D(HeightMap).so step back one/2
			}
			float4 c=tex2D(_MainTex,shadeP.xy);
			float3 N=UnpackNormal(tex2D(_BumpMap,shadeP.xy));
			float diff=max(0,dot(N,i.lightDir));
			float atten=length(_WorldSpaceLightPos0-i.posW);
			atten=1/(1+atten*atten);
			c=c*_LightColor0*diff*atten;
			return c*2;
		}
		ENDCG
		}
	} 
}
