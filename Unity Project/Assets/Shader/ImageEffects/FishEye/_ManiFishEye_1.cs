using UnityEngine;
using System.Collections;
[ExecuteInEditMode]
public class _ManiFishEye_1 : MonoBehaviour {
    public GUISkin skin;
    public Material mat;
    public Rect[] rSlider;
    public float[] val;
    public Rect[] rLabels;
    public string[] labels;
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
}
