using UnityEngine;
using System.Collections;
[ExecuteInEditMode]
public class _UVOffset_1 : MonoBehaviour {
    public GUISkin skin;
    public Rect[] rs;
    public string[] strs;
    void OnGUI()
    {
        GUI.skin = skin;
        for (int i = 0; i < rs.Length; i++)
        {
            GUI.Label(rs[i], strs[i]);
        }
    }
}
