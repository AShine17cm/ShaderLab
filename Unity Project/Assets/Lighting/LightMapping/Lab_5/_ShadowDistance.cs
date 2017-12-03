using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class _ShadowDistance : MonoBehaviour {

    public GUISkin skin;
    public Rect rectL;
    public string lab;
    public float dist;
    public float d;
    public Rect rectS;
	// Use this for initialization
	void Start () {
        //dist = QualitySettings.shadowDistance;
        dist = 50;
        d = 1;
	}
	
	// Update is called once per frame
	void Update () {
        QualitySettings.shadowDistance = dist * d;
	}
    void OnGUI()
    {
        GUI.skin = skin;
        GUI.Label(rectL, lab);
        d = GUI.HorizontalSlider(rectS, d, 0, 1);
    }
}
