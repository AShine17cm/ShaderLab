using UnityEngine;
using System.Collections;
[ExecuteInEditMode]
public class TexGen : MonoBehaviour {
    public GUISkin skin;
   // public Texture tex;
    //public Rect r;
    public Rect[] rs;
    public string[] strs;
    void OnGUI()
    {
        GUI.skin = skin;
        for (int i = 0; i < rs.Length; i++)
        {
            GUI.Label(rs[i], strs[i]);
        }
        //GUI.Label(r, tex);
    }
}
