using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class SetMatrixs_8: MonoBehaviour {

	public Matrix4x4 world2View;
	public Matrix4x4 manual_MVP;
    Matrix4x4 inverseZ;
	public Transform compass;
	public bool _manual_MVP=true;
	static int matrixPWD = 1010;
    public Rect my;
    public int dx = 90, dy = 45;
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
             Vector3.zero,
             Camera.main.transform.localRotation, 
             Vector3.one);

         world2View = world2View.transpose;

         Vector4 dp = world2View * Camera.main.transform.position;
         dp = new Vector4(dp.x, dp.y, dp.z, -1);

         world2View.SetColumn(3, -dp);
         world2View = inverseZ * world2View;

		manual_MVP= 
				Camera.main.projectionMatrix
				*world2View
				*compass.localToWorldMatrix;
		Shader.SetGlobalMatrix("Manual_MVP",manual_MVP);
	}
    void OnGUI()
    {
        GUI.BeginGroup(my);
        GUI.Label(new Rect(0, 0, 60, 20), "Row&Col");
        for (int i = 0; i < 4; i++)
        {
            GUI.Label(new Rect(0, i * dy + 20, 70, 20), "   R:" + i);//Display Row label
            for (int j = 0; j < 4; j++)
            {
                GUI.Label(new Rect(j * dx + 50, i * dy + 20, 70, 20), world2View[i, j] + "");
            }
        }
        GUI.EndGroup();
    }
}
