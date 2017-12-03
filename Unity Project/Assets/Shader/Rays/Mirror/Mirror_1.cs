using UnityEngine;
using System.Collections;

//[ExecuteInEditMode]
public class Mirror_1 : MonoBehaviour
{
    private Camera mirCam;
    void Start()
    {
        if (mirCam) return;
        GameObject g = new GameObject("Mirror Camera");
        mirCam=g.AddComponent<Camera>();
        mirCam.enabled = false;
    }
    public void OnWillRenderObject()
    {
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
        mirCam.transform.localEulerAngles = new Vector3(-rt.x,rt.y,-rt.z);//rotation mirrored
    }
}