using UnityEngine;
using System.Collections;
//[ExecuteInEditMode]
public class RectLit_RenderWith : MonoBehaviour {
    public Transform lit;
    public Material mat;
    public Shader withShader;
	//public int pass;

    public MeshFilter[] objs;
    public Material[] mats;

    private Camera rectCam;
    void Start()
    {
        GameObject g = new GameObject();
        rectCam = g.AddComponent<Camera>();
        rectCam.CopyFrom(GetComponent<Camera>());
    }
	void OnPostRender()
	{
		if(!enabled) return;
		
        //���������Դ�Ĳ���
        mat.SetVector("litP", lit.position);

        mat.SetVector("litN", lit.forward);
        mat.SetVector("litR", lit.right);
        mat.SetVector("litT", lit.up);
        //
       // camera.RenderWithShader(withShader, "Opaque");
        rectCam.RenderWithShader(withShader, "Opaque");
       // camera.SetReplacementShader(withShader, "Opaque");
	}
}
