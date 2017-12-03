using UnityEngine;
using System.Collections;
[ExecuteInEditMode]
public class ShadowVolumeExtrusion_2 : MonoBehaviour {
	public MeshFilter[] objects;
	public Light shadowLight;
	//public Shader extrusionShader;
	public Material extrusionMat1;
	public Material extrusionMat2;
	public Material extrusionMat3;
	public float extrusionDistance=20.0f;
	//
	public int pass;
	
	
	void OnPostRender()
	{
		if(!enabled) return;
		
		Vector4 lightPos;
		if(shadowLight.type==LightType.Directional)
		{
			Vector3 dir=-shadowLight.transform.forward;
			lightPos=new Vector4(dir.x,dir.y,dir.z,0.0f);
		}else{
			Vector3 pos=shadowLight.transform.position;
			lightPos=new Vector4(pos.x,pos.y,pos.z,1.0f);
		}
		
		extrusionMat1.SetVector("_LightPosition",lightPos);
		extrusionMat2.SetVector("_LightPosition",lightPos);
		extrusionMat3.SetVector("_LightPosition",lightPos);
		
		Mesh m0=objects[0].sharedMesh;
		Transform tr0=objects[0].transform;
		extrusionMat1.SetPass(0);
		Graphics.DrawMeshNow(m0,tr0.localToWorldMatrix);
		
		Mesh m1=objects[1].sharedMesh;
		Transform tr1=objects[1].transform;
		extrusionMat2.SetPass(0);
		Graphics.DrawMeshNow(m1,tr1.localToWorldMatrix);
		
		Mesh m2=objects[2].sharedMesh;
		Transform tr2=objects[2].transform;
		extrusionMat3.SetPass(0);
		Graphics.DrawMeshNow(m2,tr2.localToWorldMatrix);
		extrusionMat3.SetPass(1);
		Graphics.DrawMeshNow(m2,tr2.localToWorldMatrix);
	}
}
