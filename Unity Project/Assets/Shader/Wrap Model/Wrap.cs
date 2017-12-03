using UnityEngine;
using System.Collections;

public class Wrap : MonoBehaviour {
    public GUISkin skin;
    public Rect[] rs;
    public string[] str;
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void OnGUI () {
        GUI.skin = skin;
        for(int i=0;i<rs.Length;i++)
        {
            GUI.Label(rs[i], str[i]);
        }
	}
}
