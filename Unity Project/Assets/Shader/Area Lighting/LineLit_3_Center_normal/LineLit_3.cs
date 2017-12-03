using UnityEngine;
using System.Collections;

public class LineLit_3 : MonoBehaviour {
    public Transform lit;
    public Material mat;
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
        mat.SetVector("litP", lit.position);

        mat.SetVector("litN", lit.forward);
       // mat.SetVector("litR", lit.right);
        mat.SetVector("litT", lit.up);
	}
}
