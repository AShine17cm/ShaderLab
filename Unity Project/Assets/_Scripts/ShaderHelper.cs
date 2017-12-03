using UnityEngine;
using System.Collections;

public class ShaderHelper  {

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}

    // Converts color to luminance (grayscale)
 public static float Luminance( Color c )
{
    Vector3 v = new Vector3(0.22f, 0.707f, 0.071f);
    Vector3 vc = new Vector3(c.r, c.g, c.b);
	return Vector3.Dot( vc, v);
}
}
