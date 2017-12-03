using UnityEngine;
using System.Collections;

public class ShadowMapping_5 : MonoBehaviour {
	
	public Shader depShader;
	public Light shadowLight;
	
	public RenderTexture lightViewZDepth;
	private Camera lightPosCam;
	
	public Camera cam;
	// Use this for initialization
	void Start () {
		
		GameObject lCam=new GameObject("LightPosCam");
        lightPosCam = lCam.AddComponent<Camera>();
        lightPosCam.CopyFrom(cam);
		lCam.transform.position=shadowLight.transform.position;
		lCam.transform.rotation=shadowLight.transform.rotation;


        lightPosCam.targetTexture = lightViewZDepth;
        lightPosCam.enabled = false;
        lightPosCam.clearFlags = CameraClearFlags.SolidColor;
		lightPosCam.transform.parent=shadowLight.transform;

	}
	void OnPreCull()
	{
			lightPosCam.RenderWithShader(depShader,"RenderType");
			Shader.SetGlobalTexture("_myShadow",lightViewZDepth);
			Shader.SetGlobalMatrix("_litMVP",lightPosCam.projectionMatrix*lightPosCam.worldToCameraMatrix);
	}
	public void Switch2LightView()
	{
		cam.enabled=false;
		lightPosCam.enabled=true;
		lightPosCam.targetTexture=null;
		Camera.SetupCurrent(lightPosCam);
	}
	public void Switch2MainView()
	{
		cam.enabled=true;
		lightPosCam.enabled=false;
		cam.targetTexture=null;
		Camera.SetupCurrent(cam);
	}
	
}
