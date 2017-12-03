using UnityEngine;
using System.Collections;

public class _LitTexB0 : MonoBehaviour {
    
    public GUISkin skin;
    public Texture texB0;
    public Rect recT;
    public Renderer rd;
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}
    void OnGUI()
    {
        GUI.skin = skin;
        if(GUI.Button(recT,"Switch _LightTextureB0"))
        {
            rd.sharedMaterial.SetTexture("_LightTextureB0",texB0);
        }
    }
}
