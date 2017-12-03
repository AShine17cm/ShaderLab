using UnityEngine;
using System.Collections;
[ExecuteInEditMode]
public class LP_Lab_9 : MonoBehaviour {
    public GUISkin skin;
    public Texture[] axis;
    public Rect[] rectAx;
    public Rect[] rects;
    public string[] lables;
    public Rect[] rectSl;
    public float[] SlValue;
    public Material[] SlMat;
    //
    public Material mat;
    public Rect[] matR;
    public float[] matV;
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
        SlMat[0].SetVector("_SHAr", new Vector4(SlValue[0], SlValue[1], 0, 0));
        SlMat[1].SetVector("_SHAr", new Vector4(SlValue[2],0, SlValue[3], 0));
        SlMat[2].SetVector("_SHAr", new Vector4(0,SlValue[5], SlValue[4], 0));
        mat.SetVector("_SHAr",new Vector4(matV[0],matV[1],matV[2],matV[3]));
	}
    void OnGUI()
    {
        GUI.skin = skin;
        for (int i = 0; i < axis.Length; i++)
        {
            GUI.Label(rectAx[i],axis[i]);
        }
        for (int i = 0; i < rects.Length; i++)
        {
            GUI.Label(rects[i],lables[i]);
        }
        for (int i = 0; i < rectSl.Length; i++)
        {
            SlValue[i] = GUI.HorizontalSlider(rectSl[i], SlValue[i], -1f, 1f);
        }
        for (int i = 0; i < matR.Length; i++)
        {
            matV[i] = GUI.HorizontalSlider(matR[i], matV[i], -1f, 1f);
        }
    }
}
