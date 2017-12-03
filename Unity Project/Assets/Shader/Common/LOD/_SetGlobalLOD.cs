using UnityEngine;
using System.Collections;
[ExecuteInEditMode]
public class _SetGlobalLOD : MonoBehaviour
{
    public Shader myShader;
    public GUISkin skin;
    public Rect rt;
    public Rect r1;
    public Rect r2;
    //string tipStr;
    private float val = 6;
    void Update()
    {
        myShader.maximumLOD = 800;
        Shader.globalMaximumLOD = (int)val * 100;

    }
    void OnGUI()
    {
        GUI.skin = skin;
        val = (int)GUI.HorizontalSlider(rt, val, 3, 7);
        GUI.Label(r1, "Current Global LOD is: " + val * 100);
        GUI.Label(r2, "Current myShader LOD is: " + 800);
    }
}
