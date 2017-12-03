using UnityEngine;
using System.Collections;
[ExecuteInEditMode]
public class _SetShaderLOD : MonoBehaviour
{
    public Shader myShader;
    public GUISkin skin;
    public Rect rt;
    public Rect tip;
    //string tipStr;
    private float val = 6;
    void Update()
    {
        myShader.maximumLOD = (int)val * 100;
    }
    void OnGUI()
    {
        GUI.skin = skin;
        val = (int)GUI.HorizontalSlider(rt, val, 3, 7);
        GUI.Label(tip, "Current LOD is: " + val * 100);
    }
}
