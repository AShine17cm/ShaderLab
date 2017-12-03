Shader "Tut/Shader/Common/Cull_2" {
	SubShader {
		pass{
			Cull Back
			Lighting On
			Material{ Diffuse(1,1,1,1) }
		}
	} 
}
