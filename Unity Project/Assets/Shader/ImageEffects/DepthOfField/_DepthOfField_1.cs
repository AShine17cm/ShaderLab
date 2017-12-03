using UnityEngine;
using System.Collections;
public class _DepthOfField_1 : MonoBehaviour {
	public Shader blurShader  ;
	private Material blurMat  = null;	
    public float widthOverHeight  = 1.25f;
    public float oneOverBaseSize  = 1.0f / 512.0f;	
	void Start () {
        blurMat = new Material(blurShader);
	}
    void OnRenderImage (RenderTexture source ,RenderTexture destination ) {
        //模糊了两次，第一遍的模糊作为源，然后输出给了第二次模糊处理
        RenderTexture temp = RenderTexture.GetTemporary(source.width, source.height);

        blurMat.SetVector("offsets", new Vector4(0.0f, 2f * oneOverBaseSize, 0.0f, 0.0f));
        Graphics.Blit(source, temp, blurMat);
        blurMat.SetVector("offsets", new Vector4(2f / widthOverHeight * oneOverBaseSize, 0.0f, 0.0f, 0.0f));
        Graphics.Blit(temp, destination, blurMat);

        RenderTexture.ReleaseTemporary(temp);
	}
}
