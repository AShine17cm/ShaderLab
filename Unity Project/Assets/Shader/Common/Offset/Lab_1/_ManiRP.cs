using UnityEngine;
using System.Collections;
[ExecuteInEditMode]
public class _ManiRP : MonoBehaviour {
    public Camera cam;
    //public GUISkin skin;
    //public Rect[] camRec;

	void Start () {
        cam.depthTextureMode =  DepthTextureMode.Depth;
	}
    //void OnGUI()
    //{
    //    GUI.skin = skin;
    //    GUI.Label(camRec[0], "RenderingPath: " + cam.renderingPath + "");
    //    if (GUI.Button(camRec[1], "VertexLit")) cam.renderingPath = RenderingPath.VertexLit;
    //    if (GUI.Button(camRec[2], "Forward")) cam.renderingPath = RenderingPath.Forward;
    //    if (GUI.Button(camRec[3], "Deferred")) cam.renderingPath = RenderingPath.DeferredShading;
    //}

}
