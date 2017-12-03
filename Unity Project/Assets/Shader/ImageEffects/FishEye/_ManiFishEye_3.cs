using UnityEngine;
using System.Collections;
[ExecuteInEditMode]
public class _ManiFishEye_3 : MonoBehaviour {
    public Shader warpShader;
    private Material warpMat;
    public float amtX = 0.05f;
    public float amtY = 0.05f;
    public GUISkin skin;
    public Rect[] rSlider;
    public float[] val;
    public Rect[] rLabels;
    public string[] labels;
	// Use this for initialization
	void Start () {
        warpMat = new Material(warpShader);
        warpMat.hideFlags = HideFlags.DontSave;
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
    }
    void OnRenderImage(RenderTexture src,RenderTexture dst)
    {
        float ratio = (src.width*1.0f) / (Screen.height*1.0f);
        Vector4 v4=new Vector4(val[0]*ratio,val[1],0,0);
        warpMat.SetVector("_Intensity", v4);
        Graphics.Blit(src,dst,warpMat);
    }
}
