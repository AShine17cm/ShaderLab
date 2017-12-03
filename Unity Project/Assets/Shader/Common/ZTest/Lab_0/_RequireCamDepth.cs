using UnityEngine;
using System.Collections;
[ExecuteInEditMode]
public class _RequireCamDepth : MonoBehaviour {
    public Camera cam;
    public Rect btnRect = new Rect(20, 20, 200, 40);
    void Update () {

	}
    void OnGUI()
    {

        if (GUI.Button(btnRect, "_CameraDepthTexture")) cam.depthTextureMode = cam.depthTextureMode|DepthTextureMode.Depth;
    }

}
