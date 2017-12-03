using UnityEngine;
using System.Collections;

public class LineLit_1 : MonoBehaviour {
    public Transform lit;
    public Material mat;
	void Update () {
        mat.SetVector("litP", lit.position);
       // mat.SetVector("litN", lit.forward);
       // mat.SetVector("litR", lit.right);
        mat.SetVector("litT", lit.up);
	}
}
