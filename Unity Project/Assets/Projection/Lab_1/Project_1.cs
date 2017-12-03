using UnityEngine;
using System.Collections;
[ExecuteInEditMode]
public class Project_1 : MonoBehaviour {
    //public Transform tex;
    public GUISkin skin;
    public Transform projector;
    public Matrix4x4 world2ProjView;
    public Matrix4x4 projM;
    public Matrix4x4 correction;
    public Matrix4x4 cm;
    float n=0.3f;
    public float f=50f;
    float aspect=1f;
   public float fov=1f;
    float d;

    public Rect r;
    public Rect[] rs;
    public string[] strs;
	public Camera projCamera;
	public Camera mainC;
	// Use this for initialization
	void Awake () {
        correction = Matrix4x4.identity;
        correction.SetColumn(3,new Vector4(0.5f,0.5f,0.5f,1f));
        correction.m00 = 0.5f;
        correction.m11 = 0.5f;
        correction.m22 = 0.5f;
		
		aspect=projCamera.aspect;
	}
	
	// Update is called once per frame
	void Update () {
        Proj();
	}
    void OnGUI()
    {
        GUI.skin = skin;
    	MyMatrix.DisplayMatrix(projM,r);
		
		if(GUI.Button(rs[0],strs[0]))
		{
			projCamera.depth=0;
			mainC.depth=-1;
		}
		if(GUI.Button(rs[1],strs[1]))
		{
			mainC.depth=0;
			projCamera.depth=-1;
		}
    }
    void Proj()
    {
        world2ProjView = projector.worldToLocalMatrix;//
        //world2ProjView = Camera.main.worldToCameraMatrix * world2ProjView;
        //n = Camera.main.near;
        //f = Camera.main.far;
        //aspect = Camera.main.aspect;
        //fov = Camera.main.fieldOfView * Mathf.Deg2Rad;
        d = 1f / Mathf.Tan(fov / 2f);

        projM.m00 = d / aspect;
        projM.m11 = d;
        projM.m22 = (n + f) / (n - f);
        projM.m23 = 2f * n * f / (n - f);
        projM.m32 = 1f;
        projM.m33 = 0;

        cm = correction * projM * world2ProjView;
        Shader.SetGlobalMatrix("projM2", cm);
    }
}
