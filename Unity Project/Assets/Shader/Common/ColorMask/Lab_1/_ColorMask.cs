using UnityEngine;
using System.Collections;
public class _ColorMask : MonoBehaviour {
    public Rect[] rs;
    public string[] tips;
    public GUISkin skin;
	void Start () {
        GetComponent<Camera>().depthTextureMode = DepthTextureMode.Depth;
	}
    void OnGUI()
    {
        GUI.skin = skin;
        for (int i = 0; i < tips.Length; i++)
        {
            GUI.Label(rs[i], tips[i]);
        }
    }
}
