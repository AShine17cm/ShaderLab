using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LightGroup : MonoBehaviour {
    public Light[] lights;
    public int lightCount;
	// Use this for initialization
	void Start () {
        int c = transform.childCount;
        lightCount = c;
        lights = new Light[c];
        for(int i=0;i<c;i++)
        {
            Light lit = transform.GetChild(i).GetComponent<Light>();
            lights[i] = lit;
        }
	}
	
	// Update is called once per frame
	void Update () {
		
	}
    public void SetProp(LightRenderMode renderMode)
    {
        foreach(Light temp in lights)
        {
            temp.renderMode = renderMode;
        }
    }
    public void SetProp(LightType litType)
    {
        foreach(Light temp in lights)
        {
            temp.type = litType;
        }
    }
}
