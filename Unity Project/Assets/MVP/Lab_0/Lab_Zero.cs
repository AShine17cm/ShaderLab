using UnityEngine;
using System.Collections;

public class Lab_Zero : MonoBehaviour {
    public Texture2D clamp;
    Rect rec;
	// Use this for initialization
	void Start () {
        rec = new Rect(0, 0, 800, 32);
	}
	
	// Update is called once per frame
	void OnGUI () {
        GUI.Label(rec, clamp);
	}
}
