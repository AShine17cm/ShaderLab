using UnityEngine;
[ExecuteInEditMode]
public class _MultiTap_y: MonoBehaviour
{
    public GUISkin skin;
    public string[] labels;
    public Rect[] rLabels;
    public float[] vals;
    public Rect[] rSliders;
    public Material myMat;
    void OnGUI()
    {
        GUI.skin = skin;
        for (int i = 0; i < labels.Length; i++)
        {
            GUI.Label(rLabels[i], labels[i]);
        }
        vals[0] = GUI.HorizontalSlider(rSliders[0],vals[0],-8f,8f);
    }
	void OnRenderImage (RenderTexture src, RenderTexture dst)
	{
        Graphics.BlitMultiTap(src,dst,myMat,
                new Vector2(vals[0],vals[0]),
                 new Vector2(vals[0],vals[0])
            );
	}
}
