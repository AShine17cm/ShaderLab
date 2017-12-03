using UnityEngine;
using System.Collections;
[ExecuteInEditMode]
public class M_World2View : MonoBehaviour {
    public Matrix4x4 m;
    public int dx,dy;
    public Rect cam;
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
        m = Camera.main.worldToCameraMatrix;
	}
    void OnGUI()
    {
        GUI.BeginGroup(cam);
        GUI.Label(new Rect(0, 0, 60, 20), "Row&Col");
        for (int i = 0; i < 4; i++)
        {
            GUI.Label(new Rect(0, i * dy + 20, 70, 20), "   R:" + i);//Display Row label
            for (int j = 0; j < 4; j++)
            {
                GUI.Label(new Rect(j * dx + 50, i * dy + 20, 70, 20), m[i, j] + "");

            }
        }
        GUI.EndGroup();
    }
}
