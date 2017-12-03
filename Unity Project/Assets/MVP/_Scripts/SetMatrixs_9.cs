using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class SetMatrixs_9: MonoBehaviour {

	public Matrix4x4 projection;
	public Matrix4x4 manual_MVP;

	public Transform compass;
	public bool _manual_MVP=true;
	static int matrixPWD = 1010;
    public Rect my;
    public int dx = 90, dy = 45;

    float n;
    float f;
    float aspect;
    public float fov;
    float d;
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
        if (!compass) MyDebug.LogError("Traget Object was not assigned", matrixPWD);

        n = Camera.main.nearClipPlane;
        f= Camera.main.farClipPlane;
        aspect= Camera.main.aspect;
        fov= Camera.main.fieldOfView*Mathf.Deg2Rad;
        d= 1f/Mathf.Tan(fov/2f);

        projection.m00 = d / aspect;
        projection.m11 = d;
        projection.m22=(n+f)/(n-f);
        projection.m23 = 2f * n * f / (n - f);
        projection.m32 = -1f;
        projection.m33 = 0;
        manual_MVP =
                projection
                * Camera.main.worldToCameraMatrix
                * compass.localToWorldMatrix;
        Shader.SetGlobalMatrix("Manual_MVP", manual_MVP);
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
                GUI.Label(new Rect(j * dx + 50, i * dy + 20, 70, 20), projection[i, j] + "");
            }
        }
        GUI.EndGroup();
    }
}
