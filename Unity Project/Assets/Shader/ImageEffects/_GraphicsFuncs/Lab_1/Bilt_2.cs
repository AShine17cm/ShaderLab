using UnityEngine;
using System.Collections;

public class Bilt_2 : MonoBehaviour {

    void OnRenderImage(RenderTexture src,RenderTexture dst)
    {
        Graphics.Blit(src,dst);
    }
}
