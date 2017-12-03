using UnityEngine;
public class _NoiseEffect_2 : MonoBehaviour
{
	public float grainSize = 2.0f;
    public float density = 1;
	public Texture grainTexture;
	public Shader   shaderRGB;
	private Material mat;
	
	void Start ()
	{
        mat = new Material(shaderRGB);
        mat.hideFlags = HideFlags.HideAndDontSave;
	}
	void OnRenderImage (RenderTexture source, RenderTexture destination)
	{
        grainSize = Mathf.Clamp(grainSize, 0.1f, 50.0f);
        mat.SetTexture("_GrainTex", grainTexture);
        float grainScale = 1.0f / grainSize;
        mat.SetVector("_GrainOffsetScale",
            new Vector4((float)Screen.width / (float)grainTexture.width * grainScale,
                (float)Screen.height / (float)grainTexture.height * grainScale, density, 0));
        Graphics.Blit(source, destination, mat);
	}
}
