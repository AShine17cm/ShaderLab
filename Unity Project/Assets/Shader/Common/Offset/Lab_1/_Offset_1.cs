using UnityEngine;
using System.Collections;
public class _Offset_1 : MonoBehaviour {
    public GUISkin skin;
    public Renderer rd;
    public Texture tex;
    public Rect ri;
    public Rect rj;
    public Rect r1;
    public int i, j;
    public int mi, mj;
    public Material mat;
    void Start () {
        //mat = GenMat(mi, mj);
    }
    void Update () {
        if (mi != i || mj != j)
        {
            mi = i;
            mj = j;
            UpdateMat(mi, mj);
        }
        rd.material = mat;
    }
    void OnGUI()
    {
        GUI.skin = skin;
        i = (int)GUI.HorizontalSlider(ri, i, -40, 40);
        j = (int)GUI.HorizontalSlider(rj, j, -40, 40);
        GUI.Label(r1, "Offset  " + i + "    " + j);

    }
    void UpdateMat(int i, int j)
    {
        mat.SetInt("_Factor", i);
        mat.SetInt("_Units", j);
    }
}
