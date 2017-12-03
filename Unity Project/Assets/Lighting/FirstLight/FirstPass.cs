using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
public class FirstPass : MonoBehaviour {
    public Camera cam;
    public Text txtPath;
	// Use this for initialization
	void Start () {
        txtPath.text = "Rendering Path:" + "  <color=red>" + cam.renderingPath + "</color>";
    }
	
	// Update is called once per frame
	void Update () {
		
	}
    public void OnBtnForward()
    {
        cam.renderingPath = RenderingPath.Forward;
        txtPath.text = "Rendering Path:" + "  <color=red>" + RenderingPath.Forward + "</color>";
    }
    public void OnBtnDeferred()
    {
        cam.renderingPath = RenderingPath.DeferredShading;
        txtPath.text = "Rendering Path:" + "  <color=red>"+ RenderingPath.DeferredShading+ "</color>";
    }
}
