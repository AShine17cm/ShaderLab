using UnityEngine;
using System.Collections;

public class NDC_ShowPosition : MonoBehaviour
{
    public Rect[] labels;
    public Transform trans;
    public Camera cam;
    Matrix4x4 mvp;
    Matrix4x4 vpInverse;
    Vector3 ndcPos;
    Vector3 worldPos;
    Matrix4x4 P;
    Matrix4x4 V;
    Matrix4x4 M;

    void Update()
    {
        // Notice: in some platform (such as DirectX), the NDC matrix is not the same as OpenGL projectionMatrix version.
        // Using following function instead.
        P = GL.GetGPUProjectionMatrix(cam.projectionMatrix, false);
        V = cam.worldToCameraMatrix;
        M = trans.localToWorldMatrix;
        mvp = P * V * M;
        //VP矩阵的逆，用于把一个（-1，1）clip空间的点再转换到世界空间内
        vpInverse = (P * V).inverse;
        // mvp = cam.projectionMatrix* cam.worldToCameraMatrix *trans.localToWorldMatrix;
        ndcPos = mvp.MultiplyPoint(trans.localPosition);//将一个模型坐标的点转换到Clip空间
        worldPos = vpInverse.MultiplyPoint(ndcPos);//将一个Clip空间的点转换到世界坐标空间
    }
    //实际验证时，需要拖着point父物体，而不是那个纯粹为了显示而附加的子物体
    void OnGUI()
    {
        //显示物体的世界坐标
        GUI.Label(labels[0], "Point的世界坐标 x,y,z " + trans.position.x + "  " + trans.position.y + "  " + trans.position.z);
        //显示一个点经过MVP矩阵变换之后的坐标
        GUI.Label(labels[1], "Point的NDC坐标 x,y,z " + ndcPos.x + "  " + ndcPos.y + "  " + ndcPos.z);
        //显示一个Clip空间内的点被VP矩阵的逆转换到世界坐标空间内
        GUI.Label(labels[2], "Clip变到World  x,y,z " + worldPos.x + "  " + worldPos.y + "  " + worldPos.z);
    }
}
