using UnityEngine;
using System.Collections;

public class _SetViewPos : MonoBehaviour {
    public Transform viewPoint;
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
        //renderer.material.SetVector("viewPos", viewPoint.localPosition);
        Shader.SetGlobalVector("viewPos", viewPoint.localPosition);
	}
}
