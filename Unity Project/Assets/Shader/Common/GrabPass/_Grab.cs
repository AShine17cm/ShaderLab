using UnityEngine;
using System.Collections;

public class _Grab : MonoBehaviour {
    public Matrix4x4 mat;
	// Use this for initialization
	void Start () {
        mat = Matrix4x4.identity;
        mat.m33 = 6;
	}
	
	// Update is called once per frame
	void Update () {
        GetComponent<Renderer>().sharedMaterial.SetMatrix("_MyMatrix",mat);
	}

}
