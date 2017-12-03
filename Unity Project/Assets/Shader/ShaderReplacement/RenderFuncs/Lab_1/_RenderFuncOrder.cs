using UnityEngine;
using System.Collections;

public class _RenderFuncOrder : MonoBehaviour {
    public _RenderFuncOrder one;
    public string hat = "";
	void Start () {
        one = this;
	}
	void Update () {
        Debug.Log(hat+BigCounter.Counter+ "camera:Update()");
	}
    void OnPreCull()
    {
        Debug.Log(hat + BigCounter.Counter + "camera:OnPreCull()");
    }
    void OnPreRender()
    {
        Debug.Log(hat + BigCounter.Counter + "camera:OnPreRender()");
    }
    void OnPostRender()
    {
        Debug.Log(hat + BigCounter.Counter + "camera:OnPostRender()");
    }
    void OnRenderImage(RenderTexture src,RenderTexture dst)
    {
        Debug.Log(hat + BigCounter.Counter + "camera:OnRenderImage()");
        Graphics.Blit(src, dst);
    }
    void OnRenderObject()
    { 
        Debug.Log(hat + BigCounter.Counter + "camera:OnRenderObject()");
    }
    void OnWillRenderObject()
    {
        Debug.Log(hat + BigCounter.Counter + "camera:OnWillRenderObject()");
    }
    private void LateUpdate()
    {
        BigCounter.Reset();
    }
}
