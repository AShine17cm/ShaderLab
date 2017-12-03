using UnityEngine;
using System.Collections;

public class _ColorCorrection_0 : MonoBehaviour {
    public AnimationCurve redChannel;
	public AnimationCurve greenChannel;
	public AnimationCurve blueChannel;
	private Material ccMat;
    private Texture2D rChannelTex;
    private Texture2D gChannelTex;
	private Texture2D bChannelTex ;
	public Shader cccShader;
    //
    public GUISkin skin;
    public Rect[] rects;
    public Rect rect;
	// Use this for initialization
	void Start () {
        ccMat = new Material(cccShader);
        rChannelTex = new Texture2D(256, 32, TextureFormat.ARGB32, false, true);
        gChannelTex = new Texture2D(256, 32, TextureFormat.ARGB32, false, true);
        bChannelTex = new Texture2D(256, 32, TextureFormat.ARGB32, false, true);
        rChannelTex.hideFlags = HideFlags.DontSave;
        rChannelTex.wrapMode = TextureWrapMode.Clamp;
        gChannelTex.hideFlags = HideFlags.DontSave;
        gChannelTex.wrapMode = TextureWrapMode.Clamp;
        bChannelTex.hideFlags = HideFlags.DontSave;
        bChannelTex.wrapMode = TextureWrapMode.Clamp;
	}
	
	// Update is called once per frame
	void Update () {
        for (float i = 0.0f; i <= 1.0f; i += 1.0f / 255.0f)
        {
            float rCh = Mathf.Clamp(redChannel.Evaluate(i), 0.0f, 1.0f);
            float gCh = Mathf.Clamp(greenChannel.Evaluate(i), 0.0f, 1.0f);
            float bCh = Mathf.Clamp(blueChannel.Evaluate(i), 0.0f, 1.0f);
            for (int j = 0; j < 32; j++)
            {
                rChannelTex.SetPixel(Mathf.FloorToInt(i * 255.0f), j, new Color(rCh, 0, 0));
                gChannelTex.SetPixel(Mathf.FloorToInt(i * 255.0f), j, new Color(0, gCh, 0));
                bChannelTex.SetPixel(Mathf.FloorToInt(i * 255.0f), j, new Color(0, 0, bCh));
            }
        }
        rChannelTex.Apply();
        gChannelTex.Apply();
        bChannelTex.Apply();
	}
    void OnGUI()
    {
        GUI.skin = skin;
        GUI.Box(rects[0], rChannelTex);
        GUI.Box(rects[1], gChannelTex);
        GUI.Box(rects[2], bChannelTex);
    }
    void OnRenderImage (RenderTexture source,RenderTexture destination) {

        ccMat.SetTexture ("_rTex", rChannelTex);
        ccMat.SetTexture("_gTex", gChannelTex);
        ccMat.SetTexture("_bTex", bChannelTex);
		Graphics.Blit (source, destination, ccMat); 			
	}
}
