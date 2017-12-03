using UnityEngine;
using System.Collections;

public class _ManiPreRender : MonoBehaviour {
    public GameObject obj1;
    public GameObject obj2;
    public static int order;
    public int preCull;
    public int postRender;
    Vector3 ori;
    Vector3 oriRot;
    public Material mat;
    public Texture tex;
    float exAmt;
    public Rect r1;
    public GUISkin skin;
	// Use this for initialization
	void Start () {
        ori = obj1.transform.position;
        oriRot = obj2.transform.eulerAngles;
        exAmt = mat.GetFloat("_ExtrudeAmt");
	}
	
	// Update is called once per frame
	void Update () {
	}
    void OnPreRender()
    {
        obj1.transform.position = new Vector3(ori.x -2, ori.y, ori.z);
        obj2.transform.eulerAngles = new Vector3(0, 0, -90);
        mat.SetFloat("_ExtrudeAmt", 0.7f);
        mat.SetTexture("_MainTex", tex);
    }
    void OnPostRender()
    {
        obj1.transform.position = ori;
        obj2.transform.eulerAngles = oriRot;
        mat.SetFloat("_ExtrudeAmt", exAmt);
        mat.SetTexture("_MainTex", null);
    }
    void OnGUI()
    {
        GUI.skin = skin;
        GUI.Label(r1, "OnPreRender");
    }
}
