using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObjectGroup : MonoBehaviour {
    public MeshRenderer[] renders;
	// Use this for initialization
	void Start () {
        renders=transform.GetComponentsInChildren<MeshRenderer>();
	}
	public void SetMaterial(Material mat)
    {
        for(int i=0;i<renders.Length;i++)
        {
            renders[i].material = mat;
        }
    }
}
