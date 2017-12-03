using UnityEngine;
using System.Collections;
[ExecuteInEditMode]
public class _ZTest : MonoBehaviour {
    public GUISkin skin;
    public Renderer rd;
    public int mi;
    public Material[] mats;
    public string[] labels;
    public Rect sld;
    public Rect tip;
    public Rect[] rs;
    public string[] ls;
	// Use this for initialization
	void Start () {
        GetComponent<Camera>().depthTextureMode = GetComponent<Camera>().depthTextureMode|DepthTextureMode.Depth;
	}
	
	// Update is called once per frame
	void Update () {
        rd.material = mats[mi];
	}
    void OnGUI()
    {
        GUI.skin = skin;
        mi = (int)GUI.HorizontalSlider(sld, mi, 0, 6);
        GUI.Label(tip,"Current ZTest "+labels[mi]);
        for (int i = 0; i < rs.Length; i++)
        {
            GUI.Label(rs[i], ls[i]);
        }
    }
}
