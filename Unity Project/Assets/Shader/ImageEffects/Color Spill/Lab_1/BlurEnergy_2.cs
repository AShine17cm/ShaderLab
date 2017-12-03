using UnityEngine;
using System.Collections;

public class BlurEnergy_2 : MonoBehaviour {
    public Shader blurShader;
    Material mat;
	// Use this for initialization
	void Start () {
        mat = new Material(blurShader);
        mat.hideFlags = HideFlags.HideAndDontSave;
        GetComponent<Camera>().depthTextureMode = GetComponent<Camera>().depthTextureMode | DepthTextureMode.DepthNormals;
	}
	
	// Update is called once per frame
	void Update () {
	
	}
    void OnRenderImage(RenderTexture src,RenderTexture dst)
    {
        RenderTexture blurTex = RenderTexture.GetTemporary(Screen.width /1, Screen.height / 1);
        //
        Graphics.Blit(src, blurTex, mat);
        Graphics.Blit(blurTex, dst);
        RenderTexture.ReleaseTemporary(blurTex);
    }
}
