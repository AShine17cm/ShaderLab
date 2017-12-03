using UnityEngine;
using System.Collections;

public class EdgeDetect_1 :MonoBehaviour{
    public Shader edgeShader;
    public Material mat;

	void Start () {
        mat = new Material(edgeShader);
        mat.hideFlags = HideFlags.HideAndDontSave;
        GetComponent<Camera>().depthTextureMode = DepthTextureMode.DepthNormals;
	}
	void OnRenderImage (RenderTexture src,RenderTexture dst) {
       Graphics.Blit( src,dst,mat);
	}
}
