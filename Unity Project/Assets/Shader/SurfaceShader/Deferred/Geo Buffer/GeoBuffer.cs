using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GeoBuffer : MonoBehaviour {
    public Material displayMat0;
    public Material displayMat1;
    public Material displayMat2;
    public Material displayMat3;
    public Material displayMat4;
    public MeshRenderer render;
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}
    public void OnDisplayGeo0()
    {
        render.material = displayMat0;
    }
    public void OnDisplayGeo1()
    {
        render.material = displayMat1;
    }
    public void OnDisplayGeo2()
    {
        render.material = displayMat2;
    }
    public void OnDisplayGeo3()
    {
        render.material = displayMat3;
    }
    public void OnDisplayGeo4()
    {
        render.material = displayMat4;
    }
}
