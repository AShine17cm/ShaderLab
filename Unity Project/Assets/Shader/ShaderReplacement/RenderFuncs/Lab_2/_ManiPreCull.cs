using UnityEngine;
using System.Collections;

public class _ManiPreCull : MonoBehaviour {
    public GameObject obj1;
    public GameObject obj2;
    public static int order;
    public int preCull;
    public int postRender;
    Vector3 ori;
    Vector3 oriRot;
    public Rect r1;
    public GUISkin skin;
	// Use this for initialization
	void Start () {
        ori = obj1.transform.position;
        oriRot = obj2.transform.eulerAngles;
	}
	
	// Update is called once per frame
	void Update () {
	}
    void OnPreCull()
    {
        obj1.transform.position = new Vector3(ori.x -2, ori.y, ori.z);
        obj2.transform.eulerAngles = new Vector3(0, 0, -90);
    }
    void OnPostRender()
    {
        obj1.transform.position = ori;
        obj2.transform.eulerAngles = oriRot;
    }
    void OnGUI()
    {
        GUI.skin = skin;
        GUI.Label(r1,"OnPreCull");
    }
}
