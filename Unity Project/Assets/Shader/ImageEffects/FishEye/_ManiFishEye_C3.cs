using UnityEngine;
using System.Collections;

//[ExecuteInEditMode]
public class _ManiFishEye_C3 : MonoBehaviour {
    public GUISkin skin;
    public Material mat;
    public Rect[] rSlider;
    public float[] val;
    public Rect[] rLabels;
    public string[] labels;
    Camera shaderCam;
    RenderTexture rt;
	// Use this for initialization
	void Start () {
        if (!shaderCam)
        {
            GameObject g = new GameObject("Shade Camera");
            shaderCam = g.AddComponent<Camera>();
            shaderCam.hideFlags = HideFlags.HideAndDontSave;
            shaderCam.backgroundColor = GetComponent<Camera>().backgroundColor;
            shaderCam.clearFlags = GetComponent<Camera>().clearFlags;
            rt = new RenderTexture(Screen.width, Screen.height, 16);
        }
	}
	
	// Update is called once per frame
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

    void xOnPreCull()
    {
        shaderCam.targetTexture = rt;
        shaderCam.CopyFrom(GetComponent<Camera>());
        mat.SetTexture("_MainTex",rt);
        rt = null;
    }
    void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        mat.SetTexture("_MainTex", src);
        Graphics.Blit(src, dst);
    }
}
