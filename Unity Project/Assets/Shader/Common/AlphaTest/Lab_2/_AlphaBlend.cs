using UnityEngine;
using System.Collections;
public class _AlphaBlend : MonoBehaviour {
    public Renderer rd1;
    public Renderer rd2;
    
   public GUISkin skin;
   public float j1;
   public Rect rStr1;
   public Rect rJ1;
  
    void Update () {
        rd1.material.SetFloat("_CutOff",j1);
        rd2.material.SetFloat("_CutOff", j1);
    }
    void OnGUI()
    {
        GUI.skin = skin;
        j1 = GUI.HorizontalSlider(rJ1, j1, 0, 1);
        GUI.Label(rStr1,"AlphaTest"+"  "+"GEqual  "+j1);
    }
}
