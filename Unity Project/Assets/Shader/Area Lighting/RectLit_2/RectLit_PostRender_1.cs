using UnityEngine;
using System.Collections;
//[ExecuteInEditMode]
public class RectLit_PostRender_1 : MonoBehaviour {
    public Transform lit;
    public Material mat;

	//public int pass;

    public MeshFilter[] objs;
    public Material[] mats;

	void OnPostRender()
	{
		if(!enabled) return;
		
        //设置面积光源的参数
        mat.SetVector("litP", lit.position);

        mat.SetVector("litN", lit.forward);
        mat.SetVector("litR", lit.right);
        mat.SetVector("litT", lit.up);
        //
        for (int i = 0; i < objs.Length;i++ )
        {
            RectLighting(objs[i],  mats[i]);
        }
	}
    void RectLighting(MeshFilter obj,Material exMat)
    {

        Mesh ms = obj.sharedMesh;
        Transform tr = obj.transform;
        exMat.SetPass(0);
        Graphics.DrawMeshNow(ms, tr.localToWorldMatrix);
    }
}
