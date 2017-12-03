using UnityEngine;
using System.Collections;
public class _MoveObj : MonoBehaviour {
    public GUISkin skin;
    public Transform objTr;
    public float dz;
    public Rect rt;
    Vector3 oriPos;
	void Start () {
        oriPos = objTr.position;
	}
    void Update()
    {
        objTr.position = oriPos - new Vector3(0, 0, dz);
        //objTr.position = objTr.position - new Vector3(0, 0, 0.1f);//For Screen Capture
    }
    void OnGUI()
    {
        GUI.skin = skin;
        dz = GUI.HorizontalSlider(rt,dz,-5,5);
    }
}
