using UnityEngine;
using System.Collections;

public class ShadowMapping_2 : MonoBehaviour {
	
	public Shader depShader;
	public Light shadowLight;
	
	private Camera lightPosCam;
	public Camera cam;
	
	// Use this for initialization
	void Start () {
		GameObject lCam=new GameObject("LightPosCam");
        lightPosCam = lCam.AddComponent<Camera>();
        lightPosCam.CopyFrom(cam);
        lCam.transform.position=shadowLight.transform.position;
		lCam.transform.rotation=shadowLight.transform.rotation;
		
		lightPosCam.depthTextureMode=DepthTextureMode.Depth;
		lightPosCam.enabled=false;
		lightPosCam.clearFlags=CameraClearFlags.Depth;
		lightPosCam.depth=-1;
		
    }
	
	// Update is called once per frame
	void Update () {
	
	}
	public void Switch2LightView()
	{
		cam.enabled=false;
		lightPosCam.enabled=true;
		//lightPosCam.targetTexture=null;
		Camera.SetupCurrent(lightPosCam);
        lightPosCam.SetReplacementShader(null, "");
    }
	public void Switch2MainView()
	{
		cam.enabled=true;
		lightPosCam.enabled=false;
		Camera.SetupCurrent(cam);
        cam.SetReplacementShader(null, "");
    }
	public void RenderLightViewZDepth()
	{
		cam.enabled=false;
		lightPosCam.enabled=true;
		lightPosCam.depthTextureMode=DepthTextureMode.Depth;
		Camera.SetupCurrent(lightPosCam);
        lightPosCam.SetReplacementShader(depShader, "RenderType");
    }
	public void RenderCamViewZDepth()
	{
		cam.enabled=true;
		lightPosCam.enabled=false;
		cam.depthTextureMode=DepthTextureMode.Depth;
		Camera.SetupCurrent(cam);
        cam.SetReplacementShader(depShader, "RenderType");
    }
}
