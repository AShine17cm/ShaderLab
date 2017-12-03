using UnityEngine;
using System.Collections;
public class _RenderWith_z : MonoBehaviour {
    public GUISkin skin;
	public string replacebyTag="myTag";
	public Shader useShader;
    public bool rw = false;
    public Rect r1;
    public Material planeMat;
    public RenderTexture rt;
	// Use this for initialization
	void Start () {
        rt = new RenderTexture(Screen.width, Screen.height, 16);
	}
    void OnGUI()
    {
        GUI.skin = skin;
        if (GUI.Button(r1, "Test Render With:"))
        {
            rw = true;
            GetComponent<Camera>().targetTexture = rt;
            GetComponent<Camera>().RenderWithShader(useShader, replacebyTag);
            GetComponent<Camera>().targetTexture = null;
            planeMat.mainTexture = rt;
            rw = false;
        }
    }

    void OnPreCull()
    {
        if (rw)
        {
            Debug.Log("RenderWithShader" +  "  :'OnPreCull()'");
        }
        
    }
    void OnPreRender()
    {
        if (rw)
        {
            Debug.Log("RenderWithShader" + "  :'OnPreRender()'");
        }
    }
    void OnPostRender()
    {
        if (rw)
        {
            Debug.Log("RenderWithShader" +  "  :'OnPostRender()'");
        }
    }
    void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        if (rw)
        {
            Debug.Log("RenderWithShader" +"  :'OnRenderImage()'");
        }
        Graphics.Blit(src, dst);
    }
    void OnRenderObject()
    {
        if (rw)
        {
            Debug.Log("RenderWithShader" +"  :'OnRenderObject()'");
        }
     }
    void OnWillRenderObject()
    {
        if (rw)
        {
            Debug.Log("RenderWithShader" +"  :'OnWillRenderObject()'");
        }
    }
    
}
