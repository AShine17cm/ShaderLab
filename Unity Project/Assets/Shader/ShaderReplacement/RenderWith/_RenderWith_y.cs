using UnityEngine;
using System.Collections;
public class _RenderWith_y : MonoBehaviour {
    void OnPreCull()
    {
        Debug.Log("another camera RenderWith"  + "  :'OnPreCull()'");
    }
    void OnPreRender()
    {
        Debug.Log("another camera RenderWith" + "  :'OnPreRender()'");
    }
    void OnPostRender()
    {
        Debug.Log("another camera RenderWith" + "  :'OnPostRender()'");
    }
    void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        Debug.Log("another camera RenderWith" + "  :'OnRenderImage()'");
    }
    void OnWillRenderObject()
    {
        Debug.Log("another camera RenderWith" + "  :'OnWillObject()'");
    }
}
