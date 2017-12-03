using UnityEngine;
public class _MotionBlur_2 : MonoBehaviour
{
    public float blurAmount = 0.8f;
    public Shader shader;
    private Material mat;
    private RenderTexture accumTexture;
     void Start()
    {
#if !(UNITY_5 || UNITY_5_3_OR_NEWER)
        if(!SystemInfo.supportsRenderTextures)
        {
            enabled = false;
            return;
        }
#endif
        mat = new Material(shader);
        mat.hideFlags = HideFlags.HideAndDontSave;
    }
    void OnRenderImage (RenderTexture src, RenderTexture dst)
    {
        if (accumTexture == null)
        {
            DestroyImmediate(accumTexture);
            accumTexture = new RenderTexture(src.width, src.height, 0);
            accumTexture.hideFlags = HideFlags.HideAndDontSave;
            Graphics.Blit( src, accumTexture );
        }
        
        blurAmount = Mathf.Clamp( blurAmount, 0.0f, 1f );
        mat.SetFloat("_AccumOrig", 1.0F-blurAmount);
        
        Graphics.Blit (src, accumTexture, mat);
        Graphics.Blit (accumTexture, dst);
    }
}
