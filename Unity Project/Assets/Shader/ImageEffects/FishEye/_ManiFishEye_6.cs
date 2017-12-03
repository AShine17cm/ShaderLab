using UnityEngine;
using System.Collections;
//[ExecuteInEditMode]
public class _ManiFishEye_6 : MonoBehaviour {
    public Shader warpShader;
    public Shader blitRegionShader;
    public Shader objMaskShader;
    public Renderer objRD;
    private Material warpMat;
    private Material regionMat;
    public GUISkin skin;
    public Rect[] rSlider;
    public float[] val;
    public Rect[] rLabels;
    public string[] labels;
    public Rect rectPosx;
    public float z;
    private Vector3 oriPos;
    public RenderTexture tempRT;
    public RenderTexture maskRT;
    Camera maskCam;
	// Use this for initialization
	void Start () {
        warpMat = new Material(warpShader);
        warpMat.hideFlags = HideFlags.DontSave;
        regionMat = new Material(blitRegionShader);
        regionMat.hideFlags = HideFlags.DontSave;

        tempRT = new RenderTexture(Screen.width, Screen.height, 16);
        maskRT = new RenderTexture(Screen.width, Screen.height, 16);

        GameObject g = new GameObject("Mask camera");
        maskCam = g.AddComponent<Camera>();
        maskCam.enabled = false;

        oriPos = objRD.transform.position;
	}
    void Update()
    { 
        Vector3 pos=oriPos;
        pos.z+=z;
        objRD.transform.position = pos;
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
            GUI.Label(rLabels[i], labels[i]);
        }
        z = GUI.HorizontalSlider(rectPosx, z, -3, 3);
    }
    void OnPreCull()
    {
        objRD.enabled = true;
        maskCam.CopyFrom(GetComponent<Camera>());
        maskCam.backgroundColor = new Color(0, 0, 0, 0);
        maskCam.targetTexture = maskRT;
        maskCam.RenderWithShader(objMaskShader,"myMask");
        maskCam.targetTexture = null;
        objRD.enabled = false;
    }

    void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        float ratio = (src.width * 1.0f) / (Screen.height * 1.0f);
        Vector4 v4 = new Vector4(val[0] * ratio, val[1], 0, 0);

        warpMat.SetVector("_Intensity", v4);
        regionMat.SetTexture("_MaskTex",maskRT);
        regionMat.SetTexture("_OriTex",src);
        Graphics.Blit(src, tempRT, warpMat);
        Graphics.Blit(tempRT, dst, regionMat);
    }
}
