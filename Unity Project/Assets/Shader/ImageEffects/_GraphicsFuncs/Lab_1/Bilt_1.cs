using UnityEngine;
using System.Collections;

public class Bilt_1 : MonoBehaviour {

    void OnRenderImage(RenderTexture src,RenderTexture dst)
    {
        Graphics.Blit(src, (RenderTexture)null);
    }
}
