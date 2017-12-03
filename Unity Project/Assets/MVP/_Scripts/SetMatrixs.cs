using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class SetMatrixs : MonoBehaviour {

    public Matrix4x4 model2MySpace;
	public Matrix4x4 model2World;
    public Transform neoSpace;
	public Transform compass;
    static int matrixPWD = 1010;

	public bool manual_MVP=true;
	
	// Update is called once per frame
	void Update () {
        UpdateMatrix();
	}
    void UpdateMatrix()
    {
        //SetModel2MySpace();
		if(manual_MVP)
			Set_UNITY_MATRIX_MVP();
    }
    void SetModel2MySpace()
    {
        if (!neoSpace) MyDebug.LogError("Traget Space was not assigned",matrixPWD);
        model2MySpace.SetTRS(neoSpace.position, Quaternion.identity, Vector3.one);
		model2World.SetTRS(compass.position,Quaternion.identity,Vector3.one);
		
		model2MySpace= Camera.main.projectionMatrix*Camera.main.worldToCameraMatrix*model2World*model2MySpace;
		Shader.SetGlobalMatrix("_neoMatrix",model2MySpace);
    }
	void Set_UNITY_MATRIX_MVP()
	{
		 if (!neoSpace) MyDebug.LogError("Traget Space was not assigned",matrixPWD);
		
		model2World.SetTRS(compass.position,Quaternion.identity,Vector3.one);
		
		model2MySpace= Camera.main.projectionMatrix*Camera.main.worldToCameraMatrix*model2World;
		Shader.SetGlobalMatrix("Manual_MVP",model2MySpace);
		
	}
}
