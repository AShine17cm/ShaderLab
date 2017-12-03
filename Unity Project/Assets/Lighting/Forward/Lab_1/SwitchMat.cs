using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
public class SwitchMat : MonoBehaviour {
    public ObjectGroup[] objects;
    public Material[] mats;
    public Text tip;
    public string prefix = "当前材质为：";
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}
    public void OnBtn0()
    {
        Material newMat = null;
        for (int i=0;i<objects.Length;i++)
        {
            newMat = new Material(mats[0]);//避免Unity的动态Batch
            newMat.hideFlags = HideFlags.DontSave;
            objects[i].SetMaterial(newMat);
        }
        tip.text = prefix + newMat.name;
    }
    public void OnBtn1()
    {
        Material newMat = null;
        for (int i = 0; i < objects.Length; i++)
        {
            newMat = new Material(mats[1]);//避免Unity的动态Batch
            newMat.hideFlags = HideFlags.DontSave;
            objects[i].SetMaterial(newMat);
        }
        tip.text = prefix + newMat.name;
    }
    public void OnBtn2()
    {
        Material newMat = null;
        for (int i = 0; i < objects.Length; i++)
        {
            newMat = new Material(mats[2]);//避免Unity的动态Batch
            newMat.hideFlags = HideFlags.DontSave;
            objects[i].SetMaterial(newMat);
        }
        tip.text = prefix + newMat.name;
    }
}
