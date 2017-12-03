using UnityEngine;
using System.Collections;

public class ShadowMapping_1 : MonoBehaviour
{
    public Light shadowLight;
    public RenderTexture lightViewZDepth;
    public Shader depShader;
    public Camera cam;
    //
    public GUISkin skin;
    private Camera lightPosCam;
    //private bool renderDepth;
    // Use this for initialization
    void Start()
    {
        GameObject litCam = new GameObject("LightPosCam");
        lightPosCam = litCam.AddComponent<Camera>();
        lightPosCam.CopyFrom(cam);
        litCam.transform.position = shadowLight.transform.position;
        litCam.transform.rotation = shadowLight.transform.rotation;

        lightPosCam.depthTextureMode = DepthTextureMode.Depth;
        //lightPosCam.targetTexture=lightViewZDepth;
        lightPosCam.enabled = false;
        lightPosCam.depth = -1;
        //cam.SetReplacementShader(depShader, "RenderType");
    }

    // Update is called once per frame
    void Update()
    {

    }
    void OnGUI()
    {
        GUI.skin = skin;
        if (GUI.Button(new Rect(20, Screen.height - 40, 110, 25), "Light View"))
            Switch2LightView();
        if (GUI.Button(new Rect(140, Screen.height - 40, 110, 25), "Main View"))
            Switch2MainView();
        if (GUI.Button(new Rect(260, Screen.height - 40, 160, 25), "LightView Depth"))
            RenderLightViewZDepth();
    }

    void Switch2LightView()
    {
        cam.enabled = false;
        lightPosCam.enabled = true;
        lightPosCam.SetReplacementShader(null, "");
        Camera.SetupCurrent(lightPosCam);
    }
    void Switch2MainView()
    {
        cam.enabled = true;
        lightPosCam.enabled = false;
        Camera.SetupCurrent(cam);
    }
    void RenderLightViewZDepth()
    {
        cam.enabled = false;
        lightPosCam.enabled = true;
        lightPosCam.SetReplacementShader(depShader, "RenderType");
    }
}
