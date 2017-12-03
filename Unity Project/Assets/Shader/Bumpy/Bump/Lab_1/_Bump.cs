using UnityEngine;
using System.Collections;
[ExecuteInEditMode]
public class _Bump : MonoBehaviour {
    public GUISkin skin;
    public Rect[] rects;
    public string[] strs;
    void OnGUI()
    {
        GUI.skin = skin;
        for (int i = 0; i < strs.Length; i++)
        {
            GUI.Label(rects[i], strs[i]);
        }
    }
}
