using UnityEngine;
using System.Collections;

public class _ObjFuncOrder : MonoBehaviour {
    public _ObjFuncOrder one;
    //public int order;
	void Start () {
        one = this;
	}
	void Update () {
        //order++;
        //order = 0;
        Debug.Log(BigCounter.Counter + "object: Update()");
	}
    void OnBecameVisible()
    {
        //order++;
        Debug.Log(BigCounter.Counter + "object:OnBecameVisible()");
    }
    void OnBecameInvisible()
    {
        //order++;
        Debug.Log(BigCounter.Counter + "object:OnBecameInvisible()");
    }
    void OnRenderObject()
    { 
        //order++;
        Debug.Log(BigCounter.Counter + "object:OnRenderObject()");
    }
    void OnWillRenderObject()
    {
        //order++;
        Debug.Log(BigCounter.Counter + "object:OnWillRenderObject()");
    }

}
