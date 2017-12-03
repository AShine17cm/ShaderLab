using UnityEngine;
using System.Collections;
public class _RenderWith_1 : MonoBehaviour {
    public GUISkin skin;
	public string replacebyTag="myTag";
	public Shader useShader;
    public Rect r1;
    public Rect r2;
	public RenderTexture rt;
	public Camera rtCam;
    public Material mat;
	// Use this for initialization
	void Start () {
        if (!rtCam)
        {
            GameObject g = new GameObject("render with Shader Cam");
            rtCam = g.AddComponent<Camera>();
            //��Ϊ���ǵ������������Ӧ��Forward��Ⱦ·����
            rtCam.renderingPath = RenderingPath.Forward;
            rtCam.enabled = false;
            rtCam.hideFlags = HideFlags.HideAndDontSave;
        }
        rt =new RenderTexture(Screen.width, Screen.height, 16);
	}

    void OnGUI()
    {
        GUI.skin = skin;
        string[] ns = useShader.name.Split('/');
        GUI.Label(r1,"Current Render With Shader:  "+ns[ns.Length-1]);
        GUI.Label(r2,"Target Texture >>");
    }
	void OnPreCull()
	{
        rtCam.CopyFrom(this.GetComponent<Camera>());
        rtCam.backgroundColor = new Color(0, 0, 0, 0);
        rtCam.targetTexture = rt;
		rtCam.RenderWithShader(useShader,replacebyTag);
        mat.SetTexture("_MainTex", rt);
	}
    
}
