Shader "Tut/Shader/FixedFuncs/LightMap_1" { 
SubShader { 	
// Lightmapped, encoded as dLDR 
	pass { 		
	Tags { "LightMode" = "VertexLM" } 		
	 		BindChannels { 			
				Bind "Vertex", vertex 		
				Bind "normal", normal 		
				Bind "texcoord1", texcoord0 // lightmap uses 2nd uv 	
				Bind "texcoord", texcoord1 // main uses 1st uv 		
				} 		
		SetTexture [unity_Lightmap] { 	
			matrix [unity_LightmapMatrix] 		
			combine texture 		
		} 	
} 	
// Lightmapped, encoded as RGBM 	
pass { 		
	Tags { "LightMode" = "VertexLMRGBM" } 		
		BindChannels { 		
			Bind "Vertex", vertex 	
			Bind "normal", normal 
			Bind "texcoord1", texcoord0 // lightmap uses 2nd uv 		
			Bind "texcoord1", texcoord1 // unused 		
			Bind "texcoord", texcoord2 // main uses 1st uv 		
		} 		
	SetTexture [unity_Lightmap] { 	
		matrix [unity_LightmapMatrix] 	
		combine texture  	
	} 	
	}//endpass
}  
} 
