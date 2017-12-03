using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class SetMatrixs_4: MonoBehaviour {

	public Matrix4x4 model2World;
	public Matrix4x4 manual_MVP;
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
		 if (!compass) MyDebug.LogError("Target Object was not assigned",matrixPWD);

		manual_MVP= 
				Camera.main.projectionMatrix
				*Camera.main.worldToCameraMatrix
				*compass.localToWorldMatrix;
		Shader.SetGlobalMatrix("Manual_MVP",manual_MVP);
	}
}
