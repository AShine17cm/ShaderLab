using UnityEngine;
using System.Collections;

public class Bilt_3 : MonoBehaviour {
    public Material mat;
    public Material displayMat;
    public RenderTexture dstRT;
	void Start () {
        dstRT = new RenderTexture(Screen.width, Screen.height, 16);
        displayMat.mainTexture = dstRT;
	}
    void OnRenderImage(RenderTexture src,RenderTexture dst)
    {
        src.wrapMode = TextureWrapMode.Repeat;
        Graphics.Blit(src,dstRT,mat);
        Graphics.Blit(dstRT, dst);
    }
}
