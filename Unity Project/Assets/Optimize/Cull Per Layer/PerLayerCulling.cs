using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PerLayerCulling : MonoBehaviour {
    public Camera cam;
    public float[] perLayerCulls;//0 is Camera.farClip
    
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
        cam.layerCullDistances = perLayerCulls;
        //if (Input.GetKeyUp(KeyCode.A))
        //{
        //    cam.layerCullDistances = perLayerCulls;
        //}
	}
}
