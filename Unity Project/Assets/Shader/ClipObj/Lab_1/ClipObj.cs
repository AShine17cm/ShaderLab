using UnityEngine;
using System.Collections;

public class ClipObj : MonoBehaviour {
	public Transform clipObj;
	public Material mat;
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		Vector3 cpos = clipObj.position;
		Vector4 cnor = clipObj.up;
		mat.SetVector ("cPos",new Vector4(cpos.x,cpos.y,cpos.z,1) );//第四个元素为1,而不是0，可确保平移
		mat.SetVector ("cNormal",new Vector4(cnor.x,cnor.y,cnor.z,0) );
	}
}
