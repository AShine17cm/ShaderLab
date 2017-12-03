using UnityEngine;
using System.Collections;
//[ExecuteInEditMode]
public class VolShaft_1 : MonoBehaviour {

	public Light shadowLight;
	public int pass;

    public MeshFilter[] objs;
    public Material[] mats;

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

        for (int i = 0; i < objs.Length;i++ )
        {
            DrawShaft(objs[i], lightPos, mats[i]);
        }
	}
    void DrawShaft(MeshFilter obj, Vector4 lightPos,Material exMat)
    {
        exMat.SetVector("litPos", lightPos);

        Mesh ms = obj.sharedMesh;
        Transform tr = obj.transform;
        exMat.SetPass(0);
        Graphics.DrawMeshNow(ms, tr.localToWorldMatrix);
    }
}
