using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class SetMatrixs_3: MonoBehaviour {

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
         model2World.SetTRS(compass.position, compass.rotation, compass.lossyScale);
		manual_MVP= 
				Camera.main.projectionMatrix
				*Camera.main.worldToCameraMatrix
				*model2World;
		Shader.SetGlobalMatrix("Manual_MVP",manual_MVP);
	}
    //根据Unity开发者Aras的回答，也就是说非均匀的缩放将会改变物体的顶点相对关系，从而改变了物体的形态
    //if( renderer.transform.lossyScale.x == renderer.transform.lossyScale.y && renderer.transform.lossyScale.x == renderer.transform.lossyScale.z )
    //    {
    //       renderer.sharedMaterial.SetMatrix( "_CustomMatrix", renderer.localToWorldMatrix );
    //    }
    //    else
    //    {
    //       renderer.sharedMaterial.SetMatrix( "_CustomMatrix", Matrix4x4.TRS( renderer.transform.position, renderer.transform.rotation, Vector3.one );
    //    }
}
