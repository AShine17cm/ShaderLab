using UnityEngine;
using System.Collections;
[ExecuteInEditMode]
public class _ManiFishEye_4 : MonoBehaviour {
    public Shader warpShader;
    private Material warpMat;
    public GUISkin skin;
    public Rect[] rSlider;
    public float[] val;
    public Rect[] rLabels;
    public string[] labels;
    public Rect[] warpRegion;
    public float[] valR;
	// Use this for initialization
	void Start () {
        warpMat = new Material(warpShader);
        warpMat.hideFlags = HideFlags.DontSave;
        valR[0] = 0;
        valR[2] = 0;
        valR[1] = 1;
        valR[3] = 1;
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
        for (int i = 0; i < warpRegion.Length; i++)
        {
            valR[i] = GUI.HorizontalSlider(warpRegion[i],valR[i],0,1);
        }
    }
    void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        float ratio = (src.width*1.0f) / (Screen.height*1.0f);
        Vector4 v4=new Vector4(val[0]*ratio,val[1],0,0);
        Vector4 v42 = new Vector4(valR[0], valR[1], valR[2], valR[3]);
        warpMat.SetVector("_Intensity", v4);
        warpMat.SetVector("_Region", v42);
        Graphics.Blit(src,dst,warpMat);
    }
    
}
