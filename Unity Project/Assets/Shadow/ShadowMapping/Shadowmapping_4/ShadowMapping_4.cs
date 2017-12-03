using UnityEngine;
using System.Collections;

public class ShadowMapping_4 : MonoBehaviour {
	
	public Shader depShader;
	public Light shadowLight;
	
	public RenderTexture lightViewZDepth;
	private Camera lightPosCam;
	
	public RenderTexture camViewZDepth;
	public Camera cam;
	private Camera shadeCam;
	//
	public GUISkin skin;
	
	//Project Shadow Map
    Matrix4x4 model2World;
    Matrix4x4 world2ProjView;
    Matrix4x4 projM;
    Matrix4x4 correction;
    Matrix4x4 cm;
    float n=0.3f;
    float f=60f;
    float aspect=1f;
    float fov=1f;
    float d;

	// Use this for initialization
	void Awake () {
        correction = Matrix4x4.identity;
        correction.SetColumn(3,new Vector4(0.5f,0.5f,0.5f,1f));
        correction.m00 = 0.5f;
        correction.m11 = 0.5f;
        correction.m22 = 0.5f;
		
		aspect=cam.aspect;
	}
	// Use this for initialization
	void Start () {
		GameObject lCam=new GameObject("LightPosCam");
        lightPosCam = lCam.AddComponent<Camera>();
        lightPosCam.CopyFrom(cam);
		lCam.transform.position=shadowLight.transform.position;
		lCam.transform.rotation=shadowLight.transform.rotation;

        lightPosCam.transform.parent = shadowLight.transform;
        lightPosCam.clearFlags=CameraClearFlags.SolidColor;
		
		///*
		GameObject shadeObj=new GameObject("ShadeCamera");
        shadeCam = shadeObj.AddComponent<Camera>();
        shadeCam.clearFlags = CameraClearFlags.SolidColor;
        shadeCam.CopyFrom(cam);
        shadeCam.enabled = false;
        shadeObj.transform.position=cam.transform.position;
		shadeObj.transform.rotation=cam.transform.rotation;
        shadeCam.depth = cam.depth + 1;
		//*/
        cam.depthTextureMode = DepthTextureMode.Depth;
        //
    }
	
	// Update is called once per frame
	void Update () {

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
	public void RenderLightViewZDepth()
	{
		lightPosCam.targetTexture=lightViewZDepth;
		lightPosCam.depthTextureMode=DepthTextureMode.Depth;
        //
        lightPosCam.RenderWithShader(depShader, "RenderType");
        Shader.SetGlobalTexture("_myShadow", lightViewZDepth);
        Proj();
    }
	public void RenderCamViewZDepth()
	{
		shadeCam.targetTexture=camViewZDepth;
		shadeCam.depthTextureMode=DepthTextureMode.Depth;
        //
        shadeCam.RenderWithShader(depShader, "RenderType");
        Shader.SetGlobalTexture("_myZDepth", camViewZDepth);
        Proj();
    }
	public void Proj()
    {
        model2World = Matrix4x4.identity;
        world2ProjView = shadowLight.transform.worldToLocalMatrix;//
        //world2ProjView = Camera.main.worldToCameraMatrix * world2ProjView;
        //n = Camera.main.near;
        //f = Camera.main.far;
        //aspect = Camera.main.aspect;
        //fov = Camera.main.fieldOfView * Mathf.Deg2Rad;
        d = 1f / Mathf.Tan(fov / 2f);

        projM.m00 = d / aspect;
        projM.m11 = d;
        projM.m22 = (n + f) / (n - f);
        projM.m23 = 2f * n * f / (n - f);
        projM.m32 = 1f;
        projM.m33 = 0;

        cm = correction * projM * world2ProjView * model2World;
        Shader.SetGlobalMatrix("_myShadowProj", cm);
    }
}
