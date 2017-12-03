using UnityEngine;
using System.Collections;

public class _DepthOfField_2 : MonoBehaviour {
    public Camera cam;
    public Shader dofShader;
    private Material dofMat = null;
	public Shader blurShader  ;
	private Material blurMat  = null;	
    
    private float widthOverHeight  = 1.25f;
    private float oneOverBaseSize  = 1.0f / 512.0f;	
        
	// Use this for initialization
	void Start () {
        blurMat = new Material(blurShader);
        dofMat = new Material(dofShader);
        cam.depthTextureMode = DepthTextureMode.Depth;
	}

    void OnRenderImage (RenderTexture src ,RenderTexture dst ) {
        RenderTexture blurRT = RenderTexture.GetTemporary(src.width, src.height, 16);
        RenderTexture blurRT2 = RenderTexture.GetTemporary(src.width, src.height, 16);
        //使用临时变量blurRT存储模糊结果，从而保留了原始的清晰图像
        blurMat.SetVector("offsets", new Vector4(2f / widthOverHeight * oneOverBaseSize, 2f * oneOverBaseSize, 0.0f, 0.0f));
        Graphics.Blit(src, blurRT, blurMat);
        blurMat.SetVector("offsets", new Vector4(2f / widthOverHeight * oneOverBaseSize, 0.0f, 0.0f, 0.0f));
        Graphics.Blit(blurRT, blurRT2, blurMat);
        dofMat.SetTexture("_BlurTex", blurRT2);
        Graphics.Blit(src, dst, dofMat);

        RenderTexture.ReleaseTemporary(blurRT);
        RenderTexture.ReleaseTemporary(blurRT2);
	}
}
