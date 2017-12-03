		struct MyLightingInfo{
			float3 vNormal;
			float4 lightDir;
			float4 lightColor;
		};
		float4 DoLightDir_Atten(float4 lightPos,float4 worldSpaceVertex)
		{
			float4 lightDir=float4(0,0,0,0);
			if(lightPos.w==0)//为平行光
			{
				lightDir.xyz=lightPos;
				lightDir.w=1.0;//平行光衰减为1.0
			}else//Point/Spot//点光源
			{
				lightDir.xyz=(lightPos-worldSpaceVertex).xyz;
				lightDir.w=1/(1+length(lightDir.xyz));//点光源的衰减 
				lightDir.xyz=normalize(lightDir.xyz);
			}
			return lightDir;
		}
		float4 DoMyLighting(MyLightingInfo info)
		{
			float diff=max(0,dot(info.vNormal,info.lightDir.xyz));
			float4 c=info.lightColor*diff*info.lightDir.a;
			return c;
		}
