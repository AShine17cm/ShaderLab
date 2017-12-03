using UnityEngine;
using System.Collections;
public class _SetQueue : MonoBehaviour {
    public GUISkin skin;
    public Material[] matsLeft;
    public Material[] matsRight;
    public Rect[] rLabels;
    public Rect[] rSlider;
    public int[] iQueue;
    public Rect[] labels;

	void Start () {
        for (int i = 0; i < matsLeft.Length; i++)
        {
            matsLeft[i].renderQueue = i + 1;
            matsRight[i].renderQueue = i + 1;
            iQueue[i] = i + 1;
        }
	}
    void Update()
    {
        for (int i = 0; i < iQueue.Length; i++)
        {
            matsLeft[i].renderQueue = iQueue[i];
            matsRight[i].renderQueue = iQueue[i];
        }
	}
    void OnGUI()
    {
        GUI.skin = skin;
        for (int i = 0; i < matsLeft.Length; i++)
        {
            GUI.Label(rLabels[i],"Render Queue: "+matsLeft[i].renderQueue+"  of "+matsLeft[i].name);
        }
        for (int i = 0; i < rSlider.Length; i++)
        { 
            iQueue[i]=(int)GUI.HorizontalSlider(rSlider[i],iQueue[i],1,4);
        }
        GUI.Label(labels[0], "ZTest LEqual");
        GUI.Label(labels[1], "ZTest Always");
    }
}
