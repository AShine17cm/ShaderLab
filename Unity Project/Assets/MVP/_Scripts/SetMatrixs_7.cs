using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class SetMatrixs_7: MonoBehaviour {

	public Matrix4x4 world2View;
	public Matrix4x4 manual_MVP;
    Matrix4x4 inverseZ;
	public Transform compass;
	public bool _manual_MVP=true;
	static int matrixPWD = 1010;
	
	void Update () {
        UpdateMatrix();
	}
	
    void UpdateMatrix()
    {
		if(_manual_MVP)
			Set_Manual_MVP();
    }

	void Set_Manual_MVP()
	{
		 if (!compass) MyDebug.LogError("Traget Object was not assigned",matrixPWD);
         
         inverseZ.SetTRS(Vector3.zero, Quaternion.identity, new Vector3(1, 1, -1));
         world2View.SetTRS(
             -Camera.main.transform.position,
             Quaternion.identity, 
             Vector3.one);
         world2View =  inverseZ*world2View;
		manual_MVP= 
				Camera.main.projectionMatrix
				*world2View
				*compass.localToWorldMatrix;
		Shader.SetGlobalMatrix("Manual_MVP",manual_MVP);
	}
}
