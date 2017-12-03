using UnityEngine;
using System.Collections;

public enum ColorCorrectionModex
{
    Simple = 0,
    Advanced = 1
}
public class _ColorCorrectionx : MonoBehaviour {
    public AnimationCurve redChannel;
	public AnimationCurve greenChannel;
	public AnimationCurve blueChannel;
	
	public bool useDepthCorrection  = false;
	
	public AnimationCurve zCurve ;
	public AnimationCurve depthRedChannel ;
	public AnimationCurve depthGreenChannel;
	public AnimationCurve depthBlueChannel;
	
	private Material ccMaterial;
	private Material ccDepthMaterial;
	private Material selectiveCcMaterial;
	
	private Texture2D rgbChannelTex ;
	private Texture2D rgbDepthChannelTex ;
	private Texture2D zCurveTex;
	
	public bool selectiveCc  = false;
	
	public Color selectiveFromColor = Color.white;
	public Color selectiveToColor = Color.white;
	
	public ColorCorrectionModex mode;
	
	public bool updateTextures  = true;		
		
	public Shader colorCorrectionCurvesShader=null;
	public Shader simpleColorCorrectionCurvesShader = null;
	public Shader colorCorrectionSelectiveShader= null;
			
	private bool updateTexturesOnStartup = true;
	// Use this for initialization
	void Start () {
        ccMaterial = new Material(simpleColorCorrectionCurvesShader);
        ccDepthMaterial = new Material(colorCorrectionCurvesShader);
        selectiveCcMaterial = new Material(colorCorrectionSelectiveShader);

        updateTexturesOnStartup = true;
        rgbChannelTex = new Texture2D(256, 4, TextureFormat.ARGB32, false, true);
        rgbDepthChannelTex = new Texture2D(256, 4, TextureFormat.ARGB32, false, true);
        zCurveTex = new Texture2D(256, 1, TextureFormat.ARGB32, false, true);

        rgbChannelTex.hideFlags = HideFlags.DontSave;
        rgbDepthChannelTex.hideFlags = HideFlags.DontSave;
        zCurveTex.hideFlags = HideFlags.DontSave;

        rgbChannelTex.wrapMode = TextureWrapMode.Clamp;
        rgbDepthChannelTex.wrapMode = TextureWrapMode.Clamp;
        zCurveTex.wrapMode = TextureWrapMode.Clamp;	
	}
	
	// Update is called once per frame
	void Update () {
	
	}
    public void UpdateParameters() 
	{			
			for (float i  = 0.0f; i <= 1.0f; i += 1.0f / 255.0f) {
				float rCh = Mathf.Clamp (redChannel.Evaluate(i), 0.0f, 1.0f);
				float gCh = Mathf.Clamp (greenChannel.Evaluate(i), 0.0f, 1.0f);
				float bCh = Mathf.Clamp (blueChannel.Evaluate(i), 0.0f, 1.0f);
				
				rgbChannelTex.SetPixel (Mathf.FloorToInt(i*255.0f), 0,new Color(rCh,rCh,rCh) );
                rgbChannelTex.SetPixel(Mathf.FloorToInt(i * 255.0f), 1, new Color(gCh, gCh, gCh));
                rgbChannelTex.SetPixel(Mathf.FloorToInt(i * 255.0f), 2, new Color(bCh, bCh, bCh));

				float zC = Mathf.Clamp (zCurve.Evaluate(i), 0.0f,1.0f);

                zCurveTex.SetPixel(Mathf.FloorToInt(i * 255.0f), 0, new Color(zC, zC, zC));
			
				rCh = Mathf.Clamp (depthRedChannel.Evaluate(i), 0.0f,1.0f);
				gCh = Mathf.Clamp (depthGreenChannel.Evaluate(i), 0.0f,1.0f);
				bCh = Mathf.Clamp (depthBlueChannel.Evaluate(i), 0.0f,1.0f);

                rgbDepthChannelTex.SetPixel(Mathf.FloorToInt(i * 255.0f), 0, new Color(rCh, rCh, rCh));
                rgbDepthChannelTex.SetPixel(Mathf.FloorToInt(i * 255.0f), 1, new Color(gCh, gCh, gCh));
                rgbDepthChannelTex.SetPixel(Mathf.FloorToInt(i * 255.0f), 2, new Color(bCh, bCh, bCh));
			}
			
			rgbChannelTex.Apply ();
			rgbDepthChannelTex.Apply ();
			zCurveTex.Apply ();				
	}

    void UpdateTextures()
    {
        UpdateParameters();
    }
    void OnRenderImage (RenderTexture source,RenderTexture destination) {
		
		if (updateTexturesOnStartup) {
			UpdateParameters ();
			updateTexturesOnStartup = false;
		}
		
		if (useDepthCorrection)
			GetComponent<Camera>().depthTextureMode |= DepthTextureMode.Depth;			
		
		RenderTexture renderTarget2Use= destination;
		
		if (selectiveCc) {
			renderTarget2Use = RenderTexture.GetTemporary (source.width, source.height);
		}
		
		if (useDepthCorrection) {
			ccDepthMaterial.SetTexture ("_RgbTex", rgbChannelTex);
			ccDepthMaterial.SetTexture ("_ZCurve", zCurveTex);
			ccDepthMaterial.SetTexture ("_RgbDepthTex", rgbDepthChannelTex);
	
			Graphics.Blit (source, renderTarget2Use, ccDepthMaterial); 	
		} 
		else {
			ccMaterial.SetTexture ("_RgbTex", rgbChannelTex);
			Graphics.Blit (source, renderTarget2Use, ccMaterial); 			
		}
		
		if (selectiveCc) {
			selectiveCcMaterial.SetColor ("selColor", selectiveFromColor);
			selectiveCcMaterial.SetColor ("targetColor", selectiveToColor);
			Graphics.Blit (renderTarget2Use, destination, selectiveCcMaterial); 	
			
			RenderTexture.ReleaseTemporary (renderTarget2Use);
		}
	}
}
