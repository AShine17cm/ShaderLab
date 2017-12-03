using UnityEngine;
using System.Collections;
public class _Offset_2 : MonoBehaviour
{
    public GUISkin skin;
    public Renderer rd;
    public Texture tex;
    public Rect ri;
    public Rect rj;
    public Rect r1;
    public int i, j;
    public int mi, mj;
    Material mat;
    //string part1 = " Shader \"Offset";
    //string part2 = "\" { ";
    //string part3 = " Properties{ "
    //    + " _MainTex(\"_MainTex\",2D)=\"white\"{}"
    //    + "} "
    //    + "SubShader{"
    //    + " Tags{\"RenderType\"=\"Opaque\" \"Queue\"=\"Geometry+300\"}"
    //    + " ZWrite Off ZTest Greater"
    //    + " pass{ ";
    //string part4 = " Material{Diffuse(1,1,1,1) }"
    //    + " Lighting On"
    //     + " SetTexture[_MainTex]{Combine primary*texture}"
    //     + "}"//end of pass
    //     + "}"//end of sub
    //     + "}";//end of shader
    void Start()
    {
        mat = GenMat(mi, mj);
    }
    void Update()
    {
        if (mi != i || mj != j)
        {
            mi = i;
            mj = j;
            mat = GenMat(mi, mj);
        }
        rd.material = mat;
    }
    void OnGUI()
    {
        GUI.skin = skin;
        i = (int)GUI.HorizontalSlider(ri, i, -40, 40);
        j = (int)GUI.HorizontalSlider(rj, j, -40, 40);
        GUI.Label(r1, "Offset  " + i + "    " + j);

    }
    Material GenMat(int i, int j)
    {
        //string offStr = " Offset " + " " + i + " , " + j;
        //string subNam = i + "" + j;
        //string shader = part1 + subNam + part2 + part3 + offStr + part4;
        var shader = Shader.Find("Tut/Shader/Common/Offset_2");
        Material m = new Material(shader)
        {
            hideFlags = HideFlags.HideAndDontSave,
            mainTexture = tex
        };
        m.SetInt("_Factor", i);
        m.SetInt("_Units", j);
        return m;
    }
}
