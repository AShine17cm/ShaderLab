using UnityEngine;
using System.Collections;
public class _RenderWith_x : MonoBehaviour {
    public GUISkin skin;
	public string replacebyTag="myTag";
	public Shader useShader;
    public bool rw = false;
    public Rect r1;
	public Camera rtCam;
    public Material mat;

    void OnGUI()
    {
        GUI.skin = skin;
        if (GUI.Button(r1, "Test Render With:"))
        {
            rw = true;
            rtCam.CopyFrom(GetComponent<Camera>());
            rtCam.RenderWithShader(useShader, replacebyTag);
            rw = false;
        }
    }

    void OnPreCull()
    {
        if (rw)
        {
            Debug.Log("camera 1. RenderWithShader" +  "  :'OnPreCull()'");
        }
        
    }
    void OnPreRender()
    {
        if (rw)
        {
            Debug.Log("camera 1. RenderWithShader" + "  :'OnPreRender()'");
        }
    }
    void OnPostRender()
    {
        if (rw)
        {
            Debug.Log("camera 1. RenderWithShader" + "  :'OnPostRender()'");
        }
    }
    void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        if (rw)
        {
            Debug.Log("camera 1. RenderWithShader" + "  :'OnRenderImage()'");
        }
        Graphics.Blit(src, dst);
    }
    void OnRenderObject()
    {
        if (rw)
        {
            Debug.Log("camera 1. RenderWithShader" + "  :'OnRenderObject()'");
        }
     }
    void OnWillRenderObject()
    {
        if (rw)
        {
            Debug.Log("camera 1. RenderWithShader" + "  :'OnWillRenderObject()'");
        }
    }
}
