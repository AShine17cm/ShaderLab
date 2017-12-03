using UnityEngine;
using System.Collections;

//[ExecuteInEditMode]
public class Mirror_3 : MonoBehaviour
{
    public RenderTexture refTex;
    public Matrix4x4 correction;
    public Matrix4x4 projM;
    Matrix4x4 world2ProjView;
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
        Vector3 mPos = mirCam.transform.localPosition;
        mPos.y *= -1f;
        mirCam.transform.localPosition = mPos;// into mirror
        Vector3 rt = Camera.main.transform.localEulerAngles;
        Camera.main.transform.parent = null;
        mirCam.transform.localEulerAngles = new Vector3(-rt.x, rt.y, -rt.z);//rotation mirrored

        float d = Vector3.Dot(transform.up, Camera.main.transform.position-transform.position)+0.05f;
        mirCam.nearClipPlane=d;

        // find out the reflection plane: position and normal in world space
        Vector3 pos = transform.position;
        Vector3 normal = transform.up;
        Vector4 clipPlane = CameraSpacePlane(mirCam, pos, normal, 1.0f);
        Matrix4x4 proj = cam.projectionMatrix;
        CalculateObliqueMatrix(ref proj, clipPlane);
        mirCam.projectionMatrix = proj;// you can ע�ͺͷ�ע�����д��� ��Ȼ��۲�С�����Ƿ�ᱻ����

        mirCam.targetTexture = refTex;
        mirCam.Render();//render from mirror


        Proj();//set proj matrix
        GetComponent<Renderer>().material.SetMatrix("_ProjMat", cm);

        busy = false;
        //Debug.Break();
    }
    void Proj()
    {
       world2ProjView = mirCam.transform.worldToLocalMatrix;//
        projM = mirCam.projectionMatrix;
        projM.m32 = 1f;
        cm = correction * projM * world2ProjView;
    }
    private Vector4 CameraSpacePlane(Camera cam, Vector3 pos, Vector3 normal, float sideSign)
    {
        Vector3 offsetPos = pos + normal * 0.05f;
        Matrix4x4 m = cam.worldToCameraMatrix;
        Vector3 cpos = m.MultiplyPoint(offsetPos);
        Vector3 cnormal = m.MultiplyVector(normal).normalized * sideSign;
        return new Vector4(cnormal.x, cnormal.y, cnormal.z, -Vector3.Dot(cpos, cnormal));
    }
    private static void CalculateObliqueMatrix(ref Matrix4x4 projection, Vector4 clipPlane)
    {
        Vector4 q = projection.inverse * new Vector4(
            sgn(clipPlane.x),
            sgn(clipPlane.y),
            1.0f,
            1.0f
        );
        Vector4 c = clipPlane * (2.0F / (Vector4.Dot(clipPlane, q)));
        // third row = clip plane - fourth row
        projection[2] = c.x - projection[3];
        projection[6] = c.y - projection[7];
        projection[10] = c.z - projection[11];
        projection[14] = c.w - projection[15];
    }
    private static float sgn(float a)
    {
        if (a > 0.0f) return 1.0f;
        if (a < 0.0f) return -1.0f;
        return 0.0f;
    }
}