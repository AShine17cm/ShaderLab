using UnityEngine;
using System.Collections;

public class FirstShader : MonoBehaviour
{
    public Material mat;
    public Texture myPic;
    public Color purple;
    public Cubemap cube;
    public Vector4 vec;
    public float val_1;
    public float val_2;

    public Matrix4x4 matrix;
    void Update()
    {
        //
        mat.SetTexture("_MyTexture", myPic);
        mat.SetColor("_MyColor", purple);
        mat.SetTexture("_MyCube", cube);
        mat.SetVector("_MyVector", vec);
        mat.SetFloat("_MyFloat", val_1);
        mat.SetFloat("_MyRange", val_2);
        //
        myPic = mat.GetTexture("_MyTexture");
        purple = mat.GetColor("_MyColor");
        cube = (Cubemap)mat.GetTexture("_MyCube");
        vec = mat.GetVector("_MyVector");
        val_1 = mat.GetFloat("_MyFloat");
        val_2 = mat.GetFloat("_MyRange");
        //
        mat.SetMatrix("myMatrix", matrix);
        matrix = mat.GetMatrix("myMatrix");
    }
}
