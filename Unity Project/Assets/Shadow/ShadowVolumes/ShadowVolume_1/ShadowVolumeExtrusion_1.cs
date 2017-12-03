using UnityEngine;
using System.Collections;
[ExecuteInEditMode]
public class ShadowVolumeExtrusion_1 : MonoBehaviour {
	public MeshFilter[] objects;
	public Light shadowLight;
	public Shader extrusionShader;
	public Material extrusionMat;
	public float extrusionDistance=20.0f;

	void Update(){	}
	
	void OnPostRender()
	{
		if(!enabled) return;
		
		Vector4 lightPos;
		//if(shadowLight.type==LightType.Directional)
		//{
		//	Vector3 dir=-shadowLight.transform.forward;
		//	dir=transform.InverseTransformDirection(dir);
		//	lightPos=new Vector4(dir.x,dir.y,-dir.z,0.0f);
		//}else{
		//	Vector3 pos=shadowLight.transform.position;
		//	pos=transform.InverseTransformPoint(pos);
		//	lightPos=new Vector4(pos.x,pos.y,pos.z,1.0f);
		//}
        if (shadowLight.type == LightType.Directional)
        {
            Vector3 dir = -shadowLight.transform.forward;
            lightPos = new Vector4(dir.x, dir.y, dir.z, 0.0f);
        }
        else
        {
            Vector3 pos = shadowLight.transform.position;
            lightPos = new Vector4(pos.x, pos.y, pos.z, 1.0f);
        }
        extrusionMat.SetVector("_LightPosition",lightPos);

	}
}
