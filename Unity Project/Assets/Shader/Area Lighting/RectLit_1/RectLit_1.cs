using UnityEngine;
using System.Collections;

public class RectLit_1 : MonoBehaviour {
    public Transform lit;
    public Material mat;
	
	// Update is called once per frame
	void Update () {
        mat.SetVector("litP", lit.position);
        
        mat.SetVector("litN", lit.forward);
        mat.SetVector("litR", lit.right);
        mat.SetVector("litT", lit.up);
	}
}
