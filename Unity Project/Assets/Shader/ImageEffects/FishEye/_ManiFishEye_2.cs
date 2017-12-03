using UnityEngine;
using System.Collections;
public class _ManiFishEye_2 : MonoBehaviour {
    public GUISkin skin;
    public Material mat;
    public Renderer rd;
    public Rect[] rSlider;
    public float[] val;
    public Rect[] rLabels;
    public string[] labels;
    Camera shaderCam;
    RenderTexture  tex;
	void Start () {
        if (!shaderCam)
        {
            GameObject g = new GameObject("Shade Camera");
            g.transform.position = transform.position;
            g.transform.rotation = transform.rotation;
            shaderCam=g.AddComponent<Camera>();
        }
        tex = new RenderTexture(Screen.width, Screen.height, 16);
        shaderCam.CopyFrom(GetComponent<Camera>());
        shaderCam.targetTexture = tex;
	}
	void Update () {
        mat.SetVector("_Intensity",new Vector4(val[0],val[1]));
	}
    void OnGUI()
    {
        GUI.skin = skin;
        for (int i = 0; i < 2; i++)
        {
            val[i] = GUI.HorizontalSlider(rSlider[i], val[i], -1, 1);
        }
        for (int i = 0; i < labels.Length; i++)
        {
            GUI.Label(rLabels[i],labels[i]);
        }
    }
    void OnPreCull()
    {
        mat.SetTexture("_MainTex", tex);
    }
    void OnPostRender()
    {
        mat.SetTexture("_MainTex", null);
    }
}
