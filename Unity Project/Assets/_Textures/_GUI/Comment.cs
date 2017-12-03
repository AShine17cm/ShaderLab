using UnityEngine;
using System.Collections;
[ExecuteInEditMode]
public class Comment : MonoBehaviour {
	
	public GUISkin skin;
	public string cText;
	public Rect cRect=new Rect(0,500,800,100);
	// Use this for initialization
	void Start () {
		cRect.width=Screen.width;
	}
	
	// Update is called once per frame
	void Update () {
	
	}
	void OnGUI()
	{
		GUI.skin=skin;
		GUI.Label(cRect,cText);
		
		
	}
}
