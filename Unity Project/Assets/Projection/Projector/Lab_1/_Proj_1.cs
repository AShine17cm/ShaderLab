using UnityEngine;
using System.Collections;
[ExecuteInEditMode]
public class _Proj_1 : MonoBehaviour {
    public GUISkin skin;
    public string[] strs;
    public Rect[] rs;
    public Rect texR;
    public Texture tex;
	
	// Update is called once per frame
	void OnGUI () {
        GUI.skin = skin;
        for (int i = 0; i < rs.Length; i++)
        {
            GUI.Label(rs[i], strs[i]);
        }
       // GUI.Label(texR, tex);
        GUI.DrawTexture(texR, tex);
	}
}
