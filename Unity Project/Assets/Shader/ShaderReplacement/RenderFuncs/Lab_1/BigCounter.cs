using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BigCounter {
    static int _counter = -1;
    public static string Counter
    {
        get {   _counter = _counter + 1;return "Frame."+Time.frameCount+" counter."+_counter+"  .";  }
    }
    public static void Reset()
    {
        _counter = -1;
    }
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
