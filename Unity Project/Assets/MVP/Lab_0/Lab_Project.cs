using UnityEngine;
using System.Collections;
[ExecuteInEditMode]
public class Lab_Project : MonoBehaviour
{
    //public Transform tex;
    public GUISkin skin;
    public Transform projector;
    public Matrix4x4 world2ProjView;
    public Matrix4x4 projM;

    // float n=1f;
    public float f = 10f;
    // float aspect=1f;
    public float fov = 1f;
    //float d;

    public Rect r;
    public Rect[] rs;
    public string[] strs;
    public Camera projCamera;
    public Camera mainC;

    public bool go = false;
    public Vector3 resul;
    public Vector3 resul2;
    public Transform viewPoint;
    // Use this for initialization
    void Awake()
    {
        resul = new Vector3(0, 0, 0);
    }

    // Update is called once per frame
    void Update()
    {
        Proj();
        Shader.SetGlobalVector("viewPos", transform.localPosition);
    }
    void OnGUI()
    {
        GUI.skin = skin;
        MyMatrix.DisplayMatrix(projM, r);

        if (GUI.Button(rs[0], strs[0]))
        {
            projCamera.depth = 0;
            mainC.depth = -1;
        }
        if (GUI.Button(rs[1], strs[1]))
        {
            mainC.depth = 0;
            projCamera.depth = -1;
        }
    }
    void Proj()
    {
        world2ProjView = projector.worldToLocalMatrix;//

        projM = projCamera.projectionMatrix;
        // projCamera.
        resul = projM.MultiplyPoint(viewPoint.localPosition);//
        //resul = projM.MultiplyPoint3x4(viewPoint.localPosition);//
        if (go) return;
        projM.m23 = 0;
        projM.m32 = 0;
        projM.m33 = 1;
        resul2 = projM.MultiplyPoint(viewPoint.localPosition);//
    }
}
