using UnityEngine;
using System.Collections;
public class _Render_1 : MonoBehaviour {
    public int order;
    void OnPreCull()
    {
        order = 0;
        Debug.Log("Camera.Render().flollowed  "  + order + "  :'OnPreCull()'");
    }
    void OnPreRender()
    {
        order++;
        Debug.Log("Camera.Render().flollowed  " + order + "  :'OnPreRender()'");
    }
    void OnPostRender()
    {
        order++;
        Debug.Log("Camera.Render().flollowed  " + order + "  :'OnPostRender()'");
    }
    void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        order++;
        Graphics.Blit(src, dst);
        Debug.Log("Camera.Render().flollowed  " + order + "  :'OnRenderImage()'");
    }
    void OnWillRenderObject()
    {
        order++;
        Debug.Log("Camera.Render().flollowed  " + order + "  :'OnWillRenderObject()'");
    }
}
