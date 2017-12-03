using UnityEngine;
using System.Collections;
//[ExecuteInEditMode]
public class _Render_2 : MonoBehaviour {
    public GUISkin skin;
    public Rect r3;
	public Camera rtCam;
    void OnGUI()
    {
        GUI.skin = skin;
        if (GUI.Button(r3, "Render"))
        {
            rtCam.Render();
        }
    }
}
