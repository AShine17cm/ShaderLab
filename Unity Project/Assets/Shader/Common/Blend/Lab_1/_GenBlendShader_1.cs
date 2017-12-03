using UnityEngine;
using System.Collections;
public class _GenBlendShader_1 : MonoBehaviour
{
    public Texture tex0;
    public Texture tex1;
    public Renderer rd1;
    public Renderer rd2;
    public Renderer rd1A;
    public Renderer rd2A;
    public Material[,] bMaterials;
    public Material[,] bMaterialsA;
    public GUISkin skin;
    public int i1, j1;
    public Rect rStr1;
    public Rect rI1;
    public Rect rJ1;
    public int i2, j2;
    public Rect rStr2;
    public Rect rI2;
    public Rect rJ2;
    public Rect[] rs;
    public string[] tips;
    string[] bMode;
    //string part1 =
    //     "Shader \"BlendTest";
    //string part2 =
    //     "{"
    //     + "Properties { _DstTex (\"DstTex\", 2D) =\"white\"{} "
    //     + "_SrcTex (\"SrcTex\", 2D) =\"white\"{}}"
    //     + "SubShader {"
    //     + "Pass{"
    //     + "SetTexture[_DstTex] {combine texture}"
    //     + "}"
    //     + "    Pass {";
    //string part3 =
    //      "        SetTexture [_SrcTex] { combine texture}"
    //     + "    }";
    //string part4 = " Pass{"
    //    + " Blend DstAlpha Zero"
    //    + " color(1,1,1,1)"
    //    + " }";
    //string part5 = " } }";
    void Start()
    {
        bMode = new string[] {"One","Zero","SrcColor","SrcAlpha",
            "DstColor","DstAlpha","OneMinusSrcColor","OneMinusSrcAlpha",
            "OneMinusDstColor","OneMinusDstAlpha" };
        Gen();
    }
    void Update()
    {
        rd1.material = bMaterials[i1, j1];
        rd1A.material = bMaterialsA[i1, j1];
        rd2.material = bMaterials[i2, j2];
        rd2A.material = bMaterialsA[i2, j2];
    }
    void OnGUI()
    {
        GUI.skin = skin;
        i1 = (int)GUI.HorizontalSlider(rI1, i1, 0, 9);
        j1 = (int)GUI.HorizontalSlider(rJ1, j1, 0, 9);
        GUI.Label(rStr1, "Blend" + "  " + bMode[i1] + "  " + bMode[j1]);
        i2 = (int)GUI.HorizontalSlider(rI2, i2, 0, 9);
        j2 = (int)GUI.HorizontalSlider(rJ2, j2, 0, 9);
        GUI.Label(rStr2, "Blend" + "  " + bMode[i2] + "  " + bMode[j2]);
        for (int i = 0; i < rs.Length; i++)
        {
            GUI.Label(rs[i], tips[i]);
        }
    }
    void Gen()
    {
        bMaterials = new Material[10, 10];
        bMaterialsA = new Material[10, 10];
        for (int i = 0; i < 10; i++)
        {
            for (int j = 0; j < 10; j++)
            {
                //string bm = "Blend" + "  " + bMode[i] + "  " + bMode[j];
                //string subNam = i + "" + j + "" + "\"";
                //string shader = part1 + subNam + part2 + bm + part3 + part5;
                //bMaterials[i, j] = new Material(shader);
                bMaterials[i, j] = new Material(Shader.Find("Hidden/Shader/Common/BlendTest" + i + j));
                bMaterials[i, j].hideFlags = HideFlags.HideAndDontSave;
                bMaterials[i, j].SetTexture("_DstTex", tex0);
                bMaterials[i, j].SetTexture("_SrcTex", tex1);

                //string shaderA = part1 + "A" + subNam + part2 + bm + part3 + part4 + part5;
                //bMaterialsA[i, j] = new Material(shaderA);
                bMaterialsA[i, j] = new Material(Shader.Find("Hidden/Shader/Common/BlendTestA" + i + j));
                bMaterialsA[i, j].hideFlags = HideFlags.HideAndDontSave;
                bMaterialsA[i, j].SetTexture("_DstTex", tex0);
                bMaterialsA[i, j].SetTexture("_SrcTex", tex1);
            }
        }
    }
}
