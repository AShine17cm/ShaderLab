using UnityEngine;
[ExecuteInEditMode]
public class _MultiTap_x: MonoBehaviour
{
    public GUISkin skin;
    public string[] labels;
    public Rect[] rLabels;
    public float[] vals;
    public Rect[] rSliders;
    public Material myMat;
    public Rect r100;
    void OnGUI()
    {
        GUI.skin = skin;
        for (int i = 0; i < labels.Length; i++)
        {
            GUI.Label(rLabels[i], labels[i]);
        }
        GUI.Label(r100, "100 Pixel");
        vals[0] = GUI.HorizontalSlider(rSliders[0],vals[0],-100f,100f);
    }

	void OnRenderImage (RenderTexture src, RenderTexture dst)
	{
        Graphics.BlitMultiTap(src,dst,myMat,new Vector2(vals[0],vals[0]));
	}
	
	
}
