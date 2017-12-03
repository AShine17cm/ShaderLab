using UnityEngine;
public class _MotionBlur_1 : MonoBehaviour
{
	public float blurAmount = 0.8f;
    public Shader shader;
    private Material mat;
	public RenderTexture accumTexture;
    void Start()
	{
        mat = new Material(shader);
        mat.hideFlags = HideFlags.HideAndDontSave;
	}
	void OnRenderImage (RenderTexture src, RenderTexture dst)
	{
		if (accumTexture == null)
		{
            accumTexture = new RenderTexture(src.width, src.height,0);
			accumTexture.hideFlags = HideFlags.HideAndDontSave;
			Graphics.Blit( src, accumTexture );
            mat.SetTexture("_AccumTex", accumTexture);
        }
        RenderTexture temp = RenderTexture.GetTemporary(src.width, src.height);
		blurAmount = Mathf.Clamp( blurAmount, 0.0f, 1f );
        mat.SetFloat("_AccumAmt", blurAmount);

        Graphics.Blit (src, temp, mat);
        Graphics.Blit(temp, dst);
        Graphics.Blit(temp, accumTexture);

        RenderTexture.ReleaseTemporary(temp);
    }
}
