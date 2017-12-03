using UnityEngine;
using System.Collections;

public class _ColorCorrection_1 : MonoBehaviour {
    public AnimationCurve redChannel;
	public AnimationCurve greenChannel;
	public AnimationCurve blueChannel;
	private Material ccMat;
    private Texture2D rgbChannelTex;
	public Shader cccShader;
	void Start () {
        ccMat = new Material(cccShader);
        rgbChannelTex = new Texture2D(256, 4, TextureFormat.ARGB32, false, true);
        rgbChannelTex.hideFlags = HideFlags.DontSave;
        rgbChannelTex.wrapMode = TextureWrapMode.Clamp;
	}
	void Update () {
        for (float i = 0.0f; i <= 1.0f; i += 1.0f / 255.0f)
        {
            float rCh = Mathf.Clamp(redChannel.Evaluate(i), 0.0f, 1.0f);
            float gCh = Mathf.Clamp(greenChannel.Evaluate(i), 0.0f, 1.0f);
            float bCh = Mathf.Clamp(blueChannel.Evaluate(i), 0.0f, 1.0f);
            rgbChannelTex.SetPixel(Mathf.FloorToInt(i * 255.0f), 0, new Color(rCh, rCh, rCh));
            rgbChannelTex.SetPixel(Mathf.FloorToInt(i * 255.0f), 1, new Color(gCh, gCh, gCh));
            rgbChannelTex.SetPixel(Mathf.FloorToInt(i * 255.0f), 2, new Color(bCh, bCh, bCh));
        }
        rgbChannelTex.Apply();
	}
    void OnRenderImage (RenderTexture source,RenderTexture destination) {
        ccMat.SetTexture ("_rgbTex", rgbChannelTex);
		Graphics.Blit (source, destination, ccMat); 			
	}
}
