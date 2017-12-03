using UnityEngine;
using System.Collections;

//[ExecuteInEditMode]
public class Mirror_2 : MonoBehaviour
{
    public RenderTexture refTex;
    public Matrix4x4 correction;
    public Matrix4x4 projM;
    Matrix4x4 world2MirCam;
    public Matrix4x4 cm;

    private Camera mirCam;
    private bool busy = false;
    void Start()
    {
        if (mirCam) return;
        GameObject g = new GameObject("Mirror Camera");
        mirCam=g.AddComponent<Camera>();
        mirCam.enabled = false;

        refTex = new RenderTexture(800, 600,16);
        refTex.hideFlags = HideFlags.DontSave;
        mirCam.targetTexture = refTex;
        GetComponent<Renderer>().material.SetTexture("_RefTex", refTex);

        correction = Matrix4x4.identity;
        correction.SetColumn(3, new Vector4(0.5f, 0.5f, 0.5f, 1f));
        correction.m00 = 0.5f;
        correction.m11 = 0.5f;
        correction.m22 = 0.5f;

    }
    void Update()
    {
        GetComponent<Renderer>().material.SetTexture("_RefTex", refTex);
    }
    void OnWillRenderObject()
    {
        if (busy) return;
        busy = true;
        //
        //prepare mirror camera
        //if you worked in editor,you would better choose Camera.main,else Camera.current is the camera worked for editor view port
        Camera cam = Camera.main;
        mirCam.CopyFrom(cam);

        mirCam.transform.parent = transform;
        Camera.main.transform.parent = transform;

       Vector3 mPos= mirCam.transform.localPosition;
        mPos.y *= -1f;
        mirCam.transform.localPosition = mPos;// into mirror

        Vector3 rt = Camera.main.transform.localEulerAngles;
        Camera.main.transform.parent = null;
        mirCam.transform.localEulerAngles = new Vector3(-rt.x,rt.y,-rt.z);//rotation mirrored

        mirCam.targetTexture = refTex;
        mirCam.Render();//render from mirror

        Proj();//set proj matrix
        GetComponent<Renderer>().material.SetMatrix("_ProjMat", cm);

        busy = false;
    }
    void Proj()
    {
       world2MirCam = mirCam.transform.worldToLocalMatrix;//
        projM = mirCam.projectionMatrix;
        projM.m32 = 1f;
        cm = correction * projM * world2MirCam;
    }
}