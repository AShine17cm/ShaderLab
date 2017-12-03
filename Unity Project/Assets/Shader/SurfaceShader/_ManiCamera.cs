using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class _ManiCamera : MonoBehaviour {
    public Camera cam;
    public GUISkin skin;
    public Rect[] camRec;
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {

	}
    void OnGUI()
    {
        GUI.skin = skin;
        GUI.Label(camRec[0], "RenderingPath: " + Camera.main.renderingPath + "");
        if (GUI.Button(camRec[1], "VertexLit")) Camera.main.renderingPath = RenderingPath.VertexLit;
        if (GUI.Button(camRec[2], "Forward")) Camera.main.renderingPath = RenderingPath.Forward;
        if (GUI.Button(camRec[3], "Deferred")) Camera.main.renderingPath = RenderingPath.DeferredShading;
    }
}
