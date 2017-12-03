using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Test_LodGroup : MonoBehaviour {
    public LODGroup lodGroup;
    public LOD[] lods;
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update ()
    {
		if(Input.GetKeyUp(KeyCode.A))
        {
            lods = lodGroup.GetLODs();
            
        }
	}
}
